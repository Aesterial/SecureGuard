import 'package:secureguard_cli/src/api/xyz/secureguard/v1/users/v1/domain.pb.dart';
import 'package:secureguard_cli/src/models/user.dart' as user;

abstract interface class UserRepository {
  Future<UserSelf> info();
  Future<Theme> changeTheme({required user.Themes theme});
  Future<Language> changeLanguage({required user.Languages lang});
  Future<Crypt> changeCrypt({required user.Crypt crypt});
}
