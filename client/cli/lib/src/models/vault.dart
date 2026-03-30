import 'dart:convert';

import 'package:secureguard_cli/src/models/user.dart';

const String aes256GcmArgon2id = 'aes256gcm-argon2id';
const String aes256GcmSha256 = 'aes256gcm-sha256';

String cryptToEncryptionAlgorithm(Crypt crypt) {
  return switch (crypt) {
    Crypt.argon2ID => aes256GcmArgon2id,
    Crypt.sha256 => aes256GcmSha256,
  };
}

String normalizeEncryptionAlgorithm([String? value]) {
  final normalized = (value ?? '').trim().toLowerCase();
  return switch (normalized) {
    '' ||
    'default' ||
    'argon2id' ||
    'aes-256-gcm-argon2id' => aes256GcmArgon2id,
    'aes256gcm-argon2id' => aes256GcmArgon2id,
    'sha256' || 'sha-256' || 'aes-256-gcm-sha256' => aes256GcmSha256,
    'aes256gcm-sha256' => aes256GcmSha256,
    _ => aes256GcmArgon2id,
  };
}

class MasterKeyEnvelope {
  final String wrappedMasterKey;
  final String wrappingSalt;
  final String encryptionAlgorithm;

  const MasterKeyEnvelope({
    required this.wrappedMasterKey,
    required this.wrappingSalt,
    required this.encryptionAlgorithm,
  });

  bool get isComplete =>
      wrappedMasterKey.trim().isNotEmpty && wrappingSalt.trim().isNotEmpty;
}

class UserKeyBundle {
  final MasterKeyEnvelope envelope;
  final int kdfVersion;
  final int kdfMemory;
  final int kdfIterations;
  final int kdfParallelism;

  const UserKeyBundle({
    required this.envelope,
    required this.kdfVersion,
    required this.kdfMemory,
    required this.kdfIterations,
    required this.kdfParallelism,
  });

  String toJsonString() {
    return jsonEncode(<String, Object>{
      'wrapped_master_key': envelope.wrappedMasterKey,
      'salt': envelope.wrappingSalt,
      'encryption_method': envelope.encryptionAlgorithm,
      'version': kdfVersion,
      'memory': kdfMemory,
      'iterations': kdfIterations,
      'parallelism': kdfParallelism,
    });
  }

  static UserKeyBundle? tryParse(String raw, {Crypt? fallbackCrypt}) {
    if (raw.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      return UserKeyBundle(
        envelope: MasterKeyEnvelope(
          wrappedMasterKey: _readString(decoded, 'wrapped_master_key'),
          wrappingSalt: _readString(decoded, 'salt'),
          encryptionAlgorithm: normalizeEncryptionAlgorithm(
            _readString(decoded, 'encryption_method').isNotEmpty
                ? _readString(decoded, 'encryption_method')
                : cryptToEncryptionAlgorithm(fallbackCrypt ?? Crypt.argon2ID),
          ),
        ),
        kdfVersion: _readInt(decoded, 'version'),
        kdfMemory: _readInt(decoded, 'memory'),
        kdfIterations: _readInt(decoded, 'iterations'),
        kdfParallelism: _readInt(decoded, 'parallelism'),
      );
    } on FormatException {
      return null;
    }
  }

  static String _readString(Map<String, dynamic> source, String key) {
    final value = source[key];
    return value is String ? value : '';
  }

  static int _readInt(Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return 0;
  }
}

class LegacyPasswordPayload {
  final String login;
  final String salt;
  final String wrappedMasterKey;
  final String encryptionAlgorithm;
  final String? encryptedPassword;

  const LegacyPasswordPayload({
    required this.login,
    required this.salt,
    required this.wrappedMasterKey,
    required this.encryptionAlgorithm,
    this.encryptedPassword,
  });

  bool get hasEmbeddedEnvelope =>
      salt.trim().isNotEmpty || wrappedMasterKey.trim().isNotEmpty;

  static LegacyPasswordPayload? tryParse(String raw) {
    if (raw.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final login = decoded['login'];
      final salt = decoded['salt'];
      final wrappedMasterKey = decoded['wrapped_master_key'];
      if (login is! String &&
          salt is! String &&
          wrappedMasterKey is! String &&
          decoded['encrypted_password'] is! String) {
        return null;
      }

      return LegacyPasswordPayload(
        login: login is String ? login : '',
        salt: salt is String ? salt : '',
        wrappedMasterKey: wrappedMasterKey is String ? wrappedMasterKey : '',
        encryptionAlgorithm: normalizeEncryptionAlgorithm(
          decoded['encryption_algorithm'] as String?,
        ),
        encryptedPassword: decoded['encrypted_password'] as String?,
      );
    } on FormatException {
      return null;
    }
  }
}

class EncryptedPasswordRecord {
  final String encryptedLogin;
  final String encryptedPassword;

  const EncryptedPasswordRecord({
    required this.encryptedLogin,
    required this.encryptedPassword,
  });

  static const int version = 1;
  static const String nonce = 'self-contained-aesgcm-v1';
  static const List<int> aad = <int>[1];
  static const String metadata = '{"format":"self-contained-aesgcm-v1"}';
}

class DecryptedPasswordRecord {
  final String login;
  final String password;

  const DecryptedPasswordRecord({required this.login, required this.password});
}

class RegistrationCryptoMaterial {
  final UserKeyBundle bundle;

  const RegistrationCryptoMaterial({required this.bundle});
}
