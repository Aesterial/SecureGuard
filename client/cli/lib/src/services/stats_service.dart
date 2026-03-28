import 'package:secureguard_cli/src/domain/repositories/stats_repository.dart';
import 'package:secureguard_cli/src/models/stats.dart';

class StatsService {
  final StatsRepository _repository;

  StatsService(this._repository);

  Future<Stats> today() => _repository.today();

  Future<Stats> byDate(DateTime day) => _repository.byDate(day);

  Future<Total> getTotal() => _repository.getTotal();
}
