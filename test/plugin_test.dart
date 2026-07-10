import 'dart:io';

import 'package:test/test.dart';

/// Drives the real plugin end to end: runs `dart run custom_lint` in
/// the example project and checks the findings that come back.
void main() {
  test(
    'custom_lint surfaces the Dart rules in the example project',
    () async {
      final pubGet = await Process.run(
        'dart',
        ['pub', 'get'],
        workingDirectory: 'example',
      );
      expect(pubGet.exitCode, 0, reason: '${pubGet.stderr}');

      final result = await Process.run(
        'dart',
        ['run', 'custom_lint'],
        workingDirectory: 'example',
      );
      final output = '${result.stdout}\n${result.stderr}';

      for (final code in ['sd001', 'sd002', 'sd003', 'sd004', 'sd008']) {
        expect(output, contains('• $code •'), reason: code);
      }
      // Severity mapping: critical/high render as ERROR, medium as WARNING.
      expect(output, contains('• sd001 • ERROR'));
      expect(output, contains('• sd002 • WARNING'));
      // Findings must fail the run, so `dart run custom_lint` works as a
      // CI gate too.
      expect(result.exitCode, isNot(0));
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
