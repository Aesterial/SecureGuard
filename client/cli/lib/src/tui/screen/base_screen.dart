import 'package:secureguard_cli/src/models/user.dart';
import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/models/screen.dart';
import 'package:secureguard_cli/src/tui/models/screen_view.dart';
import 'package:secureguard_cli/src/tui/models/selector_item.dart';

abstract class BaseScreen implements Screen {
  const BaseScreen();

  @override
  Future<void> onEnter(TuiContext context) async {}

  @override
  ScreenView buildView(TuiContext context) {
    return ScreenView(
      title: route.titleKey,
      items: buildItems(context),
      content: buildContent(context),
    );
  }

  List<SelectorItem> buildItems(TuiContext context);

  List<String> buildContent(TuiContext context);

  String languageLabel(TuiContext context, Languages language) {
    return switch (language) {
      Languages.russian => context.tr('label.language.russian'),
      Languages.english => context.tr('label.language.english'),
    };
  }

  String themeLabel(TuiContext context, Themes theme) {
    return switch (theme) {
      Themes.black => context.tr('label.theme.black'),
      Themes.white => context.tr('label.theme.white'),
    };
  }

  String cryptLabel(TuiContext context, Crypt crypt) {
    return switch (crypt) {
      Crypt.argon2ID => context.tr('label.crypt.argon2id'),
      Crypt.sha256 => context.tr('label.crypt.sha256'),
    };
  }

  String formatDate(DateTime? value) {
    if (value == null) {
      return '-';
    }

    return value.toLocal().toIso8601String().replaceFirst('T', ' ');
  }
}
