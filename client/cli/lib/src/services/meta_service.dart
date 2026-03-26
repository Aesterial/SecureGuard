import 'package:secureguard_cli/src/domain/models/server_info.dart';
import 'package:secureguard_cli/src/domain/repositories/meta_repository.dart';

class MetaService {
  final MetaRepository _repository;

  MetaService(this._repository);

  Future<ServerMetadata> fetchServerInfo() => _repository.getServerInfo();

  Future<ServerCompatibility> checkCompatibility() =>
      _repository.checkCompatibility();
}
