import 'dart:async';
import 'dart:io';

class ClipboardService {
  Timer? _clearTimer;
  int _generation = 0;

  Future<void> copyTemporarily(
    String value, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await _writeClipboard(value);
    _generation += 1;
    final currentGeneration = _generation;
    _clearTimer?.cancel();
    _clearTimer = Timer(timeout, () async {
      if (currentGeneration != _generation) {
        return;
      }
      try {
        await _writeClipboard('');
      } on Object {
        // Ignore clipboard cleanup failures.
      }
    });
  }

  Future<void> clear() async {
    _generation += 1;
    _clearTimer?.cancel();
    await _writeClipboard('');
  }

  Future<void> _writeClipboard(String value) async {
    if (Platform.isWindows) {
      await _pipeToProcess('cmd', const <String>['/c', 'clip'], value);
      return;
    }

    if (Platform.isMacOS) {
      await _pipeToProcess('pbcopy', const <String>[], value);
      return;
    }

    final linuxCandidates = <({String command, List<String> args})>[
      (command: 'wl-copy', args: const <String>[]),
      (command: 'xclip', args: const <String>['-selection', 'clipboard']),
      (command: 'xsel', args: const <String>['--clipboard', '--input']),
    ];

    Object? lastError;
    for (final candidate in linuxCandidates) {
      try {
        await _pipeToProcess(candidate.command, candidate.args, value);
        return;
      } on Object catch (error) {
        lastError = error;
      }
    }

    throw StateError(
      lastError?.toString() ?? 'No clipboard command is available',
    );
  }

  Future<void> _pipeToProcess(
    String command,
    List<String> args,
    String value,
  ) async {
    final process = await Process.start(command, args);
    process.stdin.write(value);
    await process.stdin.close();
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      final stderr = await process.stderr
          .transform(SystemEncoding().decoder)
          .join();
      throw StateError(
        stderr.trim().isEmpty
            ? 'Clipboard command "$command" failed with code $exitCode'
            : stderr.trim(),
      );
    }
  }
}
