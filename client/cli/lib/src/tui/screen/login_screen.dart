import 'package:fixnum/fixnum.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';
import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/modals/enter_value.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';
import 'package:secureguard_cli/src/tui/models/selector_item.dart';
import 'package:secureguard_cli/src/tui/screen/base_screen.dart';

class LoginScreen extends BaseScreen {
  const LoginScreen();

  @override
  Route get route => Route.login;

  @override
  Future<void> onEnter(TuiContext context) async {
    if (context.app.loginService.isAuthorized &&
        context.state.currentUser == null) {
      await context.refreshUser();
    }
  }

  @override
  List<SelectorItem> buildItems(TuiContext context) {
    return <SelectorItem>[
      SelectorItem(label: context.tr('selector.authorize')),
      SelectorItem(label: context.tr('selector.register')),
      SelectorItem(label: context.tr('selector.logout')),
    ];
  }

  @override
  List<String> buildContent(TuiContext context) {
    final user = context.state.currentUser;
    final status = context.app.loginService.isAuthorized
        ? context.tr('common.authorized')
        : context.tr('common.notAuthorized');

    return <String>[
      context.tr('login.status', <String, String>{'status': status}),
      '',
      context.tr('login.user', <String, String>{
        'username': user?.username ?? context.tr('common.guest'),
      }),
      context.tr('login.staff', <String, String>{
        'value': user?.staffMember == true ? '✅' : '❌',
      }),
      '',
      context.tr('login.note'),
    ];
  }

  @override
  Future<void> onSelect(TuiContext context, int index) async {
    switch (index) {
      case 0:
        await _authorize(context);
        return;
      case 1:
        await _register(context);
        return;
      case 2:
        await _logout(context);
        return;
      default:
        context.setStatus(context.tr('status.selectionOnly'));
    }
  }

  Future<void> _authorize(TuiContext context) async {
    final values = await context.prompt(buildLoginModal(context));
    if (values == null) {
      context.setStatus(context.tr('common.cancelled'));
      return;
    }

    final session = await context.app.loginService.authorize(
      username: values['username']!,
      password: values['password']!,
    );

    if (session.user.keyBundle != null) {
      context.app.passwordCryptoService.rememberBundle(session.user.keyBundle!);
    }
    context.applyAuthSession(session);
    await context.useLanguage(session.user.preferences.lang);
    context.setStatus(context.tr('status.authorized'));
    await context.navigate(Route.passwords, pushToHistory: false);
  }

  Future<void> _register(TuiContext context) async {
    final values = await context.prompt(buildRegistrationModal(context));
    if (values == null) {
      context.setStatus(context.tr('common.cancelled'));
      return;
    }

    final material = await context.app.passwordCryptoService
        .buildRegistrationMaterial(
          seedPhrase: values['seedPhrase']!,
          crypt: context.state.crypt,
        );
    final session = await context.app.loginService.register(
      username: values['username']!,
      password: values['password']!,
      wrappedMasterKey: material.bundle.envelope.wrappedMasterKey,
      salt: material.bundle.envelope.wrappingSalt,
      kdfParams: Kdf(
        version: material.bundle.kdfVersion,
        memory: Int64(material.bundle.kdfMemory),
        iterations: material.bundle.kdfIterations,
        parallelism: material.bundle.kdfParallelism,
      ),
    );

    context.app.passwordCryptoService.rememberBundle(
      session.user.keyBundle ?? material.bundle,
    );
    context.applyAuthSession(session);
    await context.useLanguage(session.user.preferences.lang);
    context.setStatus(context.tr('status.registered'));
    await context.navigate(Route.passwords, pushToHistory: false);
  }

  Future<void> _logout(TuiContext context) async {
    if (!context.app.loginService.isAuthorized) {
      context.setStatus(context.tr('status.needAuthorization'), isError: true);
      return;
    }

    await context.app.loginService.logout();
    context.app.passwordCryptoService.clearCurrentEnvelope();
    context.clearSession();
    context.setStatus(context.tr('status.loggedOut'));
  }
}
