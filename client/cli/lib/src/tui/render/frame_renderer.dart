import 'dart:math' as math;

import 'package:dart_console/dart_console.dart';
import 'package:secureguard_cli/src/core/constants.dart';
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
    final width = math.max(72, math.min(console.windowWidth, 120));
    final height = math.max(22, math.min(console.windowHeight, 36));
    final insideWidth = width - 2;
    final headerName =
        context.state.currentUser?.username ?? context.tr('common.guest');
    final uid =
        context.state.currentUser?.id.toString() ??
        context.tr('common.unknown');
    final staff = context.state.currentUser?.staffMember == true
        ? context.tr('label.staff')
        : '';

    final selectorWidth = math.max(
      24,
      math.min(34, (insideWidth * 0.33).floor()),
    );
    final contentWidth = insideWidth - selectorWidth - 1;
    final bodyHeight = height - 7;

    final selectorLines = _selectorLines(view, selectorWidth, selectedIndex);
    final contentLines = _contentLines(context, view, contentWidth, bodyHeight);
    final footerRoutes = _footerRoutes(context);
    final footerLine = context.tr('footer.navigation', <String, String>{
      'routes': footerRoutes,
    });
    final hintLine = context.tr('footer.hints');

    final lines = <String>[
      '+${'-' * insideWidth}+',
      '|${fit('${context.tr('app.title')} v$version', insideWidth ~/ 2)}'
          '${fit(headerName, insideWidth - (insideWidth ~/ 2))}|',
      '|${fit(context.tr(view.title), insideWidth ~/ 2)}'
          '${fit('$uid ${staff.trim()}'.trim(), insideWidth - (insideWidth ~/ 2))}|',
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
      '|${fit(footerLine, insideWidth)}|',
      '|${fit(hintLine, insideWidth)}|',
      '+${'-' * insideWidth}+',
    ]);

    for (var row = 0; row < lines.length; row++) {
      console.cursorPosition = Coordinate(row, 0);
      if (row <= 3 || row >= lines.length - 4) {
        console.setForegroundColor(ConsoleColor.cyan);
      } else {
        console.resetColorAttributes();
      }
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

    for (var index = 0; index < view.items.length; index++) {
      final item = view.items[index];
      final marker = index == selectedIndex ? '>' : ' ';
      final number = index < 9 ? '[${index + 1}]' : '[ ]';
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
      if (route.hotkey == null || route == context.state.currentRoute) {
        continue;
      }

      final title = context.tr(route.titleKey);
      routes.add(
        context.tr('footer.route', <String, String>{
          'key': route.hotkey!,
          'title': title,
        }),
      );
    }

    return routes.join(' | ');
  }
}
