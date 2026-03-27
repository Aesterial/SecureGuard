import 'package:grpc/grpc.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/stats/v1/domain.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/stats/v1/service.pbgrpc.dart';
import 'package:secureguard_cli/src/clients/interceptors/global_interceptor.dart';
import 'package:secureguard_cli/src/domain/repositories/stats_repository.dart';

class GrpcStatsRepository implements StatsRepository {
  final StatsServiceClient _client;

  GrpcStatsRepository({required ClientChannel channel}) : _client = StatsServiceClient(channel, interceptors: [GlobalInterceptor()]);

  @override
  Future<Stats> byDate(DateTime day) async {
    try {
      final response = await _client.byDate(ByDateRequest(day: Timestamp.fromDateTime(day)));
      return response.stats;
    } on GrpcError {
      rethrow;
    }
  }

  @override
  Future<TotalResponse> getTotal() async {
    try {
      final response = await _client.total(Empty());
      return response;
    } on GrpcError {
      rethrow;
    }
  }

  @override
  Future<Stats> today() async {
    try {
      final response = await _client.today(Empty());
      return response.stats;
    } on GrpcError {
      rethrow;
    }
  }


}
