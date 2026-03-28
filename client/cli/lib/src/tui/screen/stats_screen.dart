import 'package:secureguard_cli/src/models/stats.dart';
import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/modals/enter_value.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';
import 'package:secureguard_cli/src/tui/models/selector_item.dart';
import 'package:secureguard_cli/src/tui/render/formatting.dart';
import 'package:secureguard_cli/src/tui/screen/base_screen.dart';

class StatsScreen extends BaseScreen {
  const StatsScreen();

  @override
  Route get route => Route.stats;

  @override
  Future<void> onEnter(TuiContext context) async {
    if (context.hasAdminAccess && context.state.stats == null) {
      await _loadToday(context);
    }
  }

  @override
  List<SelectorItem> buildItems(TuiContext context) {
    return <SelectorItem>[
      SelectorItem(label: context.tr('selector.refresh')),
      SelectorItem(label: context.tr('selector.pickDate')),
    ];
  }

  @override
  List<String> buildContent(TuiContext context) {
    if (!context.hasAdminAccess) {
      return <String>[context.tr('status.adminRequired')];
    }

    final stats = context.state.stats;
    final total = context.state.total;
    if (stats == null || total == null) {
      return <String>[context.tr('stats.noData')];
    }

    return <String>[
      context.tr('stats.totalUsers',
          <String, String>{'value': total.users.toString()}),
      context.tr(
        'stats.totalAdmins',
        <String, String>{'value': total.admins.toString()},
      ),
      context.tr(
        'stats.totalPasswords',
        <String, String>{'value': total.passwords.toString()},
      ),
      context.tr(
        'stats.totalSessions',
        <String, String>{'value': total.activeSessions.toString()},
      ),
      '',
      context.tr(
        'stats.topServices',
        <String, String>{'value': joinKeyValues(stats.topServices)},
      ),
      context.tr(
        'stats.themeUses',
        <String, String>{'value': joinKeyValues(stats.themeUses)},
      ),
      context.tr(
        'stats.languageUses',
        <String, String>{'value': joinKeyValues(stats.languageUses)},
      ),
      context.tr(
        'stats.cryptUses',
        <String, String>{'value': joinKeyValues(stats.cryptUses)},
      ),
      context.tr(
        'stats.usersGraph',
        <String, String>{'value': _formatGraph(stats.usersActivityGraph)},
      ),
      context.tr(
        'stats.registerGraph',
        <String, String>{'value': _formatGraph(stats.registerActivityGraph)},
      ),
    ];
  }

  @override
  Future<void> onSelect(TuiContext context, int index) async {
    switch (index) {
      case 0:
        await _loadToday(context);
        return;
      case 1:
        final values = await context.prompt(buildDateModal(context));
        if (values == null) {
          context.setStatus(context.tr('common.cancelled'));
          return;
        }

        final date = DateTime.parse(values['date']!);
        context.state.statsDate = date;
        context.state.stats = await context.app.statsService.byDate(date);
        context.state.total = await context.app.statsService.getTotal();
        context.setStatus(context.tr('status.statsLoaded'));
        return;
      default:
        context.setStatus(context.tr('status.selectionOnly'));
    }
  }

  Future<void> _loadToday(TuiContext context) async {
    if (!context.hasAdminAccess) {
      context.setStatus(context.tr('status.adminRequired'), isError: true);
      return;
    }

    context.state.statsDate = DateTime.now();
    context.state.stats = await context.app.statsService.today();
    context.state.total = await context.app.statsService.getTotal();
    context.setStatus(context.tr('status.statsLoaded'));
  }

  String _formatGraph(List<GraphPoint> points) {
    if (points.isEmpty) {
      return 'n/a';
    }

    return points
        .take(5)
        .map((point) => '${point.time.month}/${point.time.day}:${point.value}')
        .join(', ');
  }
}
