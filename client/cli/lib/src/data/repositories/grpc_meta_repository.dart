import 'package:grpc/grpc.dart';
import 'package:secureguard_cli/src/clients/meta_grpc_client.dart';
import 'package:secureguard_cli/src/domain/models/server_info.dart';
import 'package:secureguard_cli/src/domain/repositories/meta_repository.dart';

class GrpcMetaRepository implements MetaRepository {
  final MetaGrpcClient _client;

  GrpcMetaRepository({required ClientChannel channel}) : _client = MetaGrpcClient(channel);

  @override
  Future<ServerMetadata> getServerInfo() async {
    final info = await _client.info();

    if (info == null) {
      throw StateError('Meta repository failed to load server info');
    }

    return ServerMetadata.fromProto(info);
  }

  @override
  Future<ServerCompatibility> checkCompatibility() async {
    final (isCompatible, reasons) = await _client.isCompatible();

    return ServerCompatibility(
      isCompatible: isCompatible,
      reasons: List.unmodifiable(reasons),
    );
  }
}
