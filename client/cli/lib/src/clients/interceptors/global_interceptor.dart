import 'package:grpc/grpc.dart';
import 'package:secureguard_cli/src/core/grpc_errors.dart';
import 'package:secureguard_cli/src/core/store.dart' as store;

class GlobalInterceptor extends ClientInterceptor {
  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    final client = store.clientInfo;
    if (client == null) {
      return invoker(method, request, options);
    }
    final metadata = <String, String>{'client': client.getClientHash()};
    if (client.isAuthorized) {
      final session = client.getSession()!;
      metadata['session'] = session.startsWith('SG-') ? session : 'SG-$session';
    }
    final nextOptions = options.mergedWith(CallOptions(metadata: metadata));
    final response = invoker(method, request, nextOptions);
    response.asStream().listen(
      null,
      onError: (Object error, StackTrace _) {
        if (isUnauthenticatedGrpcError(error)) {
          store.onUnauthenticatedGrpc?.call();
        }
      },
    );
    return response;
  }
}
