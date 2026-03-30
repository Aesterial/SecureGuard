import 'package:grpc/grpc.dart';
import 'package:secureguard_cli/src/clients/interceptors/global_interceptor.dart';
import 'package:secureguard_cli/src/core/store.dart' as store;
import 'package:secureguard_cli/src/models/client.dart';
import 'package:test/test.dart';

void main() {
  group('GlobalInterceptor', () {
    tearDown(() {
      store.clientInfo = null;
    });

    test('adds SG-prefixed session metadata', () {
      final client = ClientStore()..set('session-token');
      store.clientInfo = client;
      final interceptor = GlobalInterceptor();
      final method = ClientMethod<void, String>(
        '/test.Service/Call',
        (_) => <int>[],
        (_) => '',
      );

      late CallOptions captured;

      expect(
        () => interceptor.interceptUnary<void, String>(
          method,
          null,
          CallOptions(),
          (method, request, options) {
            captured = options;
            throw UnimplementedError();
          },
        ),
        throwsUnimplementedError,
      );

      expect(captured.metadata['client'], client.getClientHash());
      expect(captured.metadata['session'], 'SG-session-token');
    });
  });
}
