import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';
import 'package:secureguard_cli/src/domain/models/auth_session.dart';

abstract interface class LoginRepository {
  Future<AuthSession> register({
    required String username,
    required String password,
    required String wrappedMasterKey,
    required String salt,
    required Kdf kdfParams,
  });

  Future<AuthSession> authorize({
    required String username,
    required String password,
    String? wrappedMasterKey,
  });

  Future<void> logout();
}
