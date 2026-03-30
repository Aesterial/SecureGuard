import 'package:secureguard_cli/src/models/user.dart';

class AuthSession {
  final User user;
  final String sessionToken;

  const AuthSession({required this.user, required this.sessionToken});
}
