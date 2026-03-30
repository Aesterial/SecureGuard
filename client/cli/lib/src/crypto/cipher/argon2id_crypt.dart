import 'dart:typed_data';

import 'package:argon2/argon2.dart';

class Argon2idCrypt {
  const Argon2idCrypt();

  static const int version = 0x13;
  static const int memory = 65536;
  static const int iterations = 3;
  static const int parallelism = 4;
  static const int keyLength = 32;

  Uint8List deriveKey(String seedPhrase, List<int> salt) {
    final generator = Argon2BytesGenerator()
      ..init(
        Argon2Parameters(
          Argon2Parameters.ARGON2_id,
          Uint8List.fromList(salt),
          version: Argon2Parameters.ARGON2_VERSION_13,
          iterations: iterations,
          memory: memory,
          lanes: parallelism,
        ),
      );
    final output = Uint8List(keyLength);
    generator.generateBytesFromString(seedPhrase, output);
    return output;
  }
}
