# CLAUDE.md — security_doctor_lints guardrails

custom_lint companion of security_doctor: the Dart rules (SD001-SD004,
SD008) delivered as IDE lints. Conventions are identical to
security_doctor — squash-only PRs with Conventional Commit titles,
release-please + OIDC publishing, plain vX.Y.Z tags, no Claude
attribution, HTTPS push via `git -c
"credential.helper=!gh auth git-credential" push`.

## Invariants
- Rule logic lives in security_doctor; this package only adapts
  DartRule findings into analyzer diagnostics (rule_adapter.dart).
  Never fork rule logic here.
- Lint names are the lowercased rule ids (sd001…), so standard
  `// ignore: sd002` comments work.
- analyzer is pinned by custom_lint_builder (^8): keep security_doctor's
  analyzer floor at or below it, or resolution breaks.
- The integration test runs `dart run custom_lint` in example/ — that
  IS the coverage; no lcov gate here (plugin runs out-of-process).

## Status
- 0.1.0: adapters for SD001-SD004 + SD008, https:// quick fix for
  SD002, example project, e2e test. Blocked on security_doctor >=0.5.0
  being published (analyzer floor 8 + 22 secret formats).
- Local dev uses pubspec_overrides.yaml (gitignored) with a path
  dependency on ../security_doctor.
