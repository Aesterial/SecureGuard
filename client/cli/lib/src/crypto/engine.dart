import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:secureguard_cli/src/crypto/cipher/argon2id_crypt.dart';
import 'package:secureguard_cli/src/crypto/cipher/sha256_crypt.dart';
import 'package:secureguard_cli/src/models/vault.dart';

class PasswordCryptoEngine {
  PasswordCryptoEngine({
    Argon2idCrypt? argon2idCrypt,
    Sha256Crypt? sha256Crypt,
    AesGcm? aesGcm,
    Random? random,
  }) : _argon2idCrypt = argon2idCrypt ?? const Argon2idCrypt(),
       _sha256Crypt = sha256Crypt ?? const Sha256Crypt(),
       _aesGcm = aesGcm ?? AesGcm.with256bits(),
       _random = random ?? Random.secure();

  final Argon2idCrypt _argon2idCrypt;
  final Sha256Crypt _sha256Crypt;
  final AesGcm _aesGcm;
  final Random _random;

  Uint8List generateMasterKey() {
    return Uint8List.fromList(
      List<int>.generate(32, (_) => _random.nextInt(256)),
    );
  }

  Future<MasterKeyEnvelope> prepareMasterKeyEnvelope(
    String seedPhrase,
    String encryptionAlgorithm,
  ) async {
    final masterKey = generateMasterKey();
    try {
      return await wrapMasterKey(masterKey, seedPhrase, encryptionAlgorithm);
    } finally {
      masterKey.fillRange(0, masterKey.length, 0);
    }
  }

  Future<MasterKeyEnvelope> wrapMasterKey(
    List<int> masterKey,
    String seedPhrase,
    String encryptionAlgorithm,
  ) async {
    final algorithm = normalizeEncryptionAlgorithm(encryptionAlgorithm);
    final wrappingSalt = Uint8List.fromList(
      List<int>.generate(16, (_) => _random.nextInt(256)),
    );
    final wrappingKey = await _deriveKey(seedPhrase, wrappingSalt, algorithm);

    try {
      final wrappedMasterKey = await _encryptBytesWithKey(
        masterKey,
        wrappingKey,
      );
      return MasterKeyEnvelope(
        wrappedMasterKey: wrappedMasterKey,
        wrappingSalt: base64Encode(wrappingSalt),
        encryptionAlgorithm: algorithm,
      );
    } finally {
      wrappingKey.fillRange(0, wrappingKey.length, 0);
      wrappingSalt.fillRange(0, wrappingSalt.length, 0);
    }
  }

  Future<Uint8List> unwrapMasterKey(
    MasterKeyEnvelope envelope,
    String seedPhrase,
  ) async {
    final wrappingSalt = _decodeBase64(envelope.wrappingSalt, 'Salt decode');
    final wrappingKey = await _deriveKey(
      seedPhrase,
      wrappingSalt,
      envelope.encryptionAlgorithm,
    );

    try {
      final masterKey = await _decryptBytesWithKey(
        envelope.wrappedMasterKey,
        wrappingKey,
      );
      if (masterKey.length != 32) {
        masterKey.fillRange(0, masterKey.length, 0);
        throw StateError('Invalid master key');
      }
      return Uint8List.fromList(masterKey);
    } finally {
      wrappingKey.fillRange(0, wrappingKey.length, 0);
      wrappingSalt.fillRange(0, wrappingSalt.length, 0);
    }
  }

  Future<String> encryptPasswordWithMasterKey(
    String plainText,
    List<int> masterKey,
  ) {
    return _encryptBytesWithKey(utf8.encode(plainText), masterKey);
  }

  Future<String> decryptPasswordWithMasterKey(
    String encryptedValue,
    List<int> masterKey,
  ) async {
    final bytes = await _decryptBytesWithKey(encryptedValue, masterKey);
    try {
      return utf8.decode(bytes);
    } on FormatException {
      throw StateError('UTF-8: invalid secret payload');
    } finally {
      bytes.fillRange(0, bytes.length, 0);
    }
  }

  Future<Uint8List> _deriveKey(
    String seedPhrase,
    List<int> salt,
    String encryptionAlgorithm,
  ) async {
    final algorithm = normalizeEncryptionAlgorithm(encryptionAlgorithm);
    return switch (algorithm) {
      aes256GcmArgon2id => _argon2idCrypt.deriveKey(seedPhrase, salt),
      aes256GcmSha256 => _sha256Crypt.deriveKey(seedPhrase, salt),
      _ => _argon2idCrypt.deriveKey(seedPhrase, salt),
    };
  }

  Future<String> _encryptBytesWithKey(
    List<int> plainText,
    List<int> key,
  ) async {
    final nonce = _aesGcm.newNonce();
    final secretBox = await _aesGcm.encrypt(
      plainText,
      secretKey: SecretKey(key),
      nonce: nonce,
    );
    final combined = <int>[
      ...secretBox.nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ];
    return base64Encode(combined);
  }

  Future<Uint8List> _decryptBytesWithKey(
    String encryptedValue,
    List<int> key,
  ) async {
    final combined = _decodeBase64(encryptedValue, 'Data decode');
    if (combined.length < 12 + 16) {
      combined.fillRange(0, combined.length, 0);
      throw StateError('Invalid encrypted data');
    }

    final nonce = Uint8List.sublistView(combined, 0, 12);
    final cipherTextEnd = combined.length - 16;
    final cipherText = Uint8List.sublistView(combined, 12, cipherTextEnd);
    final macBytes = Uint8List.sublistView(combined, cipherTextEnd);

    try {
      final plainText = await _aesGcm.decrypt(
        SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes)),
        secretKey: SecretKey(key),
      );
      return Uint8List.fromList(plainText);
    } on SecretBoxAuthenticationError {
      throw StateError('Wrong seed phrase or corrupted data');
    } finally {
      combined.fillRange(0, combined.length, 0);
    }
  }

  Uint8List _decodeBase64(String value, String prefix) {
    try {
      return Uint8List.fromList(base64Decode(value));
    } on FormatException catch (error) {
      throw StateError('$prefix: ${error.message}');
    }
  }
}
