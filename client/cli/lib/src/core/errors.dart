import 'package:grpc/grpc.dart' as grpc;

class Errors {
  grpc.GrpcError status;
  String content;
  Errors(this.status, this.content);

  bool isEquals(String other) {
    return content == other || status.toString() == other;
  }

  void addDetail(String some) {
    content = '$content $some';
  }
}

Errors serverError = Errors(grpc.GrpcError.internal(), "server returned error");
