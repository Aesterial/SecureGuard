class Config {
  final Uri serverUri;
  final bool useTls;

  const Config({required this.serverUri, required this.useTls});

  factory Config.parse(String endpoint, {bool? useTls}) {
    final normalizedEndpoint = endpoint.contains('://')
        ? endpoint
        : 'https://$endpoint';
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
}
