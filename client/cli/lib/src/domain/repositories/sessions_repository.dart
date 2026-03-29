import 'package:secureguard_cli/src/models/sessions.dart';

abstract interface class SessionsRepository {
  Future<List<Session>> getList({
    required int limit,
    required int offset,
    required bool showRevoked,
  });
  Future<void> revoke({required String id});
}
