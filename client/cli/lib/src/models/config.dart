class Config {
  final Uri serverUri;
  final bool useTls;

  const Config({required this.serverUri, required this.useTls});

  factory Config.parse(String endpoint, {bool? useTls}) {
    final normalizedEndpoint = normalizeEndpoint(endpoint);
    final uri = Uri.parse(normalizedEndpoint);

    if (uri.host.isEmpty) {
      throw FormatException('Invalid server endpoint: $endpoint');
    }

    return Config(serverUri: uri, useTls: useTls ?? uri.scheme != 'http');
  }

  String get host => serverUri.host;

  int get port {
    if (serverUri.hasPort) {
      return serverUri.port;
    }

    return useTls ? 443 : 80;
  }

  static String normalizeEndpoint(String endpoint) {
    final trimmedEndpoint = endpoint.trim();
    final protocolPattern = RegExp(r'^(https?):\/\/', caseSensitive: false);
    var normalizedEndpoint = trimmedEndpoint;
    String? scheme;

    while (true) {
      final match = protocolPattern.firstMatch(normalizedEndpoint);
      if (match == null) {
        break;
      }

      scheme ??= match.group(1)!.toLowerCase();
      normalizedEndpoint = normalizedEndpoint.substring(match.end);
    }

    if (scheme == null) {
      return 'https://$trimmedEndpoint';
    }

    return '$scheme://$normalizedEndpoint';
  }
}
