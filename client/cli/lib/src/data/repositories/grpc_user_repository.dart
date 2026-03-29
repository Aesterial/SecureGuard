import 'package:grpc/grpc.dart';
import 'package:protobuf/well_known_types/google/protobuf/empty.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/users/v1/domain.pb.dart'
    as userpb;
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/users/v1/service.pbgrpc.dart';
import 'package:secureguard_cli/src/clients/interceptors/global_interceptor.dart';
import 'package:secureguard_cli/src/domain/repositories/user_repository.dart';
import 'package:secureguard_cli/src/models/passwords.dart';
import 'package:secureguard_cli/src/models/user.dart';

class GrpcUserRepository implements UserRepository {
  final UserServiceClient _client;

  GrpcUserRepository({required ClientChannel channel})
    : _client = UserServiceClient(channel, interceptors: [GlobalInterceptor()]);

  @override
  Future<Crypt> changeCrypt({required Crypt crypt}) async {
    try {
      final response = await _client.changeCrypt(
        userpb.ChangeCryptRequest(value: crypt.protobuf),
      );
      if (!response.hasResult()) {
        throw StateError("user repository failed to change crypt field");
      }
      return Crypt.fromProto(response.result);
    } on GrpcError {
      rethrow;
    }
  }

  @override
  Future<Languages> changeLanguage({required Languages lang}) async {
    try {
      final response = await _client.changeLanguage(
        userpb.ChangeLanguageRequest(value: lang.protobuf),
      );
      if (!response.hasResult()) {
        throw StateError("user repository failed to change language field");
      }
      return Languages.fromProto(response.result);
    } on GrpcError {
      rethrow;
    }
  }

  @override
  Future<Themes> changeTheme({required Themes theme}) async {
    try {
      final response = await _client.changeTheme(
        userpb.ChangeThemeRequest(value: theme.protobuf),
      );
      if (!response.hasResult()) {
        throw StateError("user repository failed to change theme field");
      }
      return Themes.fromProto(response.result);
    } on GrpcError {
      rethrow;
    }
  }

  @override
  Future<User> info() async {
    try {
      final response = await _client.info(Empty());
      if (!response.hasInfo()) {
        throw StateError("user repository failed to get user information");
      }
      return User.fromProto(usr: response.info);
    } on GrpcError {
      rethrow;
    }
  }

  @override
  Future<void> changeKey({
    required String wrappedMasterKey,
    required String salt,
    required KdfParams kdf,
  }) async {
    await _client.changeKey(
      RequestWithValueAndKdf(
        value: wrappedMasterKey,
        salt: salt,
        kdf: kdf.protobuf(),
      ),
    );
  }
}
