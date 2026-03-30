import 'package:secureguard_cli/src/models/sessions.dart';
import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/models/modal.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';
import 'package:secureguard_cli/src/tui/models/selector_item.dart';
import 'package:secureguard_cli/src/tui/screen/base_screen.dart';

class SessionsScreen extends BaseScreen {
  const SessionsScreen();

  @override
  Route get route => Route.sessions;

  @override
  Future<void> onEnter(TuiContext context) async {
    if (context.app.loginService.isAuthorized &&
        context.state.sessions.isEmpty) {
      await _refresh(context);
    }
  }

  @override
  List<SelectorItem> buildItems(TuiContext context) {
    final items = <SelectorItem>[
      SelectorItem(label: context.tr('selector.refresh')),
      SelectorItem(label: context.tr('selector.toggleRevoked')),
    ];

    items.addAll(
      context.state.sessions.map(
        (session) => SelectorItem(
          label: session.hash,
          subtitle: formatDate(session.created),
        ),
      ),
    );

    return items;
  }

  @override
  List<String> buildContent(TuiContext context) {
    if (!context.app.loginService.isAuthorized) {
      return <String>[context.tr('status.needAuthorization')];
    }

    final lines = <String>[
      context.tr('sessions.summary', <String, String>{
        'count': context.state.sessions.length.toString(),
      }),
      context.tr('sessions.showRevoked', <String, String>{
        'value': context.state.showRevokedSessions
            ? context.tr('common.yes')
            : context.tr('common.no'),
      }),
      '',
    ];

    final session = _selectedSession(context);
    if (session == null) {
      lines.add(
        context.state.sessions.isEmpty
            ? context.tr('sessions.empty')
            : context.tr('status.selectionOnly'),
      );
      return lines;
    }

    lines.addAll(<String>[
      context.tr('sessions.selected', <String, String>{'hash': session.hash}),
      context.tr('sessions.id', <String, String>{'value': session.id}),
      context.tr('sessions.hash', <String, String>{'value': session.hash}),
      context.tr('sessions.created', <String, String>{
        'value': formatDate(session.created),
      }),
      context.tr('sessions.expires', <String, String>{
        'value': formatDate(session.expires),
      }),
      context.tr('sessions.lastSeen', <String, String>{
        'value': formatDate(session.lastSeen),
      }),
      context.tr('sessions.revoked', <String, String>{
        'value': session.revoke?.revoked == true
            ? formatDate(session.revoke?.at)
            : context.tr('common.no'),
      }),
    ]);

    return lines;
  }

  @override
  Future<void> onSelect(TuiContext context, int index) async {
    if (index == 0) {
      await _refresh(context);
      return;
    }

    if (index == 1) {
      context.state.showRevokedSessions = !context.state.showRevokedSessions;
      context.state.setSelection(route, 0);
      await _refresh(context);
      return;
    }

    final session = _selectedSession(context);
    if (session == null) {
      context.setStatus(context.tr('sessions.empty'));
      return;
    }

    if (session.revoke?.revoked == true) {
      context.setStatus(context.tr('status.selectionOnly'));
      return;
    }

    final confirmed = await context.confirm(
      ConfirmModal(
        title: context.tr('modal.session.title'),
        description: context.tr('modal.session.description'),
        confirmLabel: context.tr('common.confirm'),
        cancelLabel: context.tr('common.cancel'),
      ),
    );

    if (!confirmed) {
      context.setStatus(context.tr('common.cancelled'));
      return;
    }

    await context.app.sessionsService.revoke(id: session.id);
    await _refresh(context);
    context.setStatus(context.tr('status.sessionRevoked'));
  }

  Session? _selectedSession(TuiContext context) {
    final index = context.state.selectionFor(route) - 2;
    if (index < 0 || index >= context.state.sessions.length) {
      return null;
    }

    return context.state.sessions[index];
  }

  Future<void> _refresh(TuiContext context) async {
    if (!context.app.loginService.isAuthorized) {
      context.setStatus(context.tr('status.needAuthorization'), isError: true);
      return;
    }

    context.state.sessions = await context.app.sessionsService.getList(
      limit: 20,
      offset: 0,
      showRevoked: context.state.showRevokedSessions,
    );
    context.setStatus(context.tr('status.sessionsLoaded'));
  }
}
