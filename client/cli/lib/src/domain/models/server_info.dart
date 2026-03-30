import 'package:secureguard_cli/src/api/xyz/secureguard/v1/meta/v1/domain.pb.dart';

class ServerMetadata {
  final String name;
  final String version;
  final String runtimeVersion;
  final List<double> supportedApiVersions;
  final String commitHash;
  final String repository;
  final DateTime? buildTime;

  const ServerMetadata({
    required this.name,
    required this.version,
    required this.runtimeVersion,
    required this.supportedApiVersions,
    required this.commitHash,
    required this.repository,
    required this.buildTime,
  });

  factory ServerMetadata.fromProto(ServerInfo info) {
    return ServerMetadata(
      name: info.name,
      version: info.version,
      runtimeVersion: info.runtimeVersion,
      supportedApiVersions: List.unmodifiable(info.supporingVer),
      commitHash: info.commitHash,
      repository: info.reporitory,
      buildTime: info.hasBuildTime()
          ? DateTime.fromMillisecondsSinceEpoch(
              info.buildTime.seconds.toInt() * 1000,
              isUtc: true,
            ).add(Duration(microseconds: info.buildTime.nanos ~/ 1000))
          : null,
    );
  }
}

class ServerCompatibility {
  final bool isCompatible;
  final List<String> reasons;

  const ServerCompatibility({
    required this.isCompatible,
    required this.reasons,
  });
}

class ServerLocalisations {
  final Map<String, String> russian;
  final Map<String, String> english;

  const ServerLocalisations({required this.russian, required this.english});
}
