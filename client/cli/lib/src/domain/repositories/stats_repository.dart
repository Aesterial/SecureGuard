import 'package:secureguard_cli/src/api/xyz/secureguard/v1/stats/v1/domain.pb.dart';

abstract interface class StatsRepository {
  Future<Stats> today();
  Future<Stats> byDate(DateTime day);
  Future<TotalResponse> getTotal();
}
