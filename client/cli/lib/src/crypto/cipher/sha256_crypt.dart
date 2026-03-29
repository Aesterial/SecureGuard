import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class Sha256Crypt {
  const Sha256Crypt();

  Future<Uint8List> deriveKey(String seedPhrase, List<int> salt) async {
    final hash = await Sha256().hash(<int>[...seedPhrase.codeUnits, ...salt]);
    return Uint8List.fromList(hash.bytes);
  }
}
