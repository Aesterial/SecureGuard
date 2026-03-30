import 'package:dart_console/dart_console.dart';
import 'package:secureguard_cli/src/app/secureguard_app.dart';
import 'package:secureguard_cli/src/domain/models/auth_session.dart';
import 'package:secureguard_cli/src/models/config.dart';
import 'package:secureguard_cli/src/models/passwords.dart';
import 'package:secureguard_cli/src/models/sessions.dart';
import 'package:secureguard_cli/src/models/user.dart';
import 'package:secureguard_cli/src/tui/core/tui_state.dart';
import 'package:secureguard_cli/src/tui/i18n/localization_service.dart';
import 'package:secureguard_cli/src/tui/models/modal.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';
import 'package:secureguard_cli/src/tui/render/frame_renderer.dart';
import 'package:secureguard_cli/src/tui/render/modal_renderer.dart';

typedef NavigateCallback =
    Future<void> Function(Route route, {bool pushToHistory});
typedef AsyncVoidCallback = Future<void> Function();
typedef ConfigureServerCallback = Future<void> Function(String endpoint);

class TuiContext {
  final SecureGuardApp app;
  final Console console;
  final TuiState state;
  final LocalizationService localization;
  final FrameRenderer frameRenderer;
  final ModalRenderer modalRenderer;

  late NavigateCallback navigate;
  late AsyncVoidCallback goBack;
  late ConfigureServerCallback configureServer;
  late void Function() stop;

  TuiContext({
    required this.app,
    required this.console,
    required this.state,
    required this.localization,
    required this.frameRenderer,
    required this.modalRenderer,
  });

  String tr(
    String key, [
    Map<String, String> params = const <String, String>{},
  ]) {
    return localization.translate(key, params);
  }

  Future<void> useLanguage(Languages language) async {
    state.locale = language;
    await localization.use(language);
  }

  Config get currentConfig => state.serverConfig ?? app.configService.current;

  bool get hasConfiguredServer => state.serverConfigured;

  bool get isServerLocked => state.serverLocked;

  void applyUser(User user) {
    state.currentUser = user;
    state.locale = user.preferences.lang;
    state.theme = user.preferences.theme;
    state.crypt = user.preferences.crypt;
    if (user.keyBundle != null) {
      app.passwordCryptoService.rememberBundle(user.keyBundle!);
    } else {
      app.passwordCryptoService.clearCurrentEnvelope();
    }
  }

  void applyAuthSession(AuthSession session) {
    state.authSession = session;
    applyUser(session.user);
  }

  void clearSession() {
    state.authSession = null;
    state.currentUser = null;
    state.sessions = const <Session>[];
    state.passwords = const <Password>[];
    state.stats = null;
    state.total = null;
    app.passwordCryptoService.clearCurrentEnvelope();
  }

  bool get hasAdminAccess {
    return app.loginService.isAuthorized &&
        state.currentUser != null &&
        state.currentUser!.staffMember;
  }

  bool canAccessRoute(Route route) {
    return switch (route) {
      Route.serverSetup => !isServerLocked,
      Route.login => !app.loginService.isAuthorized,
      Route.stats => hasAdminAccess,
      _ => true,
    };
  }

  String accessDeniedMessage(Route route) {
    return switch (route) {
      Route.serverSetup => tr('status.serverLocked'),
      Route.login => tr('status.alreadyAuthorized'),
      Route.stats => tr('status.adminRequired'),
      _ => tr('status.selectionOnly'),
    };
  }

  void setStatus(String message, {bool isError = false}) {
    state.statusMessage = message;
    state.statusIsError = isError;
  }

  void clearStatus() {
    state.statusMessage = null;
    state.statusIsError = false;
  }

  Future<bool> confirm(ConfirmModal modal) {
    return modalRenderer.confirm(this, modal);
  }

  Future<Map<String, String>?> prompt(ValueModal modal) {
    return modalRenderer.promptValues(this, modal);
  }

  Future<int?> pickAction(ActionModal modal) {
    return modalRenderer.pickAction(this, modal);
  }

  Future<void> refreshUser() async {
    final user = await app.userService.info();
    applyUser(user);
    await useLanguage(user.preferences.lang);
  }
}
