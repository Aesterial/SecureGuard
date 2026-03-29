import 'package:secureguard_cli/src/models/passwords.dart';

abstract interface class PasswordsRepository {
  Future<List<Password>> getList({required int limit, required int offset});

  Future<Password> create({
    required String serviceUrl,
    required String login,
    required String cipher,
    required int version,
    required String nonce,
    required List<int> aad,
    required String metadata,
  });

  Future<Password> update({
    required String id,
    String? serviceUrl,
    String? login,
    String? pass,
    required String salt,
  });

  Future<void> delete({required String id});
}
