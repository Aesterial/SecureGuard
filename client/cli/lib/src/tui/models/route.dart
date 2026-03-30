import 'package:dart_console/dart_console.dart';

enum Route {
  serverSetup('screen.serverSetup.title', <String>[], true),
  welcome('screen.welcome.title', <String>[], false),
  login('screen.login.title', <String>['L', 'Д'], false),
  sessions('screen.sessions.title', <String>['S', 'Ы'], false),
  passwords('screen.passwords.title', <String>['P', 'З'], false),
  settings('screen.settings.title', <String>['T', 'Е'], false),
  stats('screen.stats.title', <String>['A', 'Ф'], false);

  final String titleKey;
  final List<String> hotkeys;
  final bool isStarter;

  const Route(this.titleKey, this.hotkeys, this.isStarter);

  String? get primaryHotkey => hotkeys.isEmpty ? null : hotkeys.first;

  String get hotkeyLabel => hotkeys.join('/');

  static Route getStarter() {
    return Route.values.firstWhere((route) => route.isStarter);
  }

  static Route? getByKey(Key key) {
    if (key.isControl || key.char.isEmpty) {
      return null;
    }

    final pressed = key.char.toUpperCase();
    for (final route in Route.values) {
      if (route.hotkeys.contains(pressed)) {
        return route;
      }
    }

    return null;
  }
}
