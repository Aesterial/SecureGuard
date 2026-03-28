import 'package:dart_console/dart_console.dart';

enum Route {
  welcome('screen.welcome.title', null, true),
  login('screen.login.title', 'L', false),
  sessions('screen.sessions.title', 'S', false),
  passwords('screen.passwords.title', 'P', false),
  settings('screen.settings.title', 'T', false),
  stats('screen.stats.title', 'A', false);

  final String titleKey;
  final String? hotkey;
  final bool isStarter;

  const Route(this.titleKey, this.hotkey, this.isStarter);

  static Route getStarter() {
    return Route.values.firstWhere((route) => route.isStarter);
  }

  static Route? getByKey(Key key) {
    if (key.isControl) {
      return null;
    }

    final pressed = key.char.toUpperCase();
    for (final route in Route.values) {
      if (route.hotkey == pressed) {
        return route;
      }
    }

    return null;
  }
}
