import 'dart:math' as math;

import 'package:dart_console/dart_console.dart';
import 'package:secureguard_cli/src/app/secureguard_app.dart';
import 'package:secureguard_cli/src/core/grpc_errors.dart';
import 'package:secureguard_cli/src/core/store.dart' as store;
import 'package:secureguard_cli/src/models/config.dart';
import 'package:secureguard_cli/src/models/logger.dart';
import 'package:secureguard_cli/src/models/user.dart';
import 'package:secureguard_cli/src/tui/core/hotkeys.dart';
import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/core/tui_state.dart';
import 'package:secureguard_cli/src/tui/i18n/localization_service.dart';
import 'package:secureguard_cli/src/tui/i18n/map_translation_source.dart';
import 'package:secureguard_cli/src/tui/i18n/translations.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';
import 'package:secureguard_cli/src/tui/models/screen.dart';
import 'package:secureguard_cli/src/tui/render/frame_renderer.dart';
import 'package:secureguard_cli/src/tui/render/modal_renderer.dart';
import 'package:secureguard_cli/src/tui/screen/login_screen.dart';
import 'package:secureguard_cli/src/tui/screen/passwords_screen.dart';
import 'package:secureguard_cli/src/tui/screen/server_setup_screen.dart';
import 'package:secureguard_cli/src/tui/screen/sessions_screen.dart';
import 'package:secureguard_cli/src/tui/screen/settings_screen.dart';
import 'package:secureguard_cli/src/tui/screen/stats_screen.dart';
import 'package:secureguard_cli/src/tui/screen/welcome_screen.dart';

class Tui {
  SecureGuardApp _app;
  final Console _console;
  final TuiState _state;
  final LocalizationService _localization;
  final FrameRenderer _frameRenderer;
  final ModalRenderer _modalRenderer;
  final Map<Route, Screen> _screens;

  bool _running = true;

  Tui(
    SecureGuardApp app, {
    bool serverConfigured = true,
    bool serverLocked = false,
    Console? console,
    TuiState? state,
    LocalizationService? localization,
    FrameRenderer? frameRenderer,
    ModalRenderer? modalRenderer,
    Map<Route, Screen>? screens,
  }) : _app = app,
       _console = console ?? Console(),
       _state = state ?? TuiState(),
       _localization =
           localization ??
           LocalizationService(
             sources: <MapTranslationSource>[
               const MapTranslationSource(defaultTranslations),
             ],
             initialLanguage: Languages.russian,
           ),
       _frameRenderer = frameRenderer ?? FrameRenderer(),
       _modalRenderer = modalRenderer ?? ModalRenderer(),
       _screens =
           screens ??
           <Route, Screen>{
             Route.serverSetup: const ServerSetupScreen(),
             Route.welcome: const WelcomeScreen(),
             Route.login: const LoginScreen(),
             Route.sessions: const SessionsScreen(),
             Route.passwords: const PasswordsScreen(),
             Route.settings: const SettingsScreen(),
             Route.stats: const StatsScreen(),
           } {
    _state.serverConfigured = serverConfigured;
    _state.serverLocked = serverLocked;
    _state.serverConfig = _app.configService.current;
    store.onUnauthenticatedGrpc = _handleUnauthenticatedGrpc;
    if (_state.serverLocked &&
        _state.serverConfigured &&
        _state.currentRoute == Route.serverSetup) {
      _state.currentRoute = Route.welcome;
    }
  }

  SecureGuardApp get app => _app;

  Future<void> run() async {
    await _localization.bootstrap();
    await _loadServerLocalizations();

    try {
      _console.hideCursor();
      _console.clearScreen();
      _console.resetCursorPosition();
      await _enterCurrentRoute();

      while (_running) {
        final context = _createContext();
        final screen = _screens[_state.currentRoute]!;
        final selectedIndex = _normalizeSelection(
          itemCount: screen.buildView(context).items.length,
        );
        final view = screen.buildView(context);
        _frameRenderer.render(context, view, selectedIndex: selectedIndex);

        final key = _console.readKey();
        await _handleKey(context, screen, view.items.length, key);
      }
    } finally {
      _console.resetColorAttributes();
      _console.showCursor();
      _console.clearScreen();
    }
  }

  Future<void> close() async {
    if (store.onUnauthenticatedGrpc == _handleUnauthenticatedGrpc) {
      store.onUnauthenticatedGrpc = null;
    }
    await _app.close();
  }

  TuiContext _createContext() {
    final context = TuiContext(
      app: _app,
      console: _console,
      state: _state,
      localization: _localization,
      frameRenderer: _frameRenderer,
      modalRenderer: _modalRenderer,
    );
    context.navigate = _navigate;
    context.goBack = _goBack;
    context.configureServer = _configureServer;
    context.stop = () => _running = false;
    return context;
  }

