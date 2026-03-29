import 'dart:convert';
import 'dart:typed_data';

import 'package:secureguard_cli/src/crypto/engine.dart';
import 'package:secureguard_cli/src/models/passwords.dart';
import 'package:secureguard_cli/src/models/vault.dart';
import 'package:secureguard_cli/src/services/password_crypto_service.dart';
import 'package:test/test.dart';

void main() {
  group('PasswordCryptoService', () {
    test('decrypts an entry with a provided master key', () async {
      final engine = PasswordCryptoEngine();
      final service = PasswordCryptoService(engine);
      final masterKey = Uint8List.fromList(
        List<int>.generate(32, (index) => index + 1),
      );
      final encryptedLogin = await engine.encryptPasswordWithMasterKey(
        'alice@example.com',
        masterKey,
      );
      final encryptedPassword = await engine.encryptPasswordWithMasterKey(
        'sup3r-secret',
        masterKey,
      );

      final record = await service.decryptEntryWithMasterKey(
        password: Password(
          id: 'pw-1',
          service: ServiceInfo(url: 'https://example.com', name: 'Example'),
          loginPreview: '',
          encryptedLogin: encryptedLogin,
          encryptedPassword: encryptedPassword,
          legacyEnvelope: null,
          createdAt: DateTime.utc(2026, 1, 1),
        ),
        masterKey: base64Encode(masterKey),
      );

      expect(record.login, 'alice@example.com');
      expect(record.password, 'sup3r-secret');
    });

    test(
      'decrypts an entry with a seed phrase via wrapped master key',
      () async {
        final engine = PasswordCryptoEngine();
        final service = PasswordCryptoService(engine);
        final envelope = await engine.prepareMasterKeyEnvelope(
          'test',
          'aes256gcm-argon2id',
        );
        service.rememberBundle(
          UserKeyBundle(
            envelope: envelope,
            kdfVersion: 19,
            kdfMemory: 65536,
            kdfIterations: 3,
            kdfParallelism: 4,
          ),
        );
        final masterKey = await engine.unwrapMasterKey(envelope, 'test');
        final encryptedLogin = await engine.encryptPasswordWithMasterKey(
          'alice@example.com',
          masterKey,
        );
        final encryptedPassword = await engine.encryptPasswordWithMasterKey(
          'sup3r-secret',
          masterKey,
        );
        masterKey.fillRange(0, masterKey.length, 0);

        final record = await service.decryptEntryWithMasterKey(
          password: Password(
            id: 'pw-2',
            service: ServiceInfo(url: 'https://example.com', name: 'Example'),
            loginPreview: '',
            encryptedLogin: encryptedLogin,
            encryptedPassword: encryptedPassword,
            legacyEnvelope: null,
            createdAt: DateTime.utc(2026, 1, 1),
          ),
          masterKey: 'test',
        );

        expect(record.login, 'alice@example.com');
        expect(record.password, 'sup3r-secret');
      },
    );
  });
}
