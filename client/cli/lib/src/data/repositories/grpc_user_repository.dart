import 'package:grpc/grpc.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/users/v1/domain.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/users/v1/service.pbgrpc.dart';
import 'package:secureguard_cli/src/clients/interceptors/global_interceptor.dart';
import 'package:secureguard_cli/src/domain/repositories/user_repository.dart';
import 'package:secureguard_cli/src/models/user.dart' as user;

class GrpcUserRepository implements UserRepository {
  final UserServiceClient _client;

  GrpcUserRepository({required ClientChannel channel}) : _client = UserServiceClient(channel, interceptors: [GlobalInterceptor()]);

  @override
  Future<Crypt> changeCrypt({required user.Crypt crypt}) async {
    try {
      final response = await _client.changeCrypt(ChangeCryptRequest(value: crypt.protobuf));
      return response.result;
    } on GrpcError {
      rethrow;
    }
  }

  @override
  Future<Language> changeLanguage({required user.Languages lang}) async {
    try {
      final response = await _client.changeLanguage(ChangeLanguageRequest(value: lang.protobuf));
      return response.result;
    } on GrpcError {
      rethrow;
    }
  }

  @override
  Future<Theme> changeTheme({required user.Themes theme}) async {
    try {
      final response = await _client.changeTheme(ChangeThemeRequest(value: theme.protobuf));
      return response.result;
    } on GrpcError {
      rethrow;
    }
  }

  @override
  Future<UserSelf> info() async {
    try {
      final response = await _client.info(Empty());
      return response.info;
    } on GrpcError {
      rethrow;
    }
  }
}
