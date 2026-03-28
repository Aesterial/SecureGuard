import 'package:dart_console/dart_console.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';

abstract interface class Screen {
  void render(Console console);

  Route? onKey(Key key);
}
