import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';
import 'package:secureguard_cli/src/tui/models/selector_item.dart';
import 'package:secureguard_cli/src/tui/screen/base_screen.dart';

class WelcomeScreen extends BaseScreen {
  const WelcomeScreen();

  @override
  Route get route => Route.welcome;

  @override
  Future<void> onEnter(TuiContext context) async {
    await _refreshServer(context);
  }

  @override
  List<SelectorItem> buildItems(TuiContext context) {
    return <SelectorItem>[
      SelectorItem(label: context.tr('selector.openLogin')),
      SelectorItem(label: context.tr('selector.openSettings')),
      SelectorItem(label: context.tr('selector.refresh')),
    ];
  }

  @override
  List<String> buildContent(TuiContext context) {
    final info = context.state.serverMetadata;
    final compatibility = context.state.serverCompatibility;
    final lines = <String>[
      context.tr('welcome.headline'),
      context.tr('welcome.description'),
      '',
      context.tr(
        'welcome.server',
        <String, String>{
          'server': context.app.configService.current.serverUri.toString(),
        },
      ),
    ];

    if (info == null) {
      lines.add(context.tr('welcome.noInfo'));
      return lines;
    }

    lines.addAll(<String>[
      context.tr('welcome.serverName', <String, String>{'name': info.name}),
      context.tr(
        'welcome.serverVersion',
        <String, String>{'version': info.version},
      ),
      context.tr(
        'welcome.runtime',
        <String, String>{'runtime': info.runtimeVersion},
      ),
      context.tr(
        'welcome.repository',
        <String, String>{'repository': info.repository},
      ),
    ]);

    if (compatibility != null) {
      final status = compatibility.isCompatible
          ? context.tr('label.compatible')
          : context.tr('label.incompatible');
      lines.add(
        context.tr('welcome.compatibility', <String, String>{'status': status}),
      );
      if (compatibility.reasons.isNotEmpty) {
        lines.add(
          context.tr(
            'welcome.reasons',
            <String, String>{'reasons': compatibility.reasons.join(', ')},
          ),
        );
      }
    }

    return lines;
  }

  @override
  Future<void> onSelect(TuiContext context, int index) async {
    switch (index) {
      case 0:
        await context.navigate(Route.login, pushToHistory: false);
        return;
      case 1:
        await context.navigate(Route.settings, pushToHistory: false);
        return;
      case 2:
        await _refreshServer(context);
        return;
      default:
        context.setStatus(context.tr('status.selectionOnly'));
    }
  }

  Future<void> _refreshServer(TuiContext context) async {
    context.state.serverMetadata =
    await context.app.metaService.fetchServerInfo();
    context.state.serverCompatibility =
    await context.app.metaService.checkCompatibility();
    context.setStatus(context.tr('status.serverLoaded'));
  }
}
