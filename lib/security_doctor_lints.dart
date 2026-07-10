/// IDE delivery for security_doctor's Dart rules: SD001-SD004 and
/// SD008 as custom_lint lints, straight in the editor.
library;

import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:security_doctor/security_doctor.dart';

import 'src/rule_adapter.dart';

/// The custom_lint entrypoint.
PluginBase createPlugin() => _SecurityDoctorLints();

class _SecurityDoctorLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        // Only the Dart-AST rules make sense in the analyzer: manifest,
        // plist and gradle rules stay in the security_doctor CLI/CI.
        for (final rule in builtInRules.whereType<DartRule>())
          SecurityDoctorLint(rule),
      ];
}
