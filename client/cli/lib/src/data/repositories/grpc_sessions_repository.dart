import 'package:grpc/grpc.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/sessions/v1/service.pbgrpc.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';
import 'package:secureguard_cli/src/clients/interceptors/global_interceptor.dart';
import 'package:secureguard_cli/src/domain/repositories/sessions_repository.dart';
import 'package:secureguard_cli/src/models/sessions.dart';

class GrpcSessionsRepository implements SessionsRepository {
  final SessionsServiceClient _client;

  GrpcSessionsRepository({required ClientChannel channel})
    : _client = SessionsServiceClient(
        channel,
        interceptors: [GlobalInterceptor()],
      );

  @override
  Future<List<Session>> getList({
    required int limit,
    required int offset,
    required bool showRevoked,
  }) async {
    final response = await _client.getList(
      RequestWithBooleanLimitOffset(
        limit: limit,
        offset: offset,
        value: !showRevoked,
      ),
    );
    return response.list
        .map(Session.tryFromProto)
        .whereType<Session>()
        .toList();
  }

  @override
  Future<void> revoke({required String id}) async {
    await _client.revoke(RequestWithID(id: id));
  }
}