  Future<void> _handleKey(
    TuiContext context,
    Screen screen,
    int itemCount,
    Key key,
  ) async {
    try {
      if (_isEscapeKey(key)) {
        await _goBack();
        return;
      }

      if (_isLogoutHotkey(key)) {
        await _logoutCurrentSession(context);
        return;
      }

      final pageJump = _pageJumpFromHotkey(key);
      if (pageJump != null) {
        _jumpToPage(pageJump, itemCount);
        return;
      }

      final route = Route.getByKey(key);
      if (route != null) {
        await _navigate(route);
        return;
      }

      if (key.isControl) {
        switch (key.controlChar) {
          case ControlCharacter.arrowLeft:
          case ControlCharacter.pageUp:
            _changePage(-1, itemCount);
            return;
          case ControlCharacter.arrowRight:
          case ControlCharacter.pageDown:
            _changePage(1, itemCount);
            return;
          case ControlCharacter.arrowUp:
            _moveSelection(-1, itemCount);
            return;
          case ControlCharacter.arrowDown:
            _moveSelection(1, itemCount);
            return;
          case ControlCharacter.enter:
            if (itemCount == 0) {
              return;
            }
            await screen.onSelect(
              context,
              _state.selectionFor(_state.currentRoute),
            );
            return;
          case ControlCharacter.ctrlC:
            _running = false;
            return;
          default:
            return;
        }
      }

      final index = int.tryParse(key.char);
      if (index != null && index > 0 && index <= selectorPageSize) {
        _selectVisibleIndex(index - 1, itemCount);
      }
    } on Object catch (error) {
      _setErrorStatus(context, error);
    }
  }

  Future<void> _navigate(Route route, {bool pushToHistory = true}) async {
    if (_state.currentRoute == route) {
      return;
    }

    final context = _createContext();
    if (!context.canAccessRoute(route)) {
      context.setStatus(context.accessDeniedMessage(route), isError: true);
      return;
    }

    final previous = _state.currentRoute;
    if (previous == Route.welcome) {
      _state.welcomeShown = true;
    }
    if (pushToHistory) {
      _state.pushHistory(previous);
    }

    _state.currentRoute = route;
    await _enterRoute(route, context);
  }

  Future<void> _goBack() async {
    final context = _createContext();
    Route? previous = _state.popHistory();
    while (previous != null && !context.canAccessRoute(previous)) {
      previous = _state.popHistory();
    }

    if (previous == null) {
      if (_state.currentRoute != Route.welcome &&
          _state.currentRoute != Route.serverSetup) {
        await _navigate(Route.welcome, pushToHistory: false);
        return;
      }
      if (_state.currentRoute == Route.welcome) {
        if (context.canAccessRoute(Route.serverSetup)) {
          await _navigate(Route.serverSetup, pushToHistory: false);
          return;
        }
        _running = false;
        return;
      }
      _running = false;
      return;
    }

    _state.currentRoute = previous;
    await _enterRoute(previous, context);
  }

  void _moveSelection(int delta, int itemCount) {
    if (itemCount <= 0) {
      _state.setSelection(_state.currentRoute, 0);
      return;
    }

    final current = _normalizeSelection(itemCount: itemCount);
    final next = current + delta;
    if (next < 0) {
      _state.setSelection(_state.currentRoute, 0);
      return;
    }
    if (next >= itemCount) {
      _state.setSelection(_state.currentRoute, itemCount - 1);
      return;
    }

    _state.setSelection(_state.currentRoute, next);
  }

  void _changePage(int delta, int itemCount) {
    if (itemCount <= 0) {
      return;
    }

    final current = _normalizeSelection(itemCount: itemCount);
    final currentPage = current ~/ selectorPageSize;
    final pageCount = ((itemCount - 1) ~/ selectorPageSize) + 1;
    final targetPage = (currentPage + delta).clamp(0, pageCount - 1);
    if (targetPage == currentPage) {
      return;
    }

    final localIndex = current % selectorPageSize;
    final targetIndex = math.min(
      targetPage * selectorPageSize + localIndex,
      itemCount - 1,
    );
    _state.setSelection(_state.currentRoute, targetIndex);
  }

