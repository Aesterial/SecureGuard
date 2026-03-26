import 'package:secureguard_cli/src/models/logger.dart';

LoggerLevel parseLevel(String str) {
  switch (str) {
    case "info":
      return LoggerLevel.info;
    case "warning":
    case "warn":
      return LoggerLevel.warning;
    case "error":
    case "err":
      return LoggerLevel.error;
    case "critical":
      return LoggerLevel.critical;
    default:
      return LoggerLevel.unknown;
  }
}

String formatLog(
  LoggerLevel level,
  String content,
  Object? error,
  List<LoggerField> fields,
) {
  final normal = normalizeFields(fields);
  final fieldsBuffer = StringBuffer();
  for (var entry in normal.entries) {
    fieldsBuffer.write('${entry.key}=${entry.value} ');
  }
  final base =
      '[${level.toString().toUpperCase()}]: $content | ${DateTime.now().toIso8601String()} | ${fieldsBuffer.toString()}';
  if (error == null) {
    return base;
  }
  final errorBuffer = StringBuffer()
    ..write(base)
    ..write(' | Error: $error');
  return errorBuffer.toString().trimRight();
}
