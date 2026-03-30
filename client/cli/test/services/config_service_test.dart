import 'package:secureguard_cli/src/models/config.dart';
import 'package:secureguard_cli/src/services/config_service.dart';
import 'package:test/test.dart';

void main() {
  group('ConfigService', () {
    test('normalizes endpoint without scheme to https', () {
      final service = ConfigService.fromEndpoint('localhost:8443');

      expect(service.current.serverUri.scheme, 'https');
      expect(service.current.host, 'localhost');
      expect(service.current.port, 8443);
      expect(service.current.useTls, isTrue);
    });

    test('keeps explicit http endpoint insecure', () {
      final config = Config.parse('http://127.0.0.1:50051');

      expect(config.host, '127.0.0.1');
      expect(config.port, 50051);
      expect(config.useTls, isFalse);
    });
  });
}
