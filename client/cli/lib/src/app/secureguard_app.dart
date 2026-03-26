import 'package:grpc/grpc.dart';
import 'package:secureguard_cli/src/clients/grpc_channel_factory.dart';
import 'package:secureguard_cli/src/clients/login_grpc_client.dart';
import 'package:secureguard_cli/src/clients/meta_grpc_client.dart';
import 'package:secureguard_cli/src/core/store.dart';
import 'package:secureguard_cli/src/data/repositories/grpc_login_repository.dart';
import 'package:secureguard_cli/src/data/repositories/grpc_meta_repository.dart';
import 'package:secureguard_cli/src/models/client.dart';
import 'package:secureguard_cli/src/models/config.dart';
import 'package:secureguard_cli/src/models/logger.dart';
import 'package:secureguard_cli/src/services/config_service.dart';
import 'package:secureguard_cli/src/services/logger_service.dart';
import 'package:secureguard_cli/src/services/login_service.dart';
import 'package:secureguard_cli/src/services/meta_service.dart';

class SecureGuardApp {
  final ConfigService configService;
  final LoggerService logger;
  final LoginService loginService;
  final MetaService metaService;
  final ClientChannel _channel;

  SecureGuardApp._({
    required this.configService,
    required this.logger,
    required this.loginService,
    required this.metaService,
    required ClientChannel channel,
  }) : _channel = channel;

  factory SecureGuardApp.bootstrap({
    required Config config,
    LoggerLevel minLogLevel = LoggerLevel.info,
  }) {
    final configService = ConfigService(config);
    final logger = LoggerService(minLogLevel);
    final channel = buildChannel(configService.current);
    final clientStore = ClientStore();
    final loginRepository = GrpcLoginRepository(LoginGrpcClient(channel));
    final metaRepository = GrpcMetaRepository(MetaGrpcClient(channel));

    clientInfo = clientStore;

    return SecureGuardApp._(
      configService: configService,
      logger: logger,
      loginService: LoginService(loginRepository, clientStore),
      metaService: MetaService(metaRepository),
      channel: channel,
    );
  }

  Future<void> close() async {
    await _channel.shutdown();
  }
}
