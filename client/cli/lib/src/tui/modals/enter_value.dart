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
        name: 'masterKey',
        label: context.tr('field.masterKey'),
        obscure: true,
      ),
      ModalField(name: 'salt', label: context.tr('field.salt')),
      ModalField(
        name: 'kdfVersion',
        label: context.tr('field.kdfVersion'),
        defaultValue: '1',
      ),
      ModalField(
        name: 'kdfMemory',
        label: context.tr('field.kdfMemory'),
        defaultValue: '65536',
      ),
      ModalField(
        name: 'kdfIterations',
        label: context.tr('field.kdfIterations'),
        defaultValue: '3',
      ),
      ModalField(
        name: 'kdfParallelism',
        label: context.tr('field.kdfParallelism'),
        defaultValue: '2',
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
      ModalField(name: 'ciphertext', label: context.tr('field.ciphertext')),
      ModalField(name: 'nonce', label: context.tr('field.nonce')),
      ModalField(
        name: 'version',
        label: context.tr('field.version'),
        defaultValue: '1',
      ),
      ModalField(name: 'aad', label: context.tr('field.aad'), defaultValue: ''),
      ModalField(
        name: 'metadata',
        label: context.tr('field.metadata'),
        defaultValue: '',
      ),
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
