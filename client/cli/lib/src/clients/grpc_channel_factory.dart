import 'package:grpc/grpc.dart';
import 'package:secureguard_cli/src/models/config.dart';

ClientChannel buildChannel(Config config) {
  final channel = ClientChannel(
    config.host,
    port: config.port,
    options: ChannelOptions(
      credentials: config.useTls
          ? const ChannelCredentials.secure()
          : const ChannelCredentials.insecure(),
    ),
  );
  return channel;
}
