import 'package:secureguard_cli/src/domain/repositories/passwords_repository.dart';
import 'package:secureguard_cli/src/models/passwords.dart';

class PasswordsService {
  final PasswordsRepository _repository;

  PasswordsService(this._repository);

  Future<List<Password>> getList(int limit, int offset) =>
      _repository.getList(limit: limit, offset: offset);

  Future<Password> create({
    required String serviceUrl,
    required String login,
    required String cipher,
    required int version,
    required String nonce,
    required List<int> aad,
    required String metadata,
  }) => _repository.create(
    serviceUrl: serviceUrl,
    login: login,
    cipher: cipher,
    version: version,
    nonce: nonce,
    aad: aad,
    metadata: metadata,
  );

  Future<Password> update({
    required String id,
    String? serviceUrl,
    String? login,
    String? pass,
    required String salt,
  }) => _repository.update(
    id: id,
    salt: salt,
    serviceUrl: serviceUrl,
    pass: pass,
    login: login,
  );
  Future<void> delete({required String id}) => _repository.delete(id: id);
}
