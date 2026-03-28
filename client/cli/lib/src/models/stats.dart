import 'package:secureguard_cli/src/api/xyz/secureguard/v1/stats/v1/domain.pb.dart' as statspb;

class GraphPoint {
  final DateTime time;
  final int value;
  const GraphPoint(this.time, this.value);
}

class Total {
  final int users;
  final int admins;
  final int passwords;
  final int activeSessions;
  const Total(this.users, this.admins, this.passwords, this.activeSessions);

  factory Total.fromProto({required statspb.TotalResponse total}) {
    return Total(
        total.users, total.admins, total.passwords, total.activeSessions);
  }
}

class Stats {
  final Map<String, int> topServices;
  final List<GraphPoint> usersActivityGraph;
  final List<GraphPoint> registerActivityGraph;
  final Map<String, int> cryptUses;
  final Map<String, int> themeUses;
  final Map<String, int> languageUses;
  const Stats(this.topServices, this.usersActivityGraph, this.registerActivityGraph, this.cryptUses, this.themeUses, this.languageUses);

  factory Stats.fromProto({required statspb.Stats stat}) {
    return Stats(
        stat.topServices,
        stat.usersGraph.map((value) =>
            GraphPoint(value.time.toDateTime(), value.value)).toList(),
        stat.registerGraph.map((value) =>
            GraphPoint(value.time.toDateTime(), value.value)).toList(),
        stat.cryptUses,
        stat.themeUses,
        stat.langUses
    );
  }
}
