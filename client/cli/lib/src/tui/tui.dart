import 'package:dart_console/dart_console.dart';
import 'package:secureguard_cli/src/app/secureguard_app.dart';
import 'package:secureguard_cli/src/models/user.dart';
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
import 'package:secureguard_cli/src/tui/screen/sessions_screen.dart';
import 'package:secureguard_cli/src/tui/screen/settings_screen.dart';
import 'package:secureguard_cli/src/tui/screen/stats_screen.dart';
import 'package:secureguard_cli/src/tui/screen/welcome_screen.dart';

class Tui {
  final SecureGuardApp app;
  final Console _console;
  final TuiState _state;
  final LocalizationService _localization;
  final FrameRenderer _frameRenderer;
  final ModalRenderer _modalRenderer;
  final Map<Route, Screen> _screens;

  bool _running = true;

  Tui(this.app, {
    Console? console,
    TuiState? state,
    LocalizationService? localization,
    FrameRenderer? frameRenderer,
    ModalRenderer? modalRenderer,
    Map<Route, Screen>? screens,
  })
      : _console = console ?? Console(),
        _state = state ?? TuiState(),
        _localization = localization ??
            LocalizationService(
              sources: <MapTranslationSource>[
                const MapTranslationSource(defaultTranslations),
              ],
              initialLanguage: Languages.russian,
            ),
        _frameRenderer = frameRenderer ?? FrameRenderer(),
        _modalRenderer = modalRenderer ?? ModalRenderer(),
        _screens = screens ??
            <Route, Screen>{
              Route.welcome: const WelcomeScreen(),
              Route.login: const LoginScreen(),
              Route.sessions: const SessionsScreen(),
              Route.passwords: const PasswordsScreen(),
              Route.settings: const SettingsScreen(),
              Route.stats: const StatsScreen(),
            };

  Future<void> run() async {
    final context = _createContext();
    await _localization.bootstrap();

    try {
      _console.hideCursor();
      _console.clearScreen();
      _console.resetCursorPosition();
      await _screens[_state.currentRoute]!.onEnter(context);

      while (_running) {
        final screen = _screens[_state.currentRoute]!;
        final selectedIndex = _state.selectionFor(_state.currentRoute);
        final view = screen.buildView(context);
        _frameRenderer.render(
          context,
          view,
          selectedIndex: selectedIndex >= view.items.length ? 0 : selectedIndex,
        );

        final key = _console.readKey();
        await _handleKey(context, screen, view.items.length, key);
      }
    } finally {
      _console.resetColorAttributes();
      _console.showCursor();
      _console.clearScreen();
    }
  }

  TuiContext _createContext() {
    final context = TuiContext(
      app: app,
      console: _console,
      state: _state,
      localization: _localization,
      frameRenderer: _frameRenderer,
      modalRenderer: _modalRenderer,
    );
    context.navigate = _navigate;
    context.goBack = _goBack;
    context.stop = () => _running = false;
    return context;
  }

  Future<void> _handleKey(TuiContext context,
      Screen screen,
      int itemCount,
      Key key,) async {
    try {
      final route = Route.getByKey(key);
      if (route != null) {
        await _navigate(route);
        return;
      }

      if (_isEscapeKey(key)) {
        await _goBack();
        return;
      }

      if (key.isControl) {
        switch (key.controlChar) {
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
                context, _state.selectionFor(_state.currentRoute));
            return;
          case ControlCharacter.ctrlC:
            _running = false;
            return;
          default:
            return;
        }
      }

      final index = int.tryParse(key.char);
      if (index != null && index > 0 && index <= itemCount) {
        _state.setSelection(_state.currentRoute, index - 1);
      }
    } on Exception catch (error) {
      context.setStatus(error.toString(), isError: true);
    }
  }

  Future<void> _navigate(Route route, {bool pushToHistory = true}) async {
    if (_state.currentRoute == route) {
      return;
    }

    final previous = _state.currentRoute;
    if (previous == Route.welcome) {
      _state.welcomeShown = true;
    } else if (pushToHistory) {
      _state.pushHistory(previous);
    }

    _state.currentRoute = route;
    final context = _createContext();
    await _screens[route]!.onEnter(context);
  }

  Future<void> _goBack() async {
    final previous = _state.popHistory();
    if (previous == null) {
      _running = false;
      return;
    }

    _state.currentRoute = previous;
    final context = _createContext();
    await _screens[previous]!.onEnter(context);
  }

  void _moveSelection(int delta, int itemCount) {
    if (itemCount <= 0) {
      _state.setSelection(_state.currentRoute, 0);
      return;
    }

    final current = _state.selectionFor(_state.currentRoute);
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

  bool _isEscapeKey(Key key) {
    if (key.isControl && key.controlChar == ControlCharacter.escape) {
      return true;
    }

    return !key.isControl &&
        key.char.isNotEmpty &&
        key.char.codeUnitAt(0) == 27;
  }
}
