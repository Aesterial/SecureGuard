import 'package:secureguard_cli/src/models/logger.dart';
import 'package:secureguard_cli/src/utils/logger.dart';

class LoggerService {
  final LoggerLevel minLevel;

  LoggerService(this.minLevel);

  void unknown(String content, List<LoggerField> fields) =>
      _log(LoggerLevel.unknown, content, null, fields);

  void info(String content, List<LoggerField> fields) =>
      _log(LoggerLevel.info, content, null, fields);

  void warning(String content, Object? error, List<LoggerField> fields) =>
      _log(LoggerLevel.warning, content, error, fields);

  void error(String content, Object error, List<LoggerField> fields) =>
      _log(LoggerLevel.error, content, error, fields);

  void critical(String content, Object error, List<LoggerField> fields) =>
      _log(LoggerLevel.critical, content, error, fields);

  void _log(
    LoggerLevel level,
    String content,
    Object? error,
    List<LoggerField> fields,
  ) {
    if (level.getWeight() < minLevel.getWeight()) {
      return;
    }

    final message = formatLog(level, content, error, fields);

    print(message);
  }
}
