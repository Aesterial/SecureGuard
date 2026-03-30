import 'package:secureguard_cli/src/models/user.dart';
import 'package:secureguard_cli/src/tui/i18n/localization_service.dart';
import 'package:secureguard_cli/src/tui/i18n/map_translation_source.dart';
import 'package:test/test.dart';

void main() {
  group('LocalizationService', () {
    test('merges sources and interpolates values', () async {
      final service = LocalizationService(
        sources: <MapTranslationSource>[
          const MapTranslationSource(<Languages, Map<String, String>>{
            Languages.english: <String, String>{
              'title': 'Base %name%',
              'footer': 'plain',
            },
          }),
          const MapTranslationSource(<Languages, Map<String, String>>{
            Languages.english: <String, String>{'footer': 'override'},
          }),
        ],
        initialLanguage: Languages.english,
      );

      await service.bootstrap();

      expect(
        service.translate('title', <String, String>{'name': 'UI'}),
        'Base UI',
      );
      expect(service.translate('footer'), 'override');
    });

    test('switches between locales', () async {
      final service = LocalizationService(
        sources: <MapTranslationSource>[
          const MapTranslationSource(<Languages, Map<String, String>>{
            Languages.russian: <String, String>{'hello': 'privet'},
            Languages.english: <String, String>{'hello': 'hello'},
          }),
        ],
      );

      await service.bootstrap();
      expect(service.translate('hello'), 'privet');

      await service.use(Languages.english);
      expect(service.translate('hello'), 'hello');
    });

    test('applies overlay translations over base catalog', () async {
      final service = LocalizationService(
        sources: <MapTranslationSource>[
          const MapTranslationSource(<Languages, Map<String, String>>{
            Languages.english: <String, String>{
              'title': 'base',
              'footer': 'default',
            },
          }),
        ],
        initialLanguage: Languages.english,
      );

      await service.bootstrap();
      await service.setOverlay(
        const MapTranslationSource(<Languages, Map<String, String>>{
          Languages.english: <String, String>{
            'footer': 'server',
            'extra': 'loaded',
          },
        }),
      );

      expect(service.translate('title'), 'base');
      expect(service.translate('footer'), 'server');
      expect(service.translate('extra'), 'loaded');
    });
  });
}
