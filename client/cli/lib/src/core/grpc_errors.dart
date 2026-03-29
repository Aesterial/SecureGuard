import 'package:grpc/grpc.dart';

bool isUnauthenticatedGrpcError(Object error) {
  return error is GrpcError && error.code == StatusCode.unauthenticated;
}
