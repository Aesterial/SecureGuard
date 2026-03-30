import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';
import 'package:secureguard_cli/src/tui/models/screen_view.dart';

abstract interface class Screen {
  Route get route;

  Future<void> onEnter(TuiContext context);

  ScreenView buildView(TuiContext context);

  Future<void> onSelect(TuiContext context, int index);
}
