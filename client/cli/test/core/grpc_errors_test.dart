import 'package:grpc/grpc.dart';
import 'package:secureguard_cli/src/core/grpc_errors.dart';
import 'package:test/test.dart';

void main() {
  group('isUnauthenticatedGrpcError', () {
    test('returns true for unauthenticated grpc status', () {
      expect(
        isUnauthenticatedGrpcError(
          GrpcError.unauthenticated('session expired'),
        ),
        isTrue,
      );
    });

    test('returns false for non-unauthenticated errors', () {
      expect(
        isUnauthenticatedGrpcError(GrpcError.notFound('missing')),
        isFalse,
      );
      expect(isUnauthenticatedGrpcError(StateError('bad state')), isFalse);
    });
  });
}
