import 'package:secureguard_cli/src/models/stats.dart';

abstract interface class StatsRepository {
  Future<Stats> today();
  Future<Stats> byDate(DateTime day);

  Future<Total> getTotal();
}