  void _jumpToPage(int pageIndex, int itemCount) {
    if (itemCount <= 0) {
      return;
    }

    final pageCount = ((itemCount - 1) ~/ selectorPageSize) + 1;
    if (pageIndex < 0 || pageIndex >= pageCount) {
      return;
    }

    final current = _normalizeSelection(itemCount: itemCount);
    final localIndex = current % selectorPageSize;
    final targetIndex = math.min(
      pageIndex * selectorPageSize + localIndex,
      itemCount - 1,
    );
    _state.setSelection(_state.currentRoute, targetIndex);
  }

  void _selectVisibleIndex(int localIndex, int itemCount) {
    if (itemCount <= 0) {
      return;
    }

    final current = _normalizeSelection(itemCount: itemCount);
    final page = current ~/ selectorPageSize;
    final absoluteIndex = page * selectorPageSize + localIndex;
    if (absoluteIndex >= itemCount) {
      return;
    }

    _state.setSelection(_state.currentRoute, absoluteIndex);
  }

  Future<void> _configureServer(String endpoint) async {
    final config = Config.parse(endpoint);
    await _app.close();
    _app = SecureGuardApp.bootstrap(
      config: config,
      minLogLevel: LoggerLevel.info,
    );
    _state.serverConfigured = true;
    _state.serverConfig = config;
    _state.serverMetadata = null;
    _state.serverCompatibility = null;
    _state.clearHistory();
    _createContext().clearSession();
    _app.passwordCryptoService.clearCurrentEnvelope();
    await _loadServerLocalizations();

    try {
      _state.serverMetadata = await _app.metaService.fetchServerInfo();
      _state.serverCompatibility = await _app.metaService.checkCompatibility();
      _state.statusMessage = _createContext().tr('status.serverChanged');
      _state.statusIsError = false;
    } on Object catch (error) {
      _setErrorStatus(_createContext(), error);
    }
  }

  Future<void> _enterCurrentRoute() async {
    await _enterRoute(_state.currentRoute, _createContext());
  }

  Future<void> _enterRoute(Route route, TuiContext context) async {
    try {
      await _screens[route]!.onEnter(context);
    } on Object catch (error) {
      _setErrorStatus(context, error);
    }
  }

  Future<void> _loadServerLocalizations() async {
    if (!_state.serverConfigured) {
      await _localization.setOverlay(null);
      return;
    }

    try {
      final locales = await _app.metaService.locales();
      await _localization.setOverlay(
        MapTranslationSource(<Languages, Map<String, String>>{
          Languages.russian: locales.russian,
          Languages.english: locales.english,
        }),
      );
    } on Object catch (error) {
      await _localization.setOverlay(null);
      if (isUnauthenticatedGrpcError(error)) {
        return;
      }
    }
  }

  Future<void> _logoutCurrentSession(TuiContext context) async {
    if (!context.app.loginService.isAuthorized) {
      context.setStatus(context.tr('status.needAuthorization'), isError: true);
      return;
    }

    await context.app.loginService.logout();
    context.app.passwordCryptoService.clearCurrentEnvelope();
    context.clearSession();
    _state.clearHistory();
    _state.currentRoute = Route.login;
    context.setStatus(context.tr('status.loggedOut'));
  }

  void _handleUnauthenticatedGrpc() {
    _app.loginService.clearLocalSession();
    _app.passwordCryptoService.clearCurrentEnvelope();
    final context = _createContext();
    context.clearSession();
    _state.clearHistory();
    _state.currentRoute = Route.login;
    context.setStatus(context.tr('status.sessionExpired'), isError: true);
  }

  void _setErrorStatus(TuiContext context, Object error) {
    if (isUnauthenticatedGrpcError(error)) {
      return;
    }

    context.setStatus(error.toString(), isError: true);
  }

  int _normalizeSelection({required int itemCount}) {
    if (itemCount <= 0) {
      _state.setSelection(_state.currentRoute, 0);
      return 0;
    }

    final current = _state.selectionFor(_state.currentRoute);
    if (current < 0) {
      _state.setSelection(_state.currentRoute, 0);
      return 0;
    }
    if (current >= itemCount) {
      _state.setSelection(_state.currentRoute, itemCount - 1);
      return itemCount - 1;
    }

    return current;
  }

  bool _isEscapeKey(Key key) {
    if (key.isControl && key.controlChar == ControlCharacter.escape) {
      return true;
    }

    return !key.isControl &&
        key.char.isNotEmpty &&
        key.char.codeUnitAt(0) == 27;
  }

  bool _isLogoutHotkey(Key key) {
    return !key.isControl &&
        _app.loginService.isAuthorized &&
        logoutHotkeys.contains(key.char.toUpperCase());
  }

  int? _pageJumpFromHotkey(Key key) {
    if (key.isControl || key.char.isEmpty) {
      return null;
    }

    return pageJumpHotkeys[key.char];
  }
}
