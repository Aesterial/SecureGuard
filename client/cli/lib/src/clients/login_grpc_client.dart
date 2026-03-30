import 'package:grpc/grpc.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/login/v1/domain.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/login/v1/service.pbgrpc.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';
import 'package:secureguard_cli/src/clients/interceptors/global_interceptor.dart';

class LoginGrpcClient {
  final LoginServiceClient client;

  LoginGrpcClient(ClientChannel channel)
    : client = LoginServiceClient(channel, interceptors: [GlobalInterceptor()]);

  bool _validateResponse(LoginResponse response) {
    return response.hasInfo() && response.hasSession();
  }

  Future<LoginResponse?> register(
    String username,
    String password,
    String wrappedMasterKey,
    String salt,
    Kdf kdfParams,
  ) async {
    try {
      final response = await client.register(
        RegisterRequest(
          username: username,
          password: password,
          masterKey: wrappedMasterKey,
          salt: salt,
          kdfParams: kdfParams,
        ),
      );
      if (!_validateResponse(response)) {
        return null;
      }
      return response;
    } on GrpcError {
      rethrow;
    }
  }

  Future<LoginResponse?> authorize(
    String username,
    String password, {
    String? masterKey,
  }) async {
    try {
      final response = await client.authorize(
        AuthorizeRequest(
          username: username,
          password: password,
          masterKey: masterKey,
        ),
      );
      if (!_validateResponse(response)) {
        return null;
      }
      return response;
    } on GrpcError {
      rethrow;
    }
  }

  Future<bool> logout() async {
    try {
      await client.logout(Empty());
      return true;
    } on GrpcError {
      rethrow;
    }
  }
}
