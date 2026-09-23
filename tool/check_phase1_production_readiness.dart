import 'dart:io';

void main() {
  final result = Process.runSync('flutter', <String>[
    'test',
    '--no-pub',
    'tool/phase1_production_readiness_gate_test.dart',
    '--reporter',
    'expanded',
  ], runInShell: Platform.isWindows);

  stdout.write(result.stdout);
  stderr.write(result.stderr);
  exitCode = result.exitCode;
}
