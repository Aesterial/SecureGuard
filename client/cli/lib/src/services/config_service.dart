import 'package:secureguard_cli/src/models/config.dart';

class ConfigService {
  final Config _config;

  ConfigService(this._config);

  factory ConfigService.fromEndpoint(String endpoint, {bool? useTls}) {
    return ConfigService(Config.parse(endpoint, useTls: useTls));
  }

  Config get current => _config;
}
