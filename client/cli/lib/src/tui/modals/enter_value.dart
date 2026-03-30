import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/models/modal.dart';

ValueModal buildLoginModal(TuiContext context) {
  return ValueModal(
    title: context.tr('modal.login.title'),
    description: context.tr('modal.login.description'),
    fields: <ModalField>[
      ModalField(name: 'username', label: context.tr('field.username')),
      ModalField(
        name: 'password',
        label: context.tr('field.password'),
        obscure: true,
      ),
    ],
  );
}

ValueModal buildRegistrationModal(TuiContext context) {
  return ValueModal(
    title: context.tr('modal.register.title'),
    description: context.tr('modal.register.description'),
    fields: <ModalField>[
      ModalField(name: 'username', label: context.tr('field.username')),
      ModalField(
        name: 'password',
        label: context.tr('field.password'),
        obscure: true,
      ),
      ModalField(
        name: 'seedPhrase',
        label: context.tr('field.seedPhrase'),
        obscure: true,
      ),
    ],
  );
}

ValueModal buildCreatePasswordModal(TuiContext context) {
  return ValueModal(
    title: context.tr('modal.password.title'),
    description: context.tr('modal.password.description'),
    fields: <ModalField>[
      ModalField(name: 'serviceUrl', label: context.tr('field.serviceUrl')),
      ModalField(name: 'login', label: context.tr('field.login')),
      ModalField(
        name: 'password',
        label: context.tr('field.password'),
        obscure: true,
      ),
      ModalField(
        name: 'seedPhrase',
        label: context.tr('field.seedPhrase'),
        obscure: true,
      ),
    ],
  );
}

ActionModal buildPasswordActionsModal(TuiContext context) {
  return ActionModal(
    title: context.tr('modal.passwordActions.title'),
    description: context.tr('modal.passwordActions.description'),
    options: <ActionModalOption>[
      ActionModalOption(label: context.tr('selector.revealPassword')),
      ActionModalOption(label: context.tr('selector.updatePassword')),
      ActionModalOption(label: context.tr('selector.deletePassword')),
      ActionModalOption(label: context.tr('common.close')),
    ],
  );
}

ValueModal buildUpdatePasswordModal(
  TuiContext context, {
  required String serviceUrl,
  required String login,
}) {
  return ValueModal(
    title: context.tr('modal.passwordUpdate.title'),
    description: context.tr('modal.passwordUpdate.description'),
    fields: <ModalField>[
      ModalField(
        name: 'serviceUrl',
        label: context.tr('field.serviceUrl'),
        defaultValue: serviceUrl,
      ),
      ModalField(
        name: 'login',
        label: context.tr('field.login'),
        defaultValue: login,
      ),
      ModalField(
        name: 'password',
        label: context.tr('field.password'),
        obscure: true,
      ),
      ModalField(
        name: 'seedPhrase',
        label: context.tr('field.seedPhrase'),
        obscure: true,
      ),
    ],
  );
}

ValueModal buildMasterKeyModal(TuiContext context) {
  return ValueModal(
    title: context.tr('modal.masterKey.title'),
    description: context.tr('modal.masterKey.description'),
    fields: <ModalField>[
      ModalField(
        name: 'masterKey',
        label: context.tr('field.masterKeyValue'),
        obscure: true,
      ),
    ],
  );
}

ValueModal buildSeedPhraseModal(TuiContext context) {
  return ValueModal(
    title: context.tr('modal.seedPhrase.title'),
    description: context.tr('modal.seedPhrase.description'),
    fields: <ModalField>[
      ModalField(
        name: 'seedPhrase',
        label: context.tr('field.seedPhrase'),
        obscure: true,
      ),
    ],
  );
}

ActionModal buildRevealPasswordModal(TuiContext context) {
  return ActionModal(
    title: context.tr('modal.passwordReveal.title'),
    description: context.tr('modal.passwordReveal.description'),
    options: <ActionModalOption>[
      ActionModalOption(label: context.tr('modal.passwordReveal.loginAction')),
      ActionModalOption(
        label: context.tr('modal.passwordReveal.passwordAction'),
      ),
      ActionModalOption(label: context.tr('modal.passwordReveal.closeAction')),
    ],
  );
}

ValueModal buildDateModal(TuiContext context) {
  return ValueModal(
    title: context.tr('modal.date.title'),
    description: context.tr('modal.date.description'),
    fields: <ModalField>[
      ModalField(
        name: 'date',
        label: context.tr('field.date'),
        defaultValue: DateTime.now().toIso8601String().substring(0, 10),
      ),
    ],
  );
}

ValueModal buildServerEndpointModal(TuiContext context) {
  return ValueModal(
    title: context.tr('modal.server.title'),
    description: context.tr('modal.server.description'),
    fields: <ModalField>[
      ModalField(
        name: 'endpoint',
        label: context.tr('field.endpoint'),
        defaultValue: context.currentConfig.serverUri.toString(),
      ),
    ],
  );
}
