import 'package:secureguard_cli/src/models/user.dart';
import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';
import 'package:secureguard_cli/src/tui/models/selector_item.dart';
import 'package:secureguard_cli/src/tui/screen/base_screen.dart';

class SettingsScreen extends BaseScreen {
  const SettingsScreen();

  @override
  Route get route => Route.settings;

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
      SelectorItem(label: context.tr('selector.changeLanguage')),
      SelectorItem(label: context.tr('selector.changeTheme')),
      SelectorItem(label: context.tr('selector.changeCrypt')),
      SelectorItem(label: context.tr('selector.refresh')),
    ];
  }

  @override
  List<String> buildContent(TuiContext context) {
    return <String>[
      context.tr('settings.endpoint', <String, String>{
        'value': context.currentConfig.serverUri.toString(),
      }),
      context.tr('settings.language', <String, String>{
        'value': languageLabel(context, context.state.locale),
      }),
      context.tr('settings.theme', <String, String>{
        'value': themeLabel(context, context.state.theme),
      }),
      context.tr('settings.crypt', <String, String>{
        'value': cryptLabel(context, context.state.crypt),
      }),
      context.tr('settings.sync', <String, String>{
        'value': context.app.loginService.isAuthorized
            ? context.tr('common.enabled')
            : context.tr('common.disabled'),
      }),
    ];
  }

  @override
  Future<void> onSelect(TuiContext context, int index) async {
    switch (index) {
      case 0:
        await _changeLanguage(context);
        return;
      case 1:
        await _changeTheme(context);
        return;
      case 2:
        await _changeCrypt(context);
        return;
      case 3:
        context.state.serverCompatibility = await context.app.metaService
            .checkCompatibility();
        context.setStatus(context.tr('status.serverLoaded'));
        return;
      default:
        context.setStatus(context.tr('status.selectionOnly'));
    }
  }

  Future<void> _changeLanguage(TuiContext context) async {
    final next = context.state.locale == Languages.russian
        ? Languages.english
        : Languages.russian;

    if (context.app.loginService.isAuthorized) {
      await context.app.userService.changeLanguage(lang: next);
    }

    await context.useLanguage(next);
    context.setStatus(
      context.app.loginService.isAuthorized
          ? context.tr('status.languageChanged')
          : context.tr('status.localOnly'),
    );
  }

  Future<void> _changeTheme(TuiContext context) async {
    final next = context.state.theme == Themes.black
        ? Themes.white
        : Themes.black;

    if (context.app.loginService.isAuthorized) {
      context.state.theme = await context.app.userService.changeTheme(
        theme: next,
      );
      context.setStatus(context.tr('status.themeChanged'));
      return;
    }

    context.state.theme = next;
    context.setStatus(context.tr('status.localOnly'));
  }

  Future<void> _changeCrypt(TuiContext context) async {
    final next = context.state.crypt == Crypt.argon2ID
        ? Crypt.sha256
        : Crypt.argon2ID;

    if (context.app.loginService.isAuthorized) {
      context.state.crypt = await context.app.userService.changeCrypt(
        crypt: next,
      );
      context.setStatus(context.tr('status.cryptChanged'));
      return;
    }

    context.state.crypt = next;
    context.setStatus(context.tr('status.localOnly'));
  }
}
