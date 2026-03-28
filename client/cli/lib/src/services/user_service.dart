import 'package:secureguard_cli/src/domain/repositories/user_repository.dart';
import 'package:secureguard_cli/src/models/user.dart';

class UserService {
  final UserRepository _repository;

  UserService(this._repository);

  Future<User> info() => _repository.info();

  Future<Themes> changeTheme({required Themes theme}) =>
      _repository.changeTheme(theme: theme);

  Future<Languages> changeLanguage({required Languages lang}) =>
      _repository.changeLanguage(lang: lang);

  Future<Crypt> changeCrypt({required Crypt crypt}) =>
      _repository.changeCrypt(crypt: crypt);
}
