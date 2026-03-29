class ModalField {
  final String name;
  final String label;
  final String? defaultValue;
  final bool obscure;

  const ModalField({
    required this.name,
    required this.label,
    this.defaultValue,
    this.obscure = false,
  });
}

class ModalRequest {
  final String title;
  final String description;

  const ModalRequest({required this.title, required this.description});
}

class ActionModalOption {
  final String label;

  const ActionModalOption({required this.label});
}

class ConfirmModal extends ModalRequest {
  final String confirmLabel;
  final String cancelLabel;

  const ConfirmModal({
    required super.title,
    required super.description,
    required this.confirmLabel,
    required this.cancelLabel,
  });
}

class ValueModal extends ModalRequest {
  final List<ModalField> fields;

  const ValueModal({
    required super.title,
    required super.description,
    required this.fields,
  });
}

class ActionModal extends ModalRequest {
  final List<ActionModalOption> options;

  const ActionModal({
    required super.title,
    required super.description,
    required this.options,
  });
}
