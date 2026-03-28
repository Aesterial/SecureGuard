enum ModalType { confirm() }

class Modal {
  final ModalType type;
  final String title;
  final String text;
  final List<Map<String, Type>> actions;
  int selected = 0;

  Modal(this.type, this.title, this.text, this.actions);
}
