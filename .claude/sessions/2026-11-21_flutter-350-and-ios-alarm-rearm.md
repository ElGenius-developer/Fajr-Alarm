### Topic
Investigated the iOS alarm that went silent after Stop on a locked phone, and reviewed the Flutter code and architecture. Upgraded to Flutter 3.50.1, freed the full disk, then fixed and device-tested the AlarmKit re-arm. Merged PR #17 (`30fc114`) and PR #18 (`dd2d2d5`).

### Context
- iOS native alarm: `ios/Runner/AlarmKitManager.swift`, `ios/RunnerTests/RunnerTests.swift`
- Reschedule path that wiped the cascade: `lib/core/router/app_router.dart:71` → `load_prayer_schedule_usecase.dart:80` → `prayer_schedule_repository_impl.dart:113` → native `scheduleAlarmCascade`
- Toolchain: `pubspec.yaml`, `analysis_options.yaml`, `lib/core/l10n/app_localization_delegates.dart`, `android/settings.gradle.kts`, `android/app/build.gradle.kts`

### What WORKED (with evidence)
- **Flutter 3.50.1 + Shorebird 1.6.146 (bundles Flutter 3.50.1)** — confirmed by: `flutter --version`, `shorebird flutter versions list` → `✓ 3.50.1`.
- **Build green after the material_ui migration** — confirmed by: `dart analyze --fatal-infos` → `No issues found!`, `flutter test` → `+250: All tests passed!`, `flutter build apk --release --obfuscate` → 72.3MB, `flutter build ios --release --no-codesign` → 21.7MB.
- **iOS Stop re-arm on a locked phone** — confirmed by: Ahmed on iPhone 16 Pro Max (iOS 27.2.1). Slide to stop rings again after ~1 min. Open Challenge keeps ringing and asks for the passcode. Open Challenge with the passcode cancelled after 15 min rings again.
- **FajrCascadePolicy unit tests** — confirmed by: `xcodebuild test ... -only-testing:RunnerTests` on the iOS 26.5 simulator → 7 test cases passed, `TEST SUCCEEDED`.
- **Signed device install** — confirmed by: `xcodebuild ... DEVELOPMENT_TEAM=J52H7284YY` → `BUILD SUCCEEDED`; `xcrun devicectl device install/launch` → `Launched application`.
- **Disk recovered from 2.1GB free to ~188GB** — confirmed by: `df` and the macOS Storage pane.

### Problems & Solutions
- **Problem:** The iOS alarm stops and never rings again after Stop while the phone is locked (Face ID fails because the user is asleep).
  - **Root cause:**
    1. Opening the app loads the schedule page, which computes the next Fajr. Once T0 has passed, that is tomorrow. It calls `scheduleAlarm`, and native `scheduleAlarmCascade` called `cancelStoredCascade()` first. That wiped the remaining 11 alarms of today's cascade.
    2. `stopIntent` was `OpenFajrChallengeIntent` (`.foreground(.immediate)`), which needs an unlock before it runs.
  - **Attempts:**
    - First fix (`8120b5e`) — **outcome:** worked on the device. Records are stored with `cascadeStart`, and only cascades that have not started are replaced. Stop now runs the background `RearmFajrAlarmIntent`.
    - Independent opus review found 2 HIGH issues: the dry-run flag was read from the global key, and Open Challenge did not re-arm. It also found 1 MEDIUM re-arm race. **Fixed in `4193469`:**
      - `ringingIsDryRun` picks the flag of the cascade that is ringing.
      - `OpenFajrChallengeIntent` uses `supportedModes [.background, .foreground(.dynamic)]`: it re-arms, then calls `continueInForeground`.
      - `@MainActor` plus a cancel-generation check after the await.
  - **Final solution:** `ios/Runner/AlarmKitManager.swift` merged in `dd2d2d5`.
- **Problem:** `dart analyze` on Flutter 3.50.0 reported 43 errors and 72 issues.
  - **Root cause:** a stale package resolution plus the deprecation of `package:flutter/material.dart` (it moved to `package:material_ui`).
  - **Attempts:**
    - `flutter upgrade` to 3.50.1 + `pub get` — **outcome:** the errors were gone, 29 deprecation infos remained.
    - sed-replace the imports with `package:material_ui/material_ui.dart` — **outcome:** analyze was clean, but every Arabic widget test failed with `No MaterialLocalizations found`.
  - **Final solution:** gen-l10n still emits the `flutter_localizations` delegate types, and `material_ui` widgets cannot find them. Added `appLocalizationsDelegates` (with material_ui `GlobalMaterialLocalizations` and cupertino_ui `GlobalCupertinoLocalizations`), used by `main.dart` and the tests. Excluded `lib/core/l10n/generated/**` from analysis.
- **Problem:** The Android release build failed twice.
  - **Root cause:** AGP 9.1.0 was below Flutter's minimum of 9.1.1. Then 10 AAR metadata errors: the plugins require `compileSdk 36`.
  - **Final solution:** AGP 9.1.1 in `android/settings.gradle.kts`, `compileSdk = 36` in `android/app/build.gradle.kts`. `targetSdk` stays 35.
