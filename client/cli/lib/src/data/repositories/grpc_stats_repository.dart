import 'package:grpc/grpc.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/stats/v1/domain.pb.dart' as statspb;
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/stats/v1/service.pbgrpc.dart';
import 'package:secureguard_cli/src/clients/interceptors/global_interceptor.dart';
import 'package:secureguard_cli/src/domain/repositories/stats_repository.dart';
import 'package:secureguard_cli/src/models/stats.dart';

class GrpcStatsRepository implements StatsRepository {
  final StatsServiceClient _client;

  GrpcStatsRepository({required ClientChannel channel}) : _client = StatsServiceClient(channel, interceptors: [GlobalInterceptor()]);

  @override
  Future<Stats> byDate(DateTime day) async {
    try {
      final response = await _client.byDate(
          statspb.ByDateRequest(day: Timestamp.fromDateTime(day)));
      if (!response.hasRequiredFields() || !response.hasStats()) {
        throw StateError("stats repository failed to get info by date");
      }
      return Stats.fromProto(stat: response.stats);
    } on GrpcError {
      rethrow;
    }
  }

  @override
  Future<Total> getTotal() async {
    try {
      final response = await _client.total(Empty());
      if (!response.hasRequiredFields() || !response.hasUsers()) {
        throw StateError("stats repository failed to get total statistics");
      }
      return Total.fromProto(total: response);
    } on GrpcError {
      rethrow;
    }
  }

  @override
  Future<Stats> today() async {
    try {
      final response = await _client.today(Empty());
      if (!response.hasRequiredFields() || !response.hasStats()) {
        throw StateError("stats repository failed to get stats");
      }
      return Stats.fromProto(stat: response.stats);
    } on GrpcError {
      rethrow;
    }
  }
}
