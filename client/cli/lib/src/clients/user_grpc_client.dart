import 'package:grpc/grpc.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/users/v1/domain.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/users/v1/service.pbgrpc.dart';
import 'package:secureguard_cli/src/clients/interceptors/global_interceptor.dart';

import '../models/user.dart' as user;

class UserGrpcClient {
  final UserServiceClient client;

  UserGrpcClient(ClientChannel channel)
    : client = UserServiceClient(channel, interceptors: [GlobalInterceptor()]);

  Future<UserResponse> info() async {
    try {
      final response = await client.info(Empty());
      return response;
    } on GrpcError {
      rethrow;
    }
  }

  Future<ChangeThemeResponse> changeTheme({required user.Themes theme}) async {
    final body = ChangeThemeRequest(value: theme.protobuf);
    try {
      final response = await client.changeTheme(body);
      return response;
    } on GrpcError {
      rethrow;
    }
  }

  Future<ChangeCryptResponse> changeCrypt({required user.Crypt crypt}) async {
    final body = ChangeCryptRequest(value: crypt.protobuf);
    try {
      final response = await client.changeCrypt(body);
      return response;
    } on GrpcError {
      rethrow;
    }
  }

  Future<ChangeLanguageResponse> changeLanguage({
    required user.Languages lang,
  }) async {
    final body = ChangeLanguageRequest(value: lang.protobuf);
    try {
      final response = await client.changeLanguage(body);
      return response;
    } on GrpcError {
      rethrow;
    }
  }
}
