import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';
import 'package:secureguard_cli/src/domain/models/auth_session.dart';
import 'package:secureguard_cli/src/domain/repositories/login_repository.dart';
import 'package:secureguard_cli/src/models/client.dart';

class LoginService {
  final LoginRepository _repository;
  final ClientStore _clientStore;

  LoginService(this._repository, this._clientStore);

  bool get isAuthorized => _clientStore.isAuthorized;
  String get clientHash => _clientStore.getClientHash();

  Future<AuthSession> register({
    required String username,
    required String password,
    required String wrappedMasterKey,
    required String salt,
    required Kdf kdfParams,
  }) async {
    final authSession = await _repository.register(
      username: username,
      password: password,
      wrappedMasterKey: wrappedMasterKey,
      salt: salt,
      kdfParams: kdfParams,
    );

    _clientStore.set(authSession.sessionToken);
    return authSession;
  }

  Future<AuthSession> authorize({
    required String username,
    required String password,
    String? wrappedMasterKey,
  }) async {
    final authSession = await _repository.authorize(
      username: username,
      password: password,
      wrappedMasterKey: wrappedMasterKey,
    );

    _clientStore.set(authSession.sessionToken);
    return authSession;
  }

  Future<void> logout() async {
    await _repository.logout();
    _clientStore.clear();
  }
}
