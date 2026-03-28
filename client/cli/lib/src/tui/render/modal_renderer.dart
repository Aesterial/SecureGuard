import 'dart:math' as math;

import 'package:dart_console/dart_console.dart';
import 'package:secureguard_cli/src/tui/core/tui_context.dart';
import 'package:secureguard_cli/src/tui/models/modal.dart';
import 'package:secureguard_cli/src/tui/models/screen_view.dart';
import 'package:secureguard_cli/src/tui/render/formatting.dart';

class ModalRenderer {
  Future<bool> confirm(TuiContext context, ConfirmModal modal) async {
    _drawOverlay(context, modal.title, <String>[
      modal.description,
      '',
      '[1] ${modal.confirmLabel}    [2] ${modal.cancelLabel}',
    ]);

    while (true) {
      final key = context.console.readKey();

      if (key.isControl) {
        if (key.controlChar == ControlCharacter.enter) {
          return true;
        }
        if (key.controlChar == ControlCharacter.escape) {
          return false;
        }
        continue;
      }

      if (key.char == '1') {
        return true;
      }
      if (key.char == '2') {
        return false;
      }
    }
  }

  Future<Map<String, String>?> promptValues(
    TuiContext context,
    ValueModal modal,
  ) async {
    final values = <String, String>{};

    for (var index = 0; index < modal.fields.length; index++) {
      final layout = _drawPromptOverlay(
        context,
        modal,
        activeFieldIndex: index,
        values: values,
      );

      final input = _readFieldValue(
        context,
        layout,
        modal.fields[index].defaultValue ?? '',
      );
      if (input == null) {
        return null;
      }

      final field = modal.fields[index];
      values[field.name] = input.isEmpty ? (field.defaultValue ?? '') : input;
    }

    _drawOverlay(context, modal.title, <String>[
      modal.description,
      '',
      ...modal.fields.map((field) {
        final value = values[field.name] ?? '';
        final visible = field.obscure ? ('*' * value.length) : value;
        return '${field.label}: $visible';
      }),
      '',
      '[Enter] confirm   [Esc] cancel',
    ]);

    while (true) {
      final key = context.console.readKey();
      if (key.isControl) {
        if (key.controlChar == ControlCharacter.enter) {
          return values;
        }
        if (key.controlChar == ControlCharacter.escape) {
          return null;
        }
      }
    }
  }

  void _drawOverlay(TuiContext context, String title, List<String> rawLines) {
    final view = ScreenView(
      title: context.state.currentRoute.titleKey,
      items: const [],
      content: const [],
    );
    context.frameRenderer.render(context, view, selectedIndex: 0);

    final console = context.console;
    final width = math.max(42, math.min(console.windowWidth - 8, 68));
    final contentWidth = width - 2;
    final lines = <String>[
      '+${'-' * contentWidth}+',
      '|${fit(title, contentWidth)}|',
      ...rawLines
          .expand((line) => wrapText(line, contentWidth))
          .map((line) => '|${fit(line, contentWidth)}|'),
      '+${'-' * contentWidth}+',
    ];
    final startRow = math.max(1, (console.windowHeight - lines.length) ~/ 2);
    final startCol = math.max(1, (console.windowWidth - width) ~/ 2);

    console.setForegroundColor(ConsoleColor.brightWhite);
    for (var index = 0; index < lines.length; index++) {
      console.cursorPosition = Coordinate(startRow + index, startCol);
      console.write(lines[index]);
    }
    console.resetColorAttributes();
  }

  _PromptLayout _drawPromptOverlay(
    TuiContext context,
    ValueModal modal, {
    required int activeFieldIndex,
    required Map<String, String> values,
  }) {
    final console = context.console;
    final width = math.max(42, math.min(console.windowWidth - 8, 68));
    final contentWidth = width - 2;
    final fieldRows = <int>[];
    final lines = <String>[
      '+${'-' * contentWidth}+',
      '|${fit(modal.title, contentWidth)}|',
    ];

    for (final line in wrapText(modal.description, contentWidth)) {
      lines.add('|${fit(line, contentWidth)}|');
    }
    lines.add('|${fit('', contentWidth)}|');

    for (var index = 0; index < modal.fields.length; index++) {
      final field = modal.fields[index];
      final marker = index == activeFieldIndex ? '>' : ' ';
      final value = values[field.name] ?? field.defaultValue ?? '';
      final visible = field.obscure ? ('*' * value.length) : value;
      final prefix = '$marker ${field.label}: ';
      fieldRows.add(lines.length);
      lines.add('|${fit('$prefix$visible', contentWidth)}|');
    }

    lines.add('|${fit('', contentWidth)}|');
    lines.add('|${fit('[Enter] save field   [Esc] cancel', contentWidth)}|');
    lines.add('+${'-' * contentWidth}+');

    final startRow = math.max(1, (console.windowHeight - lines.length) ~/ 2);
    final startCol = math.max(1, (console.windowWidth - width) ~/ 2);

    final view = ScreenView(
      title: context.state.currentRoute.titleKey,
      items: const [],
      content: const [],
    );
    context.frameRenderer.render(context, view, selectedIndex: 0);

    console.setForegroundColor(ConsoleColor.brightWhite);
    for (var index = 0; index < lines.length; index++) {
      console.cursorPosition = Coordinate(startRow + index, startCol);
      console.write(lines[index]);
    }
    console.resetColorAttributes();

    final field = modal.fields[activeFieldIndex];
    final prefixLength = 2 + field.label.length + 2;
    final inputCol = startCol + 1 + prefixLength;
    final maxLength = math.max(1, contentWidth - prefixLength);

    return _PromptLayout(
      row: startRow + fieldRows[activeFieldIndex],
      col: inputCol,
      maxLength: maxLength,
      initialValue: values[field.name] ?? field.defaultValue ?? '',
      obscure: field.obscure,
    );
  }

  String? _readFieldValue(
    TuiContext context,
    _PromptLayout layout,
    String initialValue,
  ) {
    final console = context.console;
    final buffer = StringBuffer(
      layout.initialValue.isEmpty ? initialValue : layout.initialValue,
    );

    void repaint() {
      final value = buffer.toString();
      final visible = layout.obscure ? ('*' * value.length) : value;
      console.cursorPosition = Coordinate(layout.row, layout.col);
      console.write(fit(visible, layout.maxLength));
      final cursorOffset = value.length.clamp(0, layout.maxLength - 1);
      console.cursorPosition = Coordinate(
        layout.row,
        layout.col + cursorOffset,
      );
    }

    repaint();

    while (true) {
      final key = console.readKey();
      if (key.isControl) {
        switch (key.controlChar) {
          case ControlCharacter.enter:
            return buffer.toString();
          case ControlCharacter.escape:
            return null;
          case ControlCharacter.backspace:
          case ControlCharacter.ctrlH:
            final value = buffer.toString();
            if (value.isNotEmpty) {
              buffer.clear();
              buffer.write(value.substring(0, value.length - 1));
              repaint();
            }
            continue;
          default:
            continue;
        }
      }

      if (buffer.length >= layout.maxLength) {
        continue;
      }

      buffer.write(key.char);
      repaint();
    }
  }
}

class _PromptLayout {
  final int row;
  final int col;
  final int maxLength;
  final String initialValue;
  final bool obscure;

  const _PromptLayout({
    required this.row,
    required this.col,
    required this.maxLength,
    required this.initialValue,
    required this.obscure,
  });
}
