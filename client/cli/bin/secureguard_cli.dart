import 'dart:io';

import 'package:args/args.dart';
import 'package:secureguard_cli/secureguard_cli.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/meta/v1/domain.pb.dart';
import 'package:secureguard_cli/src/core/constants.dart';
import 'package:secureguard_cli/src/tui/tui.dart';

ArgParser initParser() {
  return ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Shows CLI help')
    ..addFlag('version', abbr: 'v', negatable: false, help: 'Shows CLI version')
    ..addOption(
      'server',
      abbr: 's',
      help: 'SecureGuard server endpoint',
      defaultsTo: 'https://localhost',
    );
}

void initConstants() {
  if (Platform.isWindows) {
    clientType = ClientType.CLIENT_TYPE_SECUREGUARD_WINDOWS;
  } else if (Platform.isLinux) {
    clientType = ClientType.CLIENT_TYPE_SECUREGUARD_LINUX;
  } else if (Platform.isMacOS) {
    clientType = ClientType.CLIENT_TYPE_SECUREGUARD_MAC;
  }
}

Future<void> main(List<String> arguments) async {
  final ArgParser parser = initParser();
  initConstants();
  final ArgResults results = parser.parse(arguments);

  if (results.flag('help')) {
    stdout.writeln(parser.usage);
    return;
  }

  final app = SecureGuardApp.bootstrap(
    config: Config.parse(results.option('server')!),
    minLogLevel: LoggerLevel.info,
  );

  try {
    app.logger.info('starting $appName', []);

    if (results.flag('version')) {
      stdout.writeln('$appName $version');
      return;
    }

    await Tui(app).run();
  } on Exception catch (e) {
    app.logger.critical('exception in main loop', e, []);
    rethrow;
  } finally {
    await app.close();
  }
}
