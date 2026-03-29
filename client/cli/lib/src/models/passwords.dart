import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/passwords/v1/domain.pb.dart'
    as passwords;
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';
import 'package:secureguard_cli/src/models/vault.dart';

class KdfParams {
  final String alg;
  final String salt;
  final Int64 memory;
  final int iterations;
  final int parallelism;
  final int keyLength;
  final int version;

  KdfParams(
    this.alg,
    this.salt,
    mem,
    this.iterations,
    this.parallelism,
    this.keyLength,
    this.version,
  ) : memory = Int64(mem);

  Kdf protobuf() {
    return Kdf(
      version: version,
      parallelism: parallelism,
      memory: memory,
      iterations: iterations,
    );
  }
}

class Crypted {
  final KdfParams kdf;
  final String cipher;
  final String nonce;
  const Crypted(this.cipher, this.nonce, this.kdf);
}

class ServiceInfo {
  final String url;
  final String name;

  ServiceInfo({required this.url, required this.name});
  factory ServiceInfo.fromProto({required passwords.ServiceInfo service}) {
    return ServiceInfo(url: service.url, name: service.name);
  }
}

class Password {
  final String id;
  final ServiceInfo service;
  final String loginPreview;
  final String encryptedLogin;
  final String encryptedPassword;
  final MasterKeyEnvelope? legacyEnvelope;
  final DateTime createdAt;

  Password({
    required this.id,
    required this.service,
    required this.loginPreview,
    required this.encryptedLogin,
    required this.encryptedPassword,
    required this.legacyEnvelope,
    required this.createdAt,
  });

  bool get hasEncryptedLogin => encryptedLogin.trim().isNotEmpty;

  factory Password.fromProto({required passwords.Password password}) {
    final payloadFromPass = LegacyPasswordPayload.tryParse(password.pass);
    final payloadFromLogin = LegacyPasswordPayload.tryParse(password.login);
    final carriedPayload =
        payloadFromPass != null && payloadFromPass.hasEmbeddedEnvelope
        ? payloadFromPass
        : payloadFromLogin;
    final encryptedLogin =
        carriedPayload == null && _looksLikeEncryptedField(password.login)
        ? password.login
        : '';
    final encryptedPassword =
        carriedPayload?.encryptedPassword?.trim().isNotEmpty == true
        ? carriedPayload!.encryptedPassword!
        : password.pass;
    final loginPreview = carriedPayload?.login.trim().isNotEmpty == true
        ? carriedPayload!.login
        : _decodeLegacyLogin(password.login);

    return Password(
      id: password.id,
      service: ServiceInfo.fromProto(service: password.serv),
      loginPreview: loginPreview == password.login && encryptedLogin.isNotEmpty
          ? ''
          : loginPreview,
      encryptedLogin: encryptedLogin,
      encryptedPassword: encryptedPassword,
      legacyEnvelope:
          carriedPayload != null &&
              carriedPayload.wrappedMasterKey.trim().isNotEmpty &&
              carriedPayload.salt.trim().isNotEmpty
          ? MasterKeyEnvelope(
              wrappedMasterKey: carriedPayload.wrappedMasterKey,
              wrappingSalt: carriedPayload.salt,
              encryptionAlgorithm: carriedPayload.encryptionAlgorithm,
            )
          : null,
      createdAt: password.createdAt.toDateTime(),
    );
  }

  static String _decodeLegacyLogin(String rawLogin) {
    if (rawLogin.trim().isEmpty) {
      return '';
    }

    try {
      final decoded = jsonDecode(rawLogin);
      if (decoded is Map<String, dynamic>) {
        final login = decoded['login'];
        if (login is String && login.trim().isNotEmpty) {
          return login;
        }
      }
    } on FormatException {
      // The login is plain text for legacy entries.
    }

    return rawLogin;
  }

  static bool _looksLikeEncryptedField(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty || normalized.length < 24) {
      return false;
    }

    try {
      final decoded = base64Decode(normalized);
      return decoded.length >= 28;
    } on FormatException {
      return false;
    }
  }
}
