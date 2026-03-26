import 'package:secureguard_cli/src/domain/models/server_info.dart';

abstract interface class MetaRepository {
  Future<ServerMetadata> getServerInfo();

  Future<ServerCompatibility> checkCompatibility();
}
