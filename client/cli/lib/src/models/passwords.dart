import 'package:secureguard_cli/src/api/xyz/secureguard/v1/passwords/v1/domain.pb.dart' as passwords;

class KdfParams {
  final String alg;
  final String salt;
  final int memory;
  final int iterations;
  final int parallelism;
  final int keyLength;
  const KdfParams(
    this.alg,
    this.salt,
    this.memory,
    this.iterations,
    this.parallelism,
    this.keyLength,
  );
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
