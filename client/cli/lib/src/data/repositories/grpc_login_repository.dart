import 'package:grpc/grpc.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/login/v1/domain.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';
import 'package:secureguard_cli/src/clients/login_grpc_client.dart';
import 'package:secureguard_cli/src/domain/models/auth_session.dart';
import 'package:secureguard_cli/src/domain/repositories/login_repository.dart';
import 'package:secureguard_cli/src/models/user.dart';

class GrpcLoginRepository implements LoginRepository {
  final LoginGrpcClient _client;

  GrpcLoginRepository({required ClientChannel channel}) : _client = LoginGrpcClient(channel);

  @override
  Future<AuthSession> register({
    required String username,
    required String password,
    required String wrappedMasterKey,
    required String salt,
    required Kdf kdfParams,
  }) async {
    final response = await _client.register(
      username,
      password,
      wrappedMasterKey,
      salt,
      kdfParams,
    );

    return _requireSession(response, 'register');
  }

  @override
  Future<AuthSession> authorize({
    required String username,
    required String password,
    String? wrappedMasterKey,
  }) async {
    final response = await _client.authorize(
      username,
      password,
      masterKey: wrappedMasterKey,
    );

    return _requireSession(response, 'authorize');
  }

  @override
  Future<void> logout() async {
    await _client.logout();
  }

  AuthSession _requireSession(LoginResponse? response, String operation) {
    if (response == null || !response.hasInfo() || response.session.isEmpty) {
      throw StateError('Login repository failed to $operation: empty response');
    }

    return AuthSession(user: User.fromProto(usr: response.info), sessionToken: response.session);
  }
}
