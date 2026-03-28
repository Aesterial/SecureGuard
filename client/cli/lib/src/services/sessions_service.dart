import 'package:secureguard_cli/src/domain/repositories/sessions_repository.dart';
import 'package:secureguard_cli/src/models/sessions.dart';

class SessionsService {
  final SessionsRepository _repository;

  SessionsService(this._repository);

  Future<List<Session>> getList({
    required int limit,
    required int offset,
    bool showRevoked = false,
  }) => _repository.getList(
    limit: limit,
    offset: offset,
    showRevoked: showRevoked,
  );

  Future<void> revoke({required String id}) => _repository.revoke(id: id);
}
