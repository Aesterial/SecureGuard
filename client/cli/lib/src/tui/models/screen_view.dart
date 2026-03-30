import 'package:secureguard_cli/src/tui/models/selector_item.dart';

class ScreenView {
  final String title;
  final List<SelectorItem> items;
  final List<String> content;

  const ScreenView({
    required this.title,
    required this.items,
    required this.content,
  });
}
