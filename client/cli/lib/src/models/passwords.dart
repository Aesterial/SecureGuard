import 'package:fixnum/fixnum.dart';
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/passwords/v1/domain.pb.dart' as passwords;
import 'package:secureguard_cli/src/api/xyz/secureguard/v1/types.pb.dart';

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
      this.version,) : memory = Int64(mem);

  Kdf protobuf() {
    return Kdf(version: version,
        parallelism: parallelism,
        memory: memory,
        iterations: iterations);
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
  final ServiceInfo service;
  final String login;
  final String pass;
  final DateTime createdAt;

  Password({required this.service, required this.login, required this.pass, required this.createdAt});

  factory Password.fromProto({required passwords.Password password}) {
    return Password(service: ServiceInfo.fromProto(service: password.serv), login: password.login, pass: password.pass, createdAt: password.createdAt.toDateTime());
  }
}
