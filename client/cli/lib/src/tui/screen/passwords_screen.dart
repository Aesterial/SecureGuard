import 'package:secureguard_cli/src/models/passwords.dart';
import 'package:secureguard_cli/src/models/vault.dart';
import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/modals/enter_value.dart';
import 'package:secureguard_cli/src/tui/models/modal.dart';
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
        (password) => SelectorItem(
          label: password.service.name.isEmpty
              ? password.service.url
              : password.service.name,
          subtitle: password.hasEncryptedLogin
              ? '******'
              : password.loginPreview,
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
      context.tr('passwords.summary', <String, String>{
        'count': context.state.passwords.length.toString(),
      }),
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
      context.tr('passwords.selected', <String, String>{
        'service': password.service.name,
      }),
      context.tr('passwords.id', <String, String>{'value': password.id}),
      context.tr('passwords.service', <String, String>{
        'value': password.service.url,
      }),
      context.tr('passwords.login', <String, String>{
        'value': password.hasEncryptedLogin ? '******' : password.loginPreview,
      }),
      context.tr('passwords.password', <String, String>{
        'value': password.encryptedPassword.isEmpty ? '-' : '******',
      }),
      context.tr('passwords.encryption', <String, String>{
        'value':
            password.legacyEnvelope?.encryptionAlgorithm ??
            context
                .app
                .passwordCryptoService
                .currentBundle
                ?.envelope
                .encryptionAlgorithm ??
            cryptToEncryptionAlgorithm(context.state.crypt),
      }),
      context.tr('passwords.created', <String, String>{
        'value': formatDate(password.createdAt),
      }),
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
      case 2:
        await _openPasswordActions(context);
        return;
      default:
        await _openPasswordActions(context);
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

    final encrypted = await context.app.passwordCryptoService.encryptEntry(
      login: values['login']!,
      password: values['password']!,
      seedPhrase: values['seedPhrase']!,
    );

    await context.app.passwordsService.create(
      serviceUrl: values['serviceUrl']!,
      login: encrypted.encryptedLogin,
      cipher: encrypted.encryptedPassword,
      version: EncryptedPasswordRecord.version,
      nonce: EncryptedPasswordRecord.nonce,
      aad: EncryptedPasswordRecord.aad,
      metadata: EncryptedPasswordRecord.metadata,
    );

    await _refresh(context);
    context.setStatus(context.tr('status.passwordCreated'));
  }

  Future<void> _openPasswordActions(TuiContext context) async {
    if (!context.app.loginService.isAuthorized) {
      context.setStatus(context.tr('status.needAuthorization'), isError: true);
      return;
    }

    final password = _selectedPassword(context);
    if (password == null) {
      context.setStatus(context.tr('passwords.empty'), isError: true);
      return;
    }

    final selected = await context.pickAction(
      buildPasswordActionsModal(context),
    );
    if (selected == null || selected == 3) {
      return;
    }

    switch (selected) {
      case 0:
        await _decryptPassword(context, password);
        return;
      case 1:
        await _updatePassword(context, password);
        return;
      case 2:
        await _deletePassword(context, password);
        return;
      default:
        return;
    }
  }

  Future<void> _decryptPassword(TuiContext context, Password password) async {
    if (!context.app.loginService.isAuthorized) {
      context.setStatus(context.tr('status.needAuthorization'), isError: true);
      return;
    }

    final masterKeyValues = await context.prompt(buildMasterKeyModal(context));
    if (masterKeyValues == null) {
      return;
    }

    final decrypted = await context.app.passwordCryptoService
        .decryptEntryWithMasterKey(
          password: password,
          masterKey: masterKeyValues['masterKey']!,
        );
    final selected = await context.pickAction(
      buildRevealPasswordModal(context),
    );
    if (selected == null || selected == 2) {
      return;
    }

    final copiedValue = selected == 0 ? decrypted.login : decrypted.password;
    await context.app.clipboardService.copyTemporarily(copiedValue);
    context.setStatus(context.tr('status.copiedToClipboard'));
  }

  Future<void> _updatePassword(TuiContext context, Password password) async {
    if (!context.app.loginService.isAuthorized) {
      context.setStatus(context.tr('status.needAuthorization'), isError: true);
      return;
    }

    final seedValues = await context.prompt(buildSeedPhraseModal(context));
    if (seedValues == null) {
      context.setStatus(context.tr('common.cancelled'));
      return;
    }

    final current = await context.app.passwordCryptoService.decryptEntry(
      password: password,
      seedPhrase: seedValues['seedPhrase']!,
    );

    final values = await context.prompt(
      buildUpdatePasswordModal(
        context,
        serviceUrl: password.service.url,
        login: current.login,
      ),
    );
    if (values == null) {
      context.setStatus(context.tr('common.cancelled'));
      return;
    }

    final nextServiceUrl = values['serviceUrl']!;
    final nextLogin = values['login']!;
    final nextPassword = values['password']!;
    final encrypted = await context.app.passwordCryptoService.encryptEntry(
      login: nextLogin,
      password: nextPassword,
      seedPhrase: values['seedPhrase']!.isNotEmpty
          ? values['seedPhrase']!
          : seedValues['seedPhrase']!,
    );

    if (nextServiceUrl != password.service.url) {
      await context.app.passwordsService.update(
        id: password.id,
        serviceUrl: nextServiceUrl,
        salt: 'inline-v1',
      );
    }
    await context.app.passwordsService.update(
      id: password.id,
      login: encrypted.encryptedLogin,
      salt: 'inline-v1',
    );
    await context.app.passwordsService.update(
      id: password.id,
      pass: encrypted.encryptedPassword,
      salt: 'inline-v1',
    );
    await _refresh(context);
    context.setStatus(context.tr('status.passwordUpdated'));
  }

  Future<void> _deletePassword(TuiContext context, Password password) async {
    if (!context.app.loginService.isAuthorized) {
      context.setStatus(context.tr('status.needAuthorization'), isError: true);
      return;
    }

    final confirmed = await context.confirm(
      ConfirmModal(
        title: context.tr('modal.passwordDelete.title'),
        description: context.tr('modal.passwordDelete.description'),
        confirmLabel: context.tr('common.confirm'),
        cancelLabel: context.tr('common.cancel'),
      ),
    );
    if (!confirmed) {
      context.setStatus(context.tr('common.cancelled'));
      return;
    }

    await context.app.passwordsService.delete(id: password.id);
    await _refresh(context);
    context.setStatus(context.tr('status.passwordDeleted'));
  }
}
