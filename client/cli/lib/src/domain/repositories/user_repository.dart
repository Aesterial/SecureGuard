import 'package:secureguard_cli/src/models/user.dart';

abstract interface class UserRepository {
  Future<User> info();

  Future<Themes> changeTheme({required Themes theme});

  Future<Languages> changeLanguage({required Languages lang});

  Future<Crypt> changeCrypt({required Crypt crypt});
}
