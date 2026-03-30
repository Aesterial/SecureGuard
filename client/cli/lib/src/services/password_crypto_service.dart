import 'dart:typed_data';

import 'package:secureguard_cli/src/crypto/engine.dart';
import 'package:secureguard_cli/src/models/passwords.dart';
import 'package:secureguard_cli/src/models/user.dart';
import 'package:secureguard_cli/src/models/vault.dart';

class PasswordCryptoService {
  PasswordCryptoService(this._engine);

  final PasswordCryptoEngine _engine;
  UserKeyBundle? _currentBundle;

  UserKeyBundle? get currentBundle => _currentBundle;

  Future<RegistrationCryptoMaterial> buildRegistrationMaterial({
    required String seedPhrase,
    required Crypt crypt,
  }) async {
    final envelope = await _engine.prepareMasterKeyEnvelope(
      seedPhrase,
      cryptToEncryptionAlgorithm(crypt),
    );
    return RegistrationCryptoMaterial(
      bundle: UserKeyBundle(
        envelope: envelope,
        kdfVersion: 19,
        kdfMemory: 65536,
        kdfIterations: 3,
        kdfParallelism: 4,
      ),
    );
  }

  void rememberBundle(UserKeyBundle bundle) {
    _currentBundle = bundle;
  }

  void clearCurrentEnvelope() {
    _currentBundle = null;
  }

  Future<EncryptedPasswordRecord> encryptEntry({
    required String login,
    required String password,
    required String seedPhrase,
    UserKeyBundle? preferredBundle,
  }) async {
    final sourceBundle = preferredBundle ?? _currentBundle;
    if (sourceBundle == null || !sourceBundle.envelope.isComplete) {
      throw StateError('User key bundle is unavailable');
    }

    final masterKey = await _engine.unwrapMasterKey(
      sourceBundle.envelope,
      seedPhrase,
    );

    try {
      final encryptedLogin = await _engine.encryptPasswordWithMasterKey(
        login,
        masterKey,
      );
      final encryptedPassword = await _engine.encryptPasswordWithMasterKey(
        password,
        masterKey,
      );
      return EncryptedPasswordRecord(
        encryptedLogin: encryptedLogin,
        encryptedPassword: encryptedPassword,
      );
    } finally {
      masterKey.fillRange(0, masterKey.length, 0);
    }
  }

  Future<DecryptedPasswordRecord> decryptEntry({
    required Password password,
    required String seedPhrase,
  }) async {
    final envelope = password.legacyEnvelope ?? _currentBundle?.envelope;
    if (envelope == null || !envelope.isComplete) {
      throw StateError('Vault envelope is unavailable for this entry');
    }

    final masterKey = await _engine.unwrapMasterKey(envelope, seedPhrase);
    try {
      final login = password.hasEncryptedLogin
          ? await _engine.decryptPasswordWithMasterKey(
              password.encryptedLogin,
              masterKey,
            )
          : password.loginPreview;
      final decryptedPassword = await _engine.decryptPasswordWithMasterKey(
        password.encryptedPassword,
        masterKey,
      );
      return DecryptedPasswordRecord(login: login, password: decryptedPassword);
    } finally {
      masterKey.fillRange(0, masterKey.length, 0);
    }
  }

  Future<DecryptedPasswordRecord> decryptEntryWithMasterKey({
    required Password password,
    required String masterKey,
  }) async {
    final rawKey = await _resolveMasterKey(
      secret: masterKey,
      password: password,
    );

    try {
      final login = password.hasEncryptedLogin
          ? await _engine.decryptPasswordWithMasterKey(
              password.encryptedLogin,
              rawKey,
            )
          : password.loginPreview;
      final decryptedPassword = await _engine.decryptPasswordWithMasterKey(
        password.encryptedPassword,
        rawKey,
      );
      return DecryptedPasswordRecord(login: login, password: decryptedPassword);
    } finally {
      rawKey.fillRange(0, rawKey.length, 0);
    }
  }

  Future<Uint8List> _resolveMasterKey({
    required String secret,
    required Password password,
  }) async {
    try {
      return _engine.parseMasterKey(secret);
    } on StateError {
      final envelope = password.legacyEnvelope ?? _currentBundle?.envelope;
      if (envelope == null || !envelope.isComplete) {
        rethrow;
      }
      return _engine.unwrapMasterKey(envelope, secret);
    }
  }
}
