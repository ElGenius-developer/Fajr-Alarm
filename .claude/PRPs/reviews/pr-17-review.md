# PR Review — #17 `fix/flutter-3-50-upgrade` → `main`

**Reviewed HEAD:** `bc3ec8c` · **Date:** 2026-11-21 · **Decision: APPROVE**

## Summary
Flutter 3.50.1 upgrade. Imports move from deprecated `package:flutter/material.dart` to `package:material_ui`. Adds a shared `appLocalizationsDelegates`, because gen-l10n still emits the `flutter_localizations` delegate types that `material_ui` widgets cannot find. The gen-l10n output is excluded from analysis. Android: AGP 9.1.1, compileSdk 36. targetSdk stays 35 (Constitution §2).

## Findings
CRITICAL 0 · HIGH 0 · MEDIUM 0 · LOW 1

- **LOW-1:** `AppLocalizations.localizationsDelegates` (generated) still exists and is now a trap. A new widget test that uses it fails to find MaterialLocalizations in Arabic. This is mitigated by the doc comment on `appLocalizationsDelegates`.

## Gates
Domain purity, secrets, l10n and platform contract all pass. The non-import diff is limited to the delegates list, `main.dart`, tests, `analysis_options.yaml`, Gradle, and `.gitignore` (`/android/build/`).

## Validation (real output)
| Check | Result |
|---|---|
| `dart format --set-exit-if-changed .` | 0 changed |
| `dart analyze --fatal-infos` | No issues found! |
| `flutter test` | +250: All tests passed! |
| `flutter build apk --release --obfuscate` | Built app-release.apk (72.3MB) |
| `flutter build ios --release --no-codesign` | Built Runner.app (21.7MB) |
| CI | none configured |
