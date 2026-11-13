# Fajr-Alarm — Constitution Gates

Checked against the PR diff during `pr-guard` Phase 2. CRITICAL/HIGH findings block the merge. Authority: `.claude/CONSTITUTION.md`.

## Pure Domain & Clean Architecture (Constitution §1)

- **Any `package:flutter`, `dio`, `http`, `hive`, `drift`, `flutter_secure_storage`, `MethodChannel`, or sensor/camera package imported inside `lib/features/*/domain/**`** → **CRITICAL** (domain must remain pure Dart).
- **Widget/page calling a repository, network client, database, or platform channel directly instead of going through `Cubit/Bloc → UseCase`** → **HIGH**.
- **`emit()` after `close()`** / missing `isClosed` guard in async Cubit/Bloc callbacks → **HIGH**.
- **Mutating state or entities in place** instead of returning new immutable copies (`freezed` / `copyWith`) → **HIGH**.

## Secrets, BYOK & Privacy (Constitution §3)

- **Hardcoded Gemini API key, token, keystore password, or `.env*` file committed or removed from `.gitignore`** → **CRITICAL** (compromised secret requires immediate rotation and git history purge).
- **Gemini API key stored in `SharedPreferences`, `Hive`, `Drift`, or plaintext logs instead of `FlutterSecureStorage`** → **CRITICAL**.
- **Captured challenge photo written to disk, gallery, cache directory, or external storage instead of remaining strictly in RAM and purged `< 500ms`** → **CRITICAL**.
- **Missing explicit onboarding consent before sending images to Gemini free tier** → **HIGH**.
- **Disabling TLS verification (`badCertificateCallback` returning `true`) or cleartext `http://` traffic in release** → **CRITICAL**.

## Platform Contract (`v1.0`, Constitution §2)

- **Android `minSdk < 29` or `targetSdk < 35`** without explicit ADR approval → **HIGH**.
- **Alarm scheduling missing `LOCKED_BOOT_COMPLETED` / `deviceProtectedStorage` Direct Boot support or starting `mediaPlayback` FGS directly from `BOOT_COMPLETED` (Android 15 violation)** → **HIGH**.
- **iOS deployment target < 26.0 or reintroducing the 64-notification fallback into `v1.0` without approval** → **HIGH**.
- **Unjustified permission added to `AndroidManifest.xml` or `Info.plist`** → **MEDIUM** (or **HIGH** if sensitive data access is unused).

## i18n & RTL (Constitution §4)

- **Hardcoded user-visible string in `Text`, `hintText`, `label`, `SnackBar`, `AppBar`, dialog, tooltip, or error message instead of `AppLocalizations` (`.arb`)** → **HIGH**.
- **`.arb` key added to `en` without `ar` (or vice versa), or `flutter gen-l10n` outputs stale** → **HIGH**.
- **Direction-unsafe layout (`EdgeInsets.only(left:/right:)`, `Alignment.centerLeft`, `TextAlign.left`) instead of directional equivalents** → **HIGH**.

## Testing, Codegen & Static Checks (Constitution §5)

- **New UseCase, Repository, DataSource, or Cubit/Bloc without unit/bloc tests, or coverage below 80%** → **HIGH**.
- **Test hitting real Gemini API or real hardware sensors/camera instead of faking/mocking at datasource boundaries** → **HIGH**.
- **`freezed` / `json_serializable` model modified without regenerating `.freezed.dart` / `.g.dart` (`dart run build_runner build --delete-conflicting-outputs`)** → **HIGH**.
- **Any `dart analyze --fatal-infos` error/warning/info or `dart format` drift** → **HIGH** / **LOW**.

## Git & Proof-of-Execution (Constitution §6–7)

- **Any commit pushed directly to `main`** → **CRITICAL**.
- **Claiming completion without real `[STDOUT]`** → **CRITICAL**.
