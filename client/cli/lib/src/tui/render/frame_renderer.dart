import 'dart:math' as math;

import 'package:dart_console/dart_console.dart';
import 'package:secureguard_cli/src/core/constants.dart';
import 'package:secureguard_cli/src/tui/core/hotkeys.dart';
import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/models/route.dart';
import 'package:secureguard_cli/src/tui/models/screen_view.dart';
import 'package:secureguard_cli/src/tui/render/formatting.dart';

class FrameRenderer {
  void render(
    TuiContext context,
    ScreenView view, {
    required int selectedIndex,
  }) {
    final console = context.console;
    final screenWidth = console.windowWidth;
    final width = math.max(72, math.max(1, console.windowWidth - 1));
    final height = math.max(22, math.max(1, console.windowHeight - 1));
    final insideWidth = width - 2;
    final headerName =
        context.state.currentUser?.username ?? context.tr('common.guest');

    final selectorWidth = math.max(
      24,
      math.min(42, (insideWidth * 0.33).floor()),
    );
    final contentWidth = insideWidth - selectorWidth - 1;
    final pageCount = _pageCount(view.items.length);
    final currentPage = _pageForSelection(selectedIndex, view.items.length);
    final bodyHeight = math.max(8, height - 9);

    final selectorLines = _selectorLines(view, selectorWidth, selectedIndex);
    final contentLines = _contentLines(context, view, contentWidth, bodyHeight);
    final pageLine = context.tr('footer.page', <String, String>{
      'current': (currentPage + 1).toString(),
      'total': pageCount.toString(),
      'from': view.items.isEmpty
          ? '0'
          : (currentPage * selectorPageSize + 1).toString(),
      'to': view.items.isEmpty
          ? '0'
          : math
                .min((currentPage + 1) * selectorPageSize, view.items.length)
                .toString(),
      'count': view.items.length.toString(),
    });
    final footerRoutes = _footerRoutes(context);
    final footerLine = context.tr('footer.navigation', <String, String>{
      'routes': footerRoutes,
    });
    final hintLine = context.tr('footer.hints');

    final lines = <String>[
      '+${'-' * insideWidth}+',
      '|${fit('${context.tr('app.title')} v$version', insideWidth ~/ 2)}'
          '${fit(headerName, insideWidth - (insideWidth ~/ 2))}|',
      '|${fit(context.tr(view.title), insideWidth)}|',
      '|${'-' * insideWidth}|',
    ];

    for (var row = 0; row < bodyHeight; row++) {
      final selector = row < selectorLines.length ? selectorLines[row] : '';
      final content = row < contentLines.length ? contentLines[row] : '';
      lines.add(
        '|${fit(selector, selectorWidth)}|${fit(content, contentWidth)}|',
      );
    }

    lines.addAll(<String>[
      '|${'-' * insideWidth}|',
      '|${fit(pageLine, insideWidth)}|',
      '|${fit(footerLine, insideWidth)}|',
      '|${fit(hintLine, insideWidth)}|',
      '+${'-' * insideWidth}+',
    ]);

    for (var row = 0; row < lines.length; row++) {
      console.cursorPosition = Coordinate(row, 0);
      _applyLineColors(context, row, lines.length);
      console.write(fit(lines[row], screenWidth));
    }

    console.resetColorAttributes();
  }

  List<String> _selectorLines(
    ScreenView view,
    int selectorWidth,
    int selectedIndex,
  ) {
    final lines = <String>[];
    final page = _pageForSelection(selectedIndex, view.items.length);
    final start = page * selectorPageSize;
    final end = math.min(start + selectorPageSize, view.items.length);

    for (var index = start; index < end; index++) {
      final item = view.items[index];
      final localIndex = index - start;
      final marker = index == selectedIndex ? '>' : ' ';
      final number = '[${localIndex + 1}]';
      final line = '$marker $number ${item.label}';
      lines.addAll(wrapText(line, selectorWidth));
      if (item.subtitle != null && item.subtitle!.isNotEmpty) {
        lines.addAll(wrapText('    ${item.subtitle!}', selectorWidth));
      }
    }

    return lines;
  }

  List<String> _contentLines(
    TuiContext context,
    ScreenView view,
    int width,
    int bodyHeight,
  ) {
    final lines = <String>[];
    for (final line in view.content) {
      lines.addAll(wrapText(line, width));
    }

    if (context.state.statusMessage != null) {
      lines.add('');
      final prefix = context.state.statusIsError ? 'ERROR' : 'INFO';
      lines.addAll(wrapText('$prefix: ${context.state.statusMessage!}', width));
    }

    if (lines.length > bodyHeight) {
      return lines.take(bodyHeight).toList();
    }

    return lines;
  }

  String _footerRoutes(TuiContext context) {
    final routes = <String>[];

    for (final route in Route.values) {
      if (route.primaryHotkey == null ||
          route == context.state.currentRoute ||
          !context.canAccessRoute(route)) {
        continue;
      }

      final title = context.tr(route.titleKey);
      routes.add(
        context.tr('footer.route', <String, String>{
          'key': route.hotkeyLabel,
          'title': title,
        }),
      );
    }

    if (context.app.loginService.isAuthorized) {
      routes.add(
        context.tr('footer.route', <String, String>{
          'key': logoutHotkeyLabel,
          'title': context.tr('selector.logout'),
        }),
      );
    }

    return routes.join(' | ');
  }

  int _pageCount(int itemCount) {
    if (itemCount <= 0) {
      return 1;
    }

    return ((itemCount - 1) ~/ selectorPageSize) + 1;
  }

  int _pageForSelection(int selectedIndex, int itemCount) {
    if (itemCount <= 0 || selectedIndex < 0) {
      return 0;
    }

    return math.min(
      selectedIndex ~/ selectorPageSize,
      _pageCount(itemCount) - 1,
    );
  }

  void _applyLineColors(TuiContext context, int row, int totalLines) {
    final console = context.console;
    final isFrame = row <= 3 || row >= totalLines - 4;

    if (context.state.theme.name == 'white') {
      console.setBackgroundColor(ConsoleColor.white);
      if (isFrame) {
        console.setForegroundColor(ConsoleColor.brightBlack);
      } else {
        console.setForegroundColor(ConsoleColor.black);
      }
      return;
    }

    console.setBackgroundColor(ConsoleColor.black);
    if (isFrame) {
      console.setForegroundColor(ConsoleColor.white);
    } else {
      console.setForegroundColor(ConsoleColor.brightWhite);
    }
  }
}
