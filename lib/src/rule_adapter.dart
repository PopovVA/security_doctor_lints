import 'dart:math' as math;

// ignore_for_file: deprecated_member_use
// custom_lint_core 0.8 still speaks the AnalysisError/ErrorReporter
// dialect of the analyzer API; we match its signatures.
import 'package:analyzer/error/error.dart' as analyzer;
import 'package:analyzer/error/listener.dart' show ErrorReporter;
import 'package:analyzer/source/source_range.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:security_doctor/security_doctor.dart';

/// Wraps one security_doctor [DartRule] as a custom_lint rule. The rule
/// logic stays in security_doctor; this only translates findings into
/// analyzer diagnostics.
class SecurityDoctorLint extends DartLintRule {
  SecurityDoctorLint(this.rule)
      : super(
          code: LintCode(
            name: rule.id.toLowerCase(),
            problemMessage: rule.title,
          ),
        );

  final DartRule rule;

  static analyzer.ErrorSeverity _severityOf(Severity severity) =>
      switch (severity) {
        Severity.low => analyzer.ErrorSeverity.INFO,
        Severity.medium => analyzer.ErrorSeverity.WARNING,
        Severity.high || Severity.critical => analyzer.ErrorSeverity.ERROR,
      };

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCompilationUnit((unit) {
      final content = resolver.source.contents.data;
      final file = ScanFile(
        path: resolver.path,
        content: content,
        kind: FileKind.dart,
      );
      for (final finding in rule.check(file, unit)) {
        final line = finding.line;
        if (line == null) continue;
        final lineInfo = unit.lineInfo;
        final offset =
            lineInfo.getOffsetOfLine(line - 1) + (finding.column ?? 1) - 1;
        final lineEnd = line < lineInfo.lineCount
            ? lineInfo.getOffsetOfLine(line) - 1
            : content.length;
        reporter.atOffset(
          offset: offset,
          length: math.max(1, lineEnd - offset),
          errorCode: LintCode(
            name: rule.id.toLowerCase(),
            problemMessage:
                '${finding.message} (${rule.masvs}, CWE-${rule.cwe})',
            errorSeverity: _severityOf(rule.severity),
          ),
        );
      }
    });
  }

  @override
  List<Fix> getFixes() => rule.id == 'SD002' ? [UseHttpsFix()] : const [];
}

/// Quick fix for SD002: rewrite the `http://` scheme to `https://`.
class UseHttpsFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    analyzer.AnalysisError analysisError,
    List<analyzer.AnalysisError> others,
  ) {
    final content = resolver.source.contents.data;
    final range = content.indexOf(
      RegExp('http://', caseSensitive: false),
      analysisError.offset,
    );
    if (range == -1 || range >= analysisError.offset + analysisError.length) {
      return;
    }
    reporter
        .createChangeBuilder(message: 'Use https://', priority: 80)
        .addDartFileEdit((builder) {
      builder.addSimpleReplacement(SourceRange(range, 7), 'https://');
    });
  }
}
