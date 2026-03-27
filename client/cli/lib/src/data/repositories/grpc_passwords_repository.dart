import 'package:grpc/grpc.dart';
import 'package:secureguard_cli/src/models/passwords.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/passwords/v1/service.pbgrpc.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/passwords/v1/domain.pb.dart' as passpb;
import 'package:secureguard_cli/src/clients/interceptors/global_interceptor.dart';
import 'package:secureguard_cli/src/domain/repositories/passwords_repository.dart';

class GrpcPasswordsRepository implements PasswordsRepository {
  final PasswordServiceClient _client;

  GrpcPasswordsRepository({required ClientChannel channel}) : _client = PasswordServiceClient(channel, interceptors: [GlobalInterceptor()]);

  @override
  Future<Password> create({required String serviceUrl, required String login, required String cipher, required int version, required String nonce, required List<int> aad, required String metadata}) async {
    final pass = await _client.create(passpb.CreateRequest(serviceUrl: serviceUrl, login: login, ciphertext: cipher, version: version, nonce: nonce, aad: aad, metadata: metadata));
    if (!pass.hasInfo() || !pass.hasRequiredFields()) {
      throw StateError("passwords repository failed to create new password");
    }
    return Password.fromProto(password: pass.info);
  }

  @override
  Future<void> delete({required String id}) async {
    await _client.delete(RequestWithID(id: id));
  }

  @override
  Future<List<Password>> getList({
    required int limit,
    required int offset,
  }) async {
    final response = await _client.list(
      RequestWithLimitAndOffset(
        limit: limit,
        offset: offset,
      ),
    );

    if (!response.hasRequiredFields()) {
      throw StateError(
        'passwordsRepository failed to get password list',
      );
    }

    return response.list
        .map((element) => Password.fromProto(password: element))
        .toList();
  }

  @override
  Future<Password> update({required String id, String? serviceUrl, String? login, String? pass, required String salt}) async {
    final response = await _client.update(passpb.UpdateRequest(id: id, serviceUrl: serviceUrl, login: login, pass: pass, salt: salt));
    if (!response.hasRequiredFields()) {
      throw StateError("passwordsRepository failed to update password");
    }
    return Password.fromProto(password: response.info);
  }
}
