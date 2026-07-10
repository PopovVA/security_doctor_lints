# security_doctor_lints

[![CI](https://github.com/PopovVA/security_doctor_lints/actions/workflows/ci.yml/badge.svg)](https://github.com/PopovVA/security_doctor_lints/actions/workflows/ci.yml)

[security_doctor](https://pub.dev/packages/security_doctor)'s Dart
rules, delivered straight into the IDE via
[custom_lint](https://pub.dev/packages/custom_lint): squiggles under
hardcoded secrets and cleartext URLs as you type, with quick fixes.

| Lint | Rule | Severity in IDE |
| --- | --- | --- |
| `sd001` | Hardcoded secrets and API keys (22 known formats + entropy) | error |
| `sd002` | Cleartext `http://` URLs — with a **Use https://** quick fix | warning |
| `sd003` | Sensitive data written to SharedPreferences | error |
| `sd004` | Weak cryptography (MD5, SHA-1, ECB) | error |
| `sd008` | Credentials in `print`/`log` output | warning |

The manifest/plist/gradle rules (SD005-SD007, SD009-SD010) live in the
security_doctor CLI — the analyzer only sees Dart files.

## Setup

```yaml
# pubspec.yaml
dev_dependencies:
  custom_lint: ^0.8.0
  security_doctor_lints: ^0.1.0
```

```yaml
# analysis_options.yaml
analyzer:
  plugins:
    - custom_lint
```

Restart the analysis server (or the IDE) and open any Dart file. In CI
the same lints run with `dart run custom_lint`.

## Suppressing

Standard analyzer comments work: `// ignore: sd002` on the line above,
or `// ignore_for_file: sd002`. For project-wide policy, thresholds and
baselines, use the [security_doctor](https://pub.dev/packages/security_doctor)
CLI — this package is the IDE view of the same rules.

## License

[MIT](LICENSE)
