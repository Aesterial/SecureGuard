import 'package:secureguard_cli/src/models/passwords.dart';
import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/modals/enter_value.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';
import 'package:secureguard_cli/src/tui/models/selector_item.dart';
import 'package:secureguard_cli/src/tui/screen/base_screen.dart';

class PasswordsScreen extends BaseScreen {
  const PasswordsScreen();

  @override
  Route get route => Route.passwords;

  @override
  Future<void> onEnter(TuiContext context) async {
    if (context.app.loginService.isAuthorized &&
        context.state.passwords.isEmpty) {
      await _refresh(context);
    }
  }

  @override
  List<SelectorItem> buildItems(TuiContext context) {
    final items = <SelectorItem>[
      SelectorItem(label: context.tr('selector.refresh')),
      SelectorItem(label: context.tr('selector.createPassword')),
    ];

    items.addAll(
      context.state.passwords.map(
            (password) =>
            SelectorItem(
              label: password.service.name.isEmpty
                  ? password.service.url
                  : password.service.name,
              subtitle: password.login,
            ),
      ),
    );

    return items;
  }

  @override
  List<String> buildContent(TuiContext context) {
    if (!context.app.loginService.isAuthorized) {
      return <String>[context.tr('status.needAuthorization')];
    }

    final lines = <String>[
      context.tr(
        'passwords.summary',
        <String, String>{'count': context.state.passwords.length.toString()},
      ),
      '',
    ];

    final password = _selectedPassword(context);
    if (password == null) {
      lines.add(
        context.state.passwords.isEmpty
            ? context.tr('passwords.empty')
            : context.tr('status.selectionOnly'),
      );
      lines.add('');
      lines.add(context.tr('passwords.note'));
      return lines;
    }

    lines.addAll(<String>[
      context.tr(
        'passwords.selected',
        <String, String>{'service': password.service.name},
      ),
      context.tr(
        'passwords.service',
        <String, String>{'value': password.service.url},
      ),
      context.tr('passwords.login', <String, String>{'value': password.login}),
      context.tr(
          'passwords.password', <String, String>{'value': password.pass}),
      context.tr(
        'passwords.created',
        <String, String>{'value': formatDate(password.createdAt)},
      ),
      '',
      context.tr('passwords.note'),
    ]);

    return lines;
  }

  @override
  Future<void> onSelect(TuiContext context, int index) async {
    switch (index) {
      case 0:
        await _refresh(context);
        return;
      case 1:
        await _createPassword(context);
        return;
      default:
        context.setStatus(context.tr('status.selectionOnly'));
    }
  }

  Password? _selectedPassword(TuiContext context) {
    final index = context.state.selectionFor(route) - 2;
    if (index < 0 || index >= context.state.passwords.length) {
      return null;
    }

    return context.state.passwords[index];
  }

  Future<void> _refresh(TuiContext context) async {
    if (!context.app.loginService.isAuthorized) {
      context.setStatus(context.tr('status.needAuthorization'), isError: true);
      return;
    }

    context.state.passwords = await context.app.passwordsService.getList(20, 0);
    context.setStatus(context.tr('status.passwordsLoaded'));
  }

  Future<void> _createPassword(TuiContext context) async {
    if (!context.app.loginService.isAuthorized) {
      context.setStatus(context.tr('status.needAuthorization'), isError: true);
      return;
    }

    final values = await context.prompt(buildCreatePasswordModal(context));
    if (values == null) {
      context.setStatus(context.tr('common.cancelled'));
      return;
    }

    await context.app.passwordsService.create(
      serviceUrl: values['serviceUrl']!,
      login: values['login']!,
      cipher: values['ciphertext']!,
      version: int.parse(values['version']!),
      nonce: values['nonce']!,
      aad: _parseAad(values['aad']!),
      metadata: values['metadata']!,
    );

    await _refresh(context);
    context.setStatus(context.tr('status.passwordCreated'));
  }

  List<int> _parseAad(String raw) {
    if (raw
        .trim()
        .isEmpty) {
      return const <int>[];
    }

    return raw
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .map(int.parse)
        .toList();
  }
}