- **Problem:** Disk full (`No space left on device`). Every Bash call failed and Docker hung.
  - **Attempts:**
    - Bulk `rm -rf` from Claude — **outcome:** denied. The global `~/.claude/settings.json` has the deny rule `Bash(rm -rf:*)`.
    - Wrote a scratchpad script for Ahmed to run himself — **outcome:** worked for the caches. It hung at `docker info` because Docker was wedged by the full disk.
    - `kill` on the hung `docker info` — **outcome:** denied by the auto-mode classifier. Ahmed force-quit Docker himself.
    - Tool-native cleanup from Claude — **outcome:** worked:
      - `flutter clean` in 13 Flutter projects: ~19GB
      - `cargo clean` in `~/Documents/GitHub/warp`: 23.2GB
      - `docker system prune -a`: 22GB
      - `docker volume rm` of 2 approved volumes: 18GB
    - Ahmed deleted the iPhone backups (iOS Files, 31GB) from Finder. Claude cannot read `MobileSync` without Full Disk Access.
- **Problem:** Device install failed with `The developer disk image could not be mounted on this device`.
  - **Root cause:** `iOS DeviceSupport` was deleted with the caches, and the iPhone was connected wirelessly.
  - **Final solution:** Ahmed connected the iPhone by USB cable, and Xcode prepared the device. The install then succeeded.

### Decisions Made
- **A reschedule never cancels an iOS cascade that has already started.** Only `cancelAllAlarms` ends it, and that runs on completion, emergency override, disable and vacation. — reason: opening the app always recomputes "next Fajr" as tomorrow.
- **Both AlarmKit buttons re-arm in the background without an unlock.** The re-arm is +60s, and only when none of our alarms rings within 120s. The alarm is therefore relentless past the 15-minute cascade. — reason: the system Stop button always silences the alert, and AlarmKit offers no way to block it.
- **Use `appLocalizationsDelegates`, never `AppLocalizations.localizationsDelegates`.** — reason: the generated list carries delegate types that `material_ui` cannot find.
- **compileSdk 36 is fine. targetSdk stays 35 per the Constitution.** — reason: the plugins require compile 36; the Constitution only constrains targetSdk.
- **Device signing uses the personal Apple account's Personal Team `J52H7284YY`, not the work (DYNAMICS LINK) account.** It is passed on the xcodebuild CLI and never committed. — reason: Ahmed asked for the personal email.

### Files Touched
- `ios/Runner/AlarmKitManager.swift` — cascade records, re-arm intents, dry-run flag, race fence (#18)
- `ios/RunnerTests/RunnerTests.swift` — 7 FajrCascadePolicy tests (#18)
- `lib/core/l10n/app_localization_delegates.dart` — new shared delegates list (#17)
- `lib/main.dart`, 30 `lib/`/`test/` files — material_ui imports (#17)
- `pubspec.yaml`/`pubspec.lock` — material_ui and cupertino_ui direct dependencies (#17)
- `analysis_options.yaml` — exclude the gen-l10n output (#17)
- `android/settings.gradle.kts`, `android/app/build.gradle.kts` — AGP 9.1.1, compileSdk 36 (#17)
- `.gitignore` — `/android/build/` (#17)
- `.claude/PRPs/reviews/pr-17-review.md`, `pr-18-review.md` — review reports
- `.claude/memory.md` — Flutter 3.50.1 and iOS re-arm facts

### Open Questions / Blockers
- **Unknown:** whether the app's own `AlarmManager.stop(id:)` (in-app, while the challenge is open) fires the Stop intent. If it does, an alarm is re-armed every minute during the challenge. This is bounded, because completion clears the records. Watch for rings while doing the challenge.
- **Android defects from the code review, not fixed yet:**
  - Snooze relies only on a Dart `Timer`. A Doze freeze or process death means silence (`snooze_alarm_usecase.dart:25`, `AlarmForegroundService.kt:108-127`).
  - Snooze resets on relaunch, because the bloc starts with `snoozeUsed: false`.
  - Real and dry-run alarms share request code 1001 (`AlarmReceiver.kt`).
  - Completion ignores the reschedule failure (`app_router.dart:200-202`).
  - The emergency quota is checked after the alarm stops.
  - Lock-window clock tamper: the monotonic path is dead.
- **Code smells:**
  - `prayer_schedule_page.dart` is 1266 lines.
  - 5 dead `AlarmRingingBloc` events.
  - English `Failure.message` strings reach the UI.
- **No CI and no pinned Flutter SDK (`.fvmrc`).** That is why the SDK drift went unnoticed.
- **The Personal Team signature expires after 7 days.** The app must be reinstalled after that.

### Exact Next Step
Fix the Android snooze: re-arm natively (`setAlarmClock` at now+5m) when snooze stops the foreground service, and persist `snoozeUsed` so a relaunch cannot reset it. Start from `lib/features/alarm_ringing/domain/usecases/snooze_alarm_usecase.dart` and `android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/AlarmForegroundService.kt`.
