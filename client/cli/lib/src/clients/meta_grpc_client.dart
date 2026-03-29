import 'package:grpc/grpc.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/meta/v1/domain.pb.dart';
import 'package:secureguard_cli/src/core/constants.dart';

import '../api/xyz/secureguard/v1/meta/v1/service.pbgrpc.dart';

class MetaGrpcClient {
  final MetaServiceClient client;

  MetaGrpcClient(ClientChannel channel) : client = MetaServiceClient(channel);

  Future<ServerInfo?> info() async {
    try {
      final response = await client.serverInformation(Empty());
      if (!response.hasInfo()) {
        return null;
      }
      return response.info;
    } on GrpcError {
      rethrow;
    }
  }

  Future<(bool, List<String>)> isCompatible() async {
    try {
      final response = await client.clientCompatibility(
        CompatibilityRequest(clientApiVersion: apiVersion, type: clientType),
      );
      if (response.reasons.isEmpty) {
        return (true, <String>[]);
      }
      return (response.value, response.reasons.toList());
    } on GrpcError {
      rethrow;
    }
  }

  Future<LocalisationResponse?> getLocalisations() async {
    try {
      final response = await client.localisation(Empty());
      return response;
    } on GrpcError {
      rethrow;
    }
  }
}
