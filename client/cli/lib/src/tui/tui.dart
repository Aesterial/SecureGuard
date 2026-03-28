import 'package:dart_console/dart_console.dart';
import 'package:secureguard_cli/src/tui/models/modal.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';
import 'package:secureguard_cli/src/tui/models/screen.dart';

class Tui {
  final Map<Route, Screen> keys;
  final console = Console();
  bool running = true;
  Route currentRoute = Route.getStarter();
  Modal? currentModal;
  int selectedElement = 0;

  Tui(this.keys);

  Screen? _handleKey(Key key) {
    var route = Route.getByKey(key);
    return keys[route];
  }

  void run() {
    try {
      console.hideCursor();
      currentRoute.screen.render(console);
      while (running) {
        final key = console.readKey();
        _handleKey(key)!.render(console);
      }
    } finally {
      console.clearScreen();
    }
  }
}
