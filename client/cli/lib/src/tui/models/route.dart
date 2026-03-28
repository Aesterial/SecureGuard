import 'package:dart_console/dart_console.dart';
import 'package:secureguard_cli/src/tui/models/screen.dart';
import 'package:secureguard_cli/src/tui/screen/login_screen.dart';
import 'package:secureguard_cli/src/tui/screen/passwords_screen.dart';
import 'package:secureguard_cli/src/tui/screen/sessions_screen.dart';
import 'package:secureguard_cli/src/tui/screen/settings_screen.dart';
import 'package:secureguard_cli/src/tui/screen/stats_screen.dart';
import 'package:secureguard_cli/src/tui/screen/welcome_screen.dart';

enum Route {
  welcome("welcome", "W", true, WelcomeScreen()),
  login("login", "L", false, LoginScreen()),
  sessions("sessions", "E", false, SessionsScreen()),
  passwords("passwords", "P", false, PasswordsScreen()),
  settings("settings", "T", false, SettingsScreen()),
  stats("stats", "A", false, StatsScreen());

  final String title;
  final bool isStarter;
  final String key;
  final Screen screen;

  static Route getStarter() {
    return Route.values.firstWhere((e) => e.isStarter);
  }

  static Route getByKey(Key key) {
    return Route.values.firstWhere((e) => e.key == key.char);
  }

  const Route(this.title, this.key, this.isStarter, this.screen);
}
