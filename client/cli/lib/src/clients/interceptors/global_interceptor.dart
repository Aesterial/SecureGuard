import 'package:grpc/grpc.dart';
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
      metadata['session'] = client.getSession()!;
    }
    final nextOptions = options.mergedWith(CallOptions(metadata: metadata));
    return invoker(method, request, nextOptions);
  }
}
