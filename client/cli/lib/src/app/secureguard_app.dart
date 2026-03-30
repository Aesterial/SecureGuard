import 'package:grpc/grpc.dart';
import 'package:secureguard_cli/src/clients/grpc_channel_factory.dart';
import 'package:secureguard_cli/src/core/store.dart';
import 'package:secureguard_cli/src/crypto/engine.dart';
import 'package:secureguard_cli/src/data/repositories/grpc_login_repository.dart';
import 'package:secureguard_cli/src/data/repositories/grpc_meta_repository.dart';
import 'package:secureguard_cli/src/data/repositories/grpc_passwords_repository.dart';
import 'package:secureguard_cli/src/data/repositories/grpc_sessions_repository.dart';
import 'package:secureguard_cli/src/data/repositories/grpc_stats_repository.dart';
import 'package:secureguard_cli/src/data/repositories/grpc_user_repository.dart';
import 'package:secureguard_cli/src/models/client.dart';
import 'package:secureguard_cli/src/models/config.dart';
import 'package:secureguard_cli/src/models/logger.dart';
import 'package:secureguard_cli/src/services/clipboard_service.dart';
import 'package:secureguard_cli/src/services/config_service.dart';
import 'package:secureguard_cli/src/services/logger_service.dart';
import 'package:secureguard_cli/src/services/login_service.dart';
import 'package:secureguard_cli/src/services/meta_service.dart';
import 'package:secureguard_cli/src/services/password_crypto_service.dart';
import 'package:secureguard_cli/src/services/passwords_service.dart';
import 'package:secureguard_cli/src/services/sessions_service.dart';
import 'package:secureguard_cli/src/services/stats_service.dart';
import 'package:secureguard_cli/src/services/user_service.dart';

class SecureGuardApp {
  final ConfigService configService;
  final LoggerService logger;
  final LoginService loginService;
  final MetaService metaService;
  final PasswordCryptoService passwordCryptoService;
  final PasswordsService passwordsService;
  final ClipboardService clipboardService;
  final SessionsService sessionsService;
  final UserService userService;
  final StatsService statsService;
  final ClientChannel _channel;

  SecureGuardApp._({
    required this.configService,
    required this.logger,
    required this.loginService,
    required this.metaService,
    required this.passwordCryptoService,
    required this.passwordsService,
    required this.clipboardService,
    required this.userService,
    required this.statsService,
    required this.sessionsService,
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
    final loginRepository = GrpcLoginRepository(channel: channel);
    final metaRepository = GrpcMetaRepository(channel: channel);
    final passwordsRepository = GrpcPasswordsRepository(channel: channel);
    final sessionsRepository = GrpcSessionsRepository(channel: channel);
    final statsRepository = GrpcStatsRepository(channel: channel);
    final userRepository = GrpcUserRepository(channel: channel);
    final passwordCryptoService = PasswordCryptoService(PasswordCryptoEngine());

    clientInfo = clientStore;

    return SecureGuardApp._(
      configService: configService,
      logger: logger,
      loginService: LoginService(loginRepository, clientStore),
      metaService: MetaService(metaRepository),
      passwordCryptoService: passwordCryptoService,
      passwordsService: PasswordsService(passwordsRepository),
      clipboardService: ClipboardService(),
      userService: UserService(userRepository),
      statsService: StatsService(statsRepository),
      sessionsService: SessionsService(sessionsRepository),
      channel: channel,
    );
  }

  Future<void> close() async {
    await _channel.shutdown();
  }
}
