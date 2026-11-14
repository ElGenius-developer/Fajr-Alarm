### Topic
Resolved Hydrogen QA findings & Argon review defects across PR #11 (`feat/fajr-alarm-v1` -> `main`), passed native Android/iOS builds + 234 tests, and prepared merge.

### Context
- PR #11 (`feat/fajr-alarm-v1` -> `main`): native alarm-to-Flutter trigger bridge, post-challenge/emergency finalization, Pre-Fajr Lock Window wiring in Settings, dry-run cancellation, schedule UI pickers, onboarding error mapping, stream error handling, and unit/widget test suite.
- Inspected `/Users/ahmed/Documents/GitHub/athkari` (`tutorial_coach_mark: ^1.2.11` + `WalkthroughService` Hive flags) for upcoming Phase B walkthrough feature.

### What WORKED (with evidence)
- **Full test suite & coverage gates** — confirmed by: `flutter test --no-pub --coverage` exited `0` (`00:47 +234: All tests passed!`); LCOV non-generated breakdown: `domain/` `383/421 (90.97%)`, `data/repositories/` `225/258 (87.21%)`, `presentation/bloc|cubit/` `419/515 (81.36%)`, overall `3188/4072 (78.29%)`.
- **Formatting & strict static analysis** — confirmed by: `dart format --output=none --set-exit-if-changed .` (`Formatted 142 files (0 changed)`) and `dart analyze --fatal-infos` (`No issues found!`).
- **Native builds & iOS simulator launch** — confirmed by: `cd android && ./gradlew compileDebugKotlin` (`BUILD SUCCESSFUL in 23s`), `flutter build ios --simulator --no-codesign` (`Built build/ios/iphonesimulator/Runner.app`), and `xcrun simctl launch` on `iPhone 17 Pro` (`com.elgenius.fajralarm.fajrAlarm: 26314`).
- **Hydrogen QA re-verification (`gemini-4-hydrogen-high`, read-only)** — confirmed by: `QA_VERDICT: PASS` with all 8 prior defects resolved, `195/195` EN/AR `.arb` key parity, `0` secrets, and `0` RTL issues.
- **Argon pre-merge review (`gemini-4-argon-high`, read-only)** — confirmed by: `VERDICT: APPROVE` on commit `c4034b4` (`0` CRITICAL, `0` HIGH, `0` MEDIUM findings; recorded in `.claude/PRPs/reviews/pr-11-review.md`).

### Problems & Solutions
- **Problem:** `test/widget_test.dart` hung indefinitely in `tearDown` on `Hive.close()`.
  - **Root cause:** Opening `OnboardingPage` dirtied `onboarding_state_box` inside `FakeAsync` without flushing before `Hive.close()`.
  - **Attempts:** Rewrote `test/widget_test.dart` with explicit `await tester.runAsync(() => Hive.box<OnboardingStateModel>('onboarding_state_box').flush());` in `tearDown` — **outcome:** worked (`11.80s` clean pass).
- **Problem:** `ChallengeVerificationRepositoryImpl.watchTiltAngle()` swallowed stream errors instead of emitting `Left(Failure)`.
  - **Root cause:** Called `Stream.handleError(...)` (which returns `void`) without transforming events.
  - **Final solution:** Replaced with `StreamTransformer<TiltAngleReading, Either<Failure, TiltAngleReading>>.fromHandlers(...)` (`lib/features/challenge_verification/data/repositories/challenge_verification_repository_impl.dart:78-105`).
- **Problem:** `CancelDryRunAlarm` widget tap in `settings_cubit_and_page_test.dart` failed hit-testing.
  - **Root cause:** Newly triggered `SnackBar` covered `settings_cancel_dry_run_button` near bottom of viewport.
  - **Final solution:** Advanced widget clock past SnackBar duration (`pump(const Duration(seconds: 5))`) and `ensureVisible` before tapping.
- **Problem:** `agy remote-control` appeared Offline in desktop UI.
  - **Root cause:** CLI auth token cleared (`has_token=false` in `cli-20261113_215039.log`), disconnecting WebChannel while local PID stayed alive.

### Decisions Made
- **Native Alarm Trigger Bridge (`consumePendingAlarmTrigger` + `onAlarmTriggered`)** — reason: supports both cold launches (`onCreate` / `OpenFajrChallengeIntent` buffered in `pendingTrigger`) and live singleTop/foreground intents (`onNewIntent` / `NotificationCenter`) without duplicate triggers.
- **Keep `dryRunScheduledAt` persistent across SnackBar dismiss** — reason: tracked transient feedback via `dryRunJustScheduled` / `dryRunCancelled` flags in `SettingsState` so `_DryRunCard` retains the Cancel button until cancelled or completed.
- **Defer Phase B Walkthrough (`tutorial_coach_mark`) to post-merge branch + explicit user approval** — reason: honors Constitution/Non-Negotiable rules (separate PR after `main` merge, explicit approval required for adding new `pubspec.yaml` dependency).

### Files Touched
- `android/app/src/main/AndroidManifest.xml` — added `SCHEDULE_EXACT_ALARM` (`maxSdkVersion="32"`).
- `android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/AlarmForegroundService.kt` — tracked `currentIsDryRun`.
- `android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/MainActivity.kt` — handled `onCreate`/`onNewIntent` alarm triggers and `consumePendingAlarmTrigger`.
- `ios/Runner/AlarmKitManager.swift`, `ios/Runner/AppDelegate.swift` — observed `com.elgenius.fajralarm.openChallenge`, added `consumePendingAlarmTrigger`, and opened iOS Settings when camera/AlarmKit is `.denied`.
- `lib/core/di/injection.dart` — wired `CancelDryRunAlarmUseCase`, `nextAlarmProvider`, and barcode/platform hooks.
- `lib/core/l10n/app_en.arb`, `lib/core/l10n/app_ar.arb` — added dry-run cancel strings.
- `lib/core/router/app_router.dart`, `lib/main.dart` — added native trigger listener, `/alarm-ringing?autoTrigger=true`, `finalizeChallengeCompletion`, and `finalizeEmergencyOverride`.
- `lib/features/alarm_ringing/*`, `lib/features/challenge_verification/*`, `lib/features/onboarding/*`, `lib/features/prayer_schedule/*`, `lib/features/settings_and_streak/*` — resolved all 8 QA findings and guarded async `emit`s with `isClosed`.
- `test/**` — added 36 new unit/widget/router tests bringing total to 234 passing tests.
- `.claude/PRPs/reviews/pr-11-review.md` — recorded Argon `VERDICT: APPROVE`.

### Open Questions / Blockers
- Approval for adding `tutorial_coach_mark` dependency in the Phase B walkthrough branch (modeled on `/Users/ahmed/Documents/GitHub/athkari`), followed by capturing full app + `/challenge` camera screen screenshots in `docs/screenshots/`.

### Exact Next Step
Create new branch from updated `main`, obtain user approval for `tutorial_coach_mark` + Phase B plan, implement step-by-step first-launch highlight walkthroughs across all screens, open `/challenge` camera screen, and capture all app screenshots into `docs/screenshots/`.
