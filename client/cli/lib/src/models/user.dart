import 'package:uuid/uuid.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/users/v1/domain.pb.dart'
    as user;

enum Themes {
  black('black'),
  white('white');

  final String name;
  const Themes(this.name);

  user.Theme get protobuf => switch (this) {
    Themes.black => user.Theme.THEME_BLACK,
    Themes.white => user.Theme.THEME_WHITE,
  };

  static Themes fromProto(user.Theme theme) => switch (theme) {
    user.Theme.THEME_WHITE => Themes.white,
    user.Theme.THEME_BLACK => Themes.black,
    user.Theme.THEME_UNSPECIFIED => Themes.white,
    _ => Themes.white,
  };
}

enum Languages {
  russian('russian'),
  english('english');

  final String str;
  const Languages(this.str);

  user.Language get protobuf => switch (this) {
    Languages.english => user.Language.LANGUAGE_EN,
    Languages.russian => user.Language.LANGUAGE_RU,
  };

  static Languages fromProto(user.Language lang) => switch (lang) {
    user.Language.LANGUAGE_RU => Languages.russian,
    user.Language.LANGUAGE_EN => Languages.english,
    user.Language.LANGUAGE_UNSPECIFIED => Languages.russian,
    _ => Languages.russian,
  };
}

enum Crypt {
  argon2ID('argon2id'),
  sha256('sha256');

  const Crypt(this.str);

  final String str;

  user.Crypt get protobuf => switch (this) {
    Crypt.argon2ID => user.Crypt.CRYPT_ARGON2ID,
    Crypt.sha256 => user.Crypt.CRYPT_SHA256,
  };

  static Crypt fromProto(user.Crypt crypt) => switch (crypt) {
    user.Crypt.CRYPT_ARGON2ID => Crypt.argon2ID,
    user.Crypt.CRYPT_SHA256 => Crypt.sha256,
    user.Crypt.CRYPT_UNSPECIFIED => Crypt.argon2ID,
    _ => Crypt.argon2ID,
  };
}

class Preferences {
  Themes theme;
  Languages lang;
  Crypt crypt;

  Preferences({
    required this.theme,
    required this.lang,
    required this.crypt
  });

  factory Preferences.fromProto({required user.Preferences prefs}) {
    return Preferences(theme: Themes.fromProto(prefs.theme), lang: Languages.fromProto(prefs.lang), crypt: Crypt.fromProto(prefs.crypto));
  }
}

class User {
  final UuidValue id;
  final String username;
  final DateTime joinedAt;
  final bool staffMember;
  final Preferences preferences;

  User({
    required this.id,
    required this.username,
    required this.joinedAt,
    required this.staffMember,
    required this.preferences,
  });
  factory User.fromProto({required user.UserSelf usr}) {
    return User(
      id: UuidValue.fromString(usr.id),
      username: usr.username,
      joinedAt: usr.joined.toDateTime(),
      staffMember: usr.staff,
      preferences: Preferences.fromProto(prefs: usr.preferences),
    );
  }
}
