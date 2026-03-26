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
}

class Stats {
  final Map<String, DateTime> topServices;
  final List<GraphPoint> usersActivityGraph;
  final List<GraphPoint> registerActivityGraph;
  final Map<String, int> cryptUses;
  final Map<String, int> themeUses;
  final Map<String, int> languageUses;
  const Stats(this.topServices, this.usersActivityGraph, this.registerActivityGraph, this.cryptUses, this.themeUses, this.languageUses);
}
