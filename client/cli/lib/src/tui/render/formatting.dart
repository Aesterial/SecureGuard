List<String> wrapText(String text, int width) {
  if (width <= 0) {
    return <String>[''];
  }

  if (text.isEmpty) {
    return <String>[''];
  }

  final normalized = text.replaceAll('\r', '');
  final lines = <String>[];

  for (final rawLine in normalized.split('\n')) {
    if (rawLine.length <= width) {
      lines.add(rawLine);
      continue;
    }

    final words = rawLine.split(' ');
    var buffer = '';
    for (final word in words) {
      final candidate = buffer.isEmpty ? word : '$buffer $word';
      if (candidate.length <= width) {
        buffer = candidate;
        continue;
      }

      if (buffer.isNotEmpty) {
        lines.add(buffer);
      }

      if (word.length <= width) {
        buffer = word;
        continue;
      }

      var offset = 0;
      while (offset < word.length) {
        final next = offset + width > word.length
            ? word.length
            : offset + width;
        lines.add(word.substring(offset, next));
        offset = next;
      }
      buffer = '';
    }

    if (buffer.isNotEmpty) {
      lines.add(buffer);
    }
  }

  return lines.isEmpty ? <String>[''] : lines;
}

String fit(String value, int width) {
  if (width <= 0) {
    return '';
  }

  if (value.length == width) {
    return value;
  }

  if (value.length < width) {
    return value.padRight(width);
  }

  if (width == 1) {
    return value.substring(0, 1);
  }

  return '${value.substring(0, width - 1)}~';
}

String joinKeyValues(Map<String, int> values) {
  if (values.isEmpty) {
    return 'n/a';
  }

  return values.entries
      .map((entry) => '${entry.key}:${entry.value}')
      .join(', ');
}
