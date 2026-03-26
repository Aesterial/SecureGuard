enum LoggerLevel {
  unknown('unknown', baseWeight),
  info('info', baseWeight + 1),
  warning('warning', baseWeight + 2),
  error('error', baseWeight + 3),
  critical('critical', baseWeight + 4);

  static const int baseWeight = 0;

  final String value;
  final int weight;

  const LoggerLevel(this.value, this.weight);

  @override
  String toString() => value;
  int getWeight() => weight;
}

class LoggerField {
  final String key;
  final dynamic value;
  LoggerField(this.key, this.value);

  @override
  String toString() {
    return '$key: $value';
  }

  String toStringValue() {
    return '$value';
  }
}

LoggerField format(String key, dynamic value) {
  return LoggerField(key, value);
}

Map<String, String> normalizeFields(List<LoggerField> list) {
  if (list.isEmpty) {
    return {};
  }
  final returns = <String, String>{};
  for (var element in list) {
    final key = element.key.trim();
    if (key.isEmpty) {
      return {};
    }
    returns[key] = element.toStringValue();
  }
  if (returns.isEmpty) {
    return {};
  }
  return returns;
}
