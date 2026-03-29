import 'dart:io';

import 'package:args/args.dart';
import 'package:secureguard_cli/secureguard_cli.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/meta/v1/domain.pb.dart';
import 'package:secureguard_cli/src/core/constants.dart';
import 'package:secureguard_cli/src/tui/tui.dart';

const String defaultServer = String.fromEnvironment(
  'SECUREGUARD_DEFAULT_SERVER',
  defaultValue: 'https://localhost',
);

ArgParser initParser() {
  return ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Shows CLI help')
    ..addFlag('version', abbr: 'v', negatable: false, help: 'Shows CLI version')
    ..addOption('server', abbr: 's', help: 'SecureGuard server endpoint');
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

  final hasServerOption = results.wasParsed('server');
  final app = SecureGuardApp.bootstrap(
    config: hasServerOption
        ? Config.parse(results.option('server')!)
        : Config.parse(defaultServer),
    minLogLevel: LoggerLevel.info,
  );
  final tui = Tui(
    app,
    serverConfigured: hasServerOption,
    serverLocked: hasServerOption,
  );

  try {
    app.logger.info('starting $appName', []);

    if (results.flag('version')) {
      stdout.writeln('$appName $version');
      return;
    }

    await tui.run();
  } on Exception catch (e) {
    app.logger.critical('exception in main loop', e, []);
    rethrow;
  } finally {
    await tui.close();
  }
}
