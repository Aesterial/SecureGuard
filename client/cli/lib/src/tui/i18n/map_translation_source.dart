import 'package:secureguard_cli/src/models/user.dart';
import 'package:secureguard_cli/src/tui/models/translation_source.dart';

class MapTranslationSource implements TranslationSource {
  final Map<Languages, Map<String, String>> catalogs;

  const MapTranslationSource(this.catalogs);

  @override
  Future<Map<String, String>> load(Languages language) async {
    return Map<String, String>.from(
      catalogs[language] ?? const <String, String>{},
    );
  }
}
