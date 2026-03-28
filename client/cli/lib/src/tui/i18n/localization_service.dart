import 'package:secureguard_cli/src/models/user.dart';
import 'package:secureguard_cli/src/tui/models/translation_source.dart';

class LocalizationService {
  final List<TranslationSource> _sources;

  Languages _language;
  Map<String, String> _catalog = <String, String>{};

  LocalizationService({
    required List<TranslationSource> sources,
    Languages initialLanguage = Languages.russian,
  }) : _sources = sources,
       _language = initialLanguage;

  Languages get language => _language;

  Future<void> bootstrap() => use(_language);

  Future<void> use(Languages language) async {
    final merged = <String, String>{};

    for (final source in _sources) {
      merged.addAll(await source.load(language));
    }

    _language = language;
    _catalog = merged;
  }

  String translate(
    String key, [
    Map<String, String> params = const <String, String>{},
  ]) {
    var value = _catalog[key] ?? key;

    for (final entry in params.entries) {
      value = value.replaceAll('%${entry.key}%', entry.value);
    }

    return value;
  }
}
