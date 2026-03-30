import 'package:grpc/grpc.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/sessions/v1/domain.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/sessions/v1/service.pbgrpc.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';
import 'package:secureguard_cli/src/clients/interceptors/global_interceptor.dart';

class SessionsGrpcClient {
  final SessionsServiceClient client;

  SessionsGrpcClient(ClientChannel channel)
    : client = SessionsServiceClient(
        channel,
        interceptors: [GlobalInterceptor()],
      );

  Future<SessionsListResponse> getList({
    required int limit,
    required int offset,
    required bool showRevoked,
  }) async {
    final body = RequestWithBooleanLimitOffset(
      value: showRevoked,
      limit: limit,
      offset: offset,
    );
    try {
      final response = await client.getList(body);
      return response;
    } on GrpcError {
      rethrow;
    }
  }

  Future<bool> revoke({required String id}) async {
    final body = RequestWithID(id: id);
    try {
      final _ = await client.revoke(body);
      return true;
    } on GrpcError {
      return false;
    }
  }
}
