import 'package:secureguard_cli/src/models/user.dart';

abstract interface class TranslationSource {
  Future<Map<String, String>> load(Languages language);
}
