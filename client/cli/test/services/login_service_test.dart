import 'package:fixnum/fixnum.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';
import 'package:secureguard_cli/src/domain/models/auth_session.dart';
import 'package:secureguard_cli/src/domain/repositories/login_repository.dart';
import 'package:secureguard_cli/src/models/client.dart';
import 'package:secureguard_cli/src/models/user.dart' as user;
import 'package:secureguard_cli/src/services/login_service.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('LoginService', () {
    test('stores session after authorize', () async {
      final repository = _FakeLoginRepository();
      final store = ClientStore();
      final service = LoginService(repository, store);

      final session = await service.authorize(
        username: 'admin',
        password: 'secret',
      );

      expect(session.sessionToken, 'session-token');
      expect(store.isAuthorized, isTrue);
      expect(store.getSession(), 'session-token');
    });

    test('clears session after logout', () async {
      final repository = _FakeLoginRepository();
      final store = ClientStore()..set('session-token');
      final service = LoginService(repository, store);

      await service.logout();

      expect(repository.logoutCalled, isTrue);
      expect(store.isAuthorized, isFalse);
      expect(store.getSession(), isNull);
    });

    test('passes registration payload through repository', () async {
      final repository = _FakeLoginRepository();
      final store = ClientStore();
      final service = LoginService(repository, store);
      final kdf = Kdf(
        version: 1,
        memory: Int64(64),
        iterations: 3,
        parallelism: 2,
      );

      await service.register(
        username: 'new-user',
        password: 'secret',
        wrappedMasterKey: 'wrapped',
        salt: 'salt',
        kdfParams: kdf,
      );

      expect(repository.lastRegisterUsername, 'new-user');
      expect(repository.lastRegisterSalt, 'salt');
      expect(repository.lastRegisterKdf, same(kdf));
      expect(store.getSession(), 'session-token');
    });
  });
}

class _FakeLoginRepository implements LoginRepository {
  bool logoutCalled = false;
  String? lastRegisterUsername;
  String? lastRegisterSalt;
  Kdf? lastRegisterKdf;

  @override
  Future<AuthSession> authorize({
    required String username,
    required String password,
    String? wrappedMasterKey,
  }) async {
    return _session();
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  Future<AuthSession> register({
    required String username,
    required String password,
    required String wrappedMasterKey,
    required String salt,
    required Kdf kdfParams,
  }) async {
    lastRegisterUsername = username;
    lastRegisterSalt = salt;
    lastRegisterKdf = kdfParams;
    return _session();
  }

  AuthSession _session() {
    return AuthSession(
      user: user.User(id: UuidValue.fromString(Uuid().v4()), username: 'admin', joinedAt: DateTime(2026), staffMember: false, preferences: user.Preferences(theme: user.Themes.black, lang: user.Languages.english, crypt: user.Crypt.argon2ID)),
      sessionToken: 'session-token',
    );
  }
}
