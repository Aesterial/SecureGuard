import 'package:secureguard_cli/src/domain/models/auth_session.dart';
import 'package:secureguard_cli/src/domain/models/server_info.dart';
import 'package:secureguard_cli/src/models/config.dart';
import 'package:secureguard_cli/src/models/passwords.dart';
import 'package:secureguard_cli/src/models/sessions.dart';
import 'package:secureguard_cli/src/models/stats.dart';
import 'package:secureguard_cli/src/models/user.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';

class TuiState {
  final List<Route> _history = <Route>[];
  final Map<Route, int> _selection = <Route, int>{};

  Route currentRoute = Route.getStarter();
  bool welcomeShown = false;
  bool serverConfigured = true;
  bool serverLocked = false;

  AuthSession? authSession;
  User? currentUser;
  ServerMetadata? serverMetadata;
  ServerCompatibility? serverCompatibility;
  Config? serverConfig;
  List<Session> sessions = const <Session>[];
  List<Password> passwords = const <Password>[];
  Stats? stats;
  Total? total;
  DateTime statsDate = DateTime.now();

  bool showRevokedSessions = false;
  Languages locale = Languages.russian;
  Themes theme = Themes.black;
  Crypt crypt = Crypt.argon2ID;

  String? statusMessage;
  bool statusIsError = false;

  int selectionFor(Route route) => _selection[route] ?? 0;

  void setSelection(Route route, int value) {
    _selection[route] = value < 0 ? 0 : value;
  }

  void pushHistory(Route route) {
    if (_history.isEmpty || _history.last != route) {
      _history.add(route);
    }
  }

  Route? popHistory() {
    if (_history.isEmpty) {
      return null;
    }

    return _history.removeLast();
  }

  void clearHistory() {
    _history.clear();
  }
}
