# Session Digest

<!-- Auto-generated search index for session-rag agent. -->
<!-- Do not edit manually. Rebuilt via /rebuild-digest. -->
<!-- Updated automatically by /save-session (Step 2.5). -->

## 2026-11-21 | flutter-350-and-ios-alarm-rearm
keywords: 30fc114, dd2d2d5, ios/Runner/AlarmKitManager.swift, ios/RunnerTests/RunnerTests.swift, lib/core/router/app_router.dart:71, load_prayer_schedule_usecase.dart:80, prayer_schedule_repository_impl.dart:113, scheduleAlarmCascade, pubspec.yaml, analysis_options.yaml, lib/core/l10n/app_localization_delegates.dart, android/settings.gradle.kts, android/app/build.gradle.kts, lib/main.dart, lib
decisions: A reschedule never cancels an iOS cascade that has already started. Only `cancelAllAlarms` ends it, and that runs on completion, emergency override, disable and vacation. — reason: opening the app always recomputes "next Fajr" as tomorrow. | Both AlarmKit buttons re-arm in the background without an unlock. The re-arm is +60s, and only when none of our alarms rings within 120s. The alarm is therefore relentless past the 15-minute cascade. — reason: the system Stop button always silences the alert, and AlarmKit offers no way to block it. | Use `appLocalizationsDelegates`, never `AppLocalizations.localizationsDelegates`. — the generated list carries delegate types that `material_ui` cannot find. | compileSdk 36 is fine. targetSdk stays 35 per the Constitution. — the plugins require compile 36; the Constitution only constrains targetSdk. | Device signing uses the personal Apple account's Personal Team `J52H7284YY`, not the work (DYNAMICS LINK) account. It is passed on the xcodebuild CLI and never committed. — reason: Ahmed asked for the personal email.
files: AlarmKitManager.swift, RunnerTests.swift, app_localization_delegates.dart, main.dart, pubspec.yaml, analysis_options.yaml, settings.gradle.kts, .gitignore
status: in-progress
---

## 2026-11-21 | android-snooze-native-rearm
keywords: lib/features/alarm_ringing/domain/usecases/snooze_alarm_usecase.dart, alarm_ringing_bloc.dart, alarm_ringing_event.dart, alarm_platform, lib/main.dart, lib/core/router/app_router.dart, android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/{AlarmReceiver,AlarmStorage,DirectBootReceiver,MainActivity}.kt, ios/Runner/AlarmKitManager.swift, scheduleSnoozeAlarm, lib/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart, data/repositories/alarm_platform_repository_impl.dart, data/datasources/alarm_platform_data_source.dart, snoozeUsed, lib/features/alarm_ringing/presentation/bloc/alarm_ringing_event.dart, android/.../AlarmReceiver.kt
decisions: The snooze alarm uses its own request code, 1003, separate from the next-Fajr alarm (1001). — rescheduling tomorrow (for example when the schedule page reloads) must not r... | Arm before stop. — a ringing alarm the user can still silence is safer than a silent one that de... | iOS `scheduleSnoozeAlarm` is a no-op. — the AlarmKit cascade already rings at T0+5m whether or not the app is alive.
files: snooze_alarm_usecase.dart, alarm_platform_repository.dart, alarm_ringing_event.dart, main.dart, AlarmReceiver.kt, AlarmStorage.kt, DirectBootReceiver.kt, MainActivity.kt
status: in-progress
---

## 2026-11-20 | onboard-floorplan-readme-and-main-ruleset
keywords: fajr-alarm-context, main, my-flutter-expert/SKILL.md, docs/TOPIC_INDEX.md, docs/SYMBOLS.json, claude/skills/fajr-alarm-context, graphify-out, git/hooks/post-commit, floorplan, docs/architecture-map.html, README.md, docs/screenshots, ElGenius-developer/Fajr-Alarm, refs/heads/main, agents/skills/my-flutter-expert/SKILL.md
decisions: Use GitHub Ruleset with `bypass_mode: "pull_request"` for `RepositoryRole` Admin (`5`) — blocks direct `git push` to `main` even for the owner, requires PR + 1 approv... | Export `docs/architecture-map.html` alongside gitignored `floorplan/` — `floorplan/` stays local/untracked by default, while `docs/architecture-map.h... | Exclude `.claude/`, `.agents/`, `/.freezed.dart`, `/.g.dart` in `floorplan/architecture.json` — reason: keeps the interactive Floorplan focused on the 142 actual app and test source files.
files: .gitignore, TOPIC_INDEX.md, SKILL.md, architecture-map.html, README.md
status: in-progress
---

## 2026-11-15 | llm-critic-trap-and-spec-drift-gate
keywords: a5fb694, CLAUDE.md, AGENTS.md, claude/CONSTITUTION.md, claude/settings.json, claude/hooks/*.sh, fajr-app-pr-guard, claude/skills/pr-guard, clean-code-guard, GLOSSARY.md, claude/memory.md, docs/SRS-Fajr-alarm.md, docs/agents/domain.md, constitution-gates.md, claude
decisions: Main anti-loop mechanisms are kept as they are: (1) the architecture is fixed by the Constitution, so layer and interface debates stay closed; (2) a finding blocks only if it has a concrete failure scenario, and only CRITICAL/HIGH block; (3) the Sleepy-Self threat model and the SRS Out-of-Scope table bound security and feature scope. — reason: these are what prevent over-engineering vs YAGNI oscillation; weakening any reopens the loop. | Spec Drift gate added to `constitution-gates.md`: changing a value that the SRS or `memory.md` documents without updating that doc in the same PR is HIGH. When existing code contradicts the SRS, the reviewer checks `DIGEST.md` first. A recorded decision means the doc is stale (MEDIUM, fix the doc). No recorded decision means ask Ahmed. The code is never reverted on the reviewer's own call. — reason: decisions made during device testing were landing only in session logs, so a reviewer reading the SRS would "fix" correct code back to a broken value. | No `docs/adr/` yet — `DIGEST.md` already carries decisions; create ADRs lazily when a real archite...
files: SRS-Fajr-alarm.md, memory.md, constitution-gates.md, pr-15-review.md, 2026-11-15_llm-critic-trap-and-spec-drift-gate.md
status: in-progress
---

## 2026-11-15 | alarmkit-tilt-settings-and-pr14-merge
keywords: 15.0°, 25.0, d3f4c9e, main, ios/Runner/AlarmKitManager.swift, FajrOpenChallengeIntent, alarmUpdates, lib/features/challenge_verification, tilt_angle_reading.dart, tilt_sensor_datasource.dart, verify_standing_typing_usecase.dart, challenge_page.dart, challenge_cubit.dart, lib/features/settings_and_streak, settings_page.dart, settings_extended_cards.dart
decisions: Standing tilt pitch range changed to `[-15.0°, 25.0°]` — `[45°, 90°]` prevented users from aiming the phone downward toward their feet... | No `DEVELOPMENT_TEAM` in `project.pbxproj` — pass `DEVELOPMENT_TEAM=J52H7284YY CODE_SIGN_STYLE=Automatic` exclusively on `... | Shared `BarcodeScannerInput` & `location_method_helpers.dart` — eliminate duplication between Onboarding/Schedule and the extended Settings s...
files: AlarmKitManager.swift, barcode_scanner_input.dart, location_method_helpers.dart
status: in-progress
---

## 2026-11-14 | v1-build-themes-and-stitch-mcp
keywords: feat/fajr-alarm-v1, 2b2bf12, lib/main.dart, lib/core/theme/app_theme.dart, lib/core/theme/appearance_sheet.dart, lib/core/l10n/app_{ar,en}.arb, lib/features/prayer_schedule/data/repositories/prayer_schedule_repository_impl.dart, lib/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart, lib/features/settings_and_streak/domain/entities/user_settings.dart, data/datasources/settings_local_data_source.dart, presentation/cubit/settings_cubit.dart, presentation/pages/settings_page.dart, gemini/antigravity/mcp_config.json, gemini/config/mcp_config.json, AppDesignStyle
decisions: 7 selectable `AppDesignStyle` presets + `ThemeMode` persisted in `UserSettings` (`Hive` backward-compatible `reader.availableBytes > 0`) — lets user preview and choose a flagship design direction live without breakin... | Streamable HTTP (`serverUrl` + `X-Goog-Api-Key`) for Google Stitch MCP — `gcloud` is not installed on this machine, and `browser-use` confirmed Antigr...
files: app_theme.dart, appearance_sheet.dart, app_en.arb, prayer_schedule_repository_impl.dart, prayer_schedule_page.dart, user_settings.dart, settings_local_data_source.dart, settings_cubit.dart
status: in-progress
---

## 2026-11-14 | ui-polish-quiet-dawn-icon-and-device-deploy
keywords: PR #12, 55a2130, J52H7284YY, main, lib/features/onboarding/presentation/widgets/barcode_step_view.dart, onboarding_page.dart, MobileScanner, scannerBuilder, lib/core/theme/app_theme.dart, lib/main.dart, buildTextTheme(..., isArabic, Avenir Next, SegmentedButtonTheme, lib/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart, SegmentedButton
decisions: Build standalone `Release` instead of `--debug` for user phone testing — lets Ahmed reopen the app on-device away from the workstation without iOS ter... | Pass `DEVELOPMENT_TEAM=J52H7284YY` on the `xcodebuild` CLI rather than committing to `project.pbxproj` — keeps personal developer team IDs out of open-source tracked files. | Defer "Open Google AI Studio" button (`https://aistudio.google.com/apikey`) in Step 3 (`PrivacyKeyStepView`) to the next version — Ahmed opted to obtain/paste his key manually during live v1.0 device testing ...
files: 2026-11-14_ui-polish-quiet-dawn-icon-and-device-deploy.md, INDEX.md, TRACKER.md
status: in-progress
---

## 2026-11-14 | qa-fixes-argon-approve-and-merge
keywords: feat/fajr-alarm-v1, main, Users/ahmed/Documents/GitHub/athkari, tutorial_coach_mark: ^1.2.11, WalkthroughService, android/app/src/main/AndroidManifest.xml, SCHEDULE_EXACT_ALARM, maxSdkVersion="32, android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/AlarmForegroundService.kt, currentIsDryRun, android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/MainActivity.kt, onCreate, onNewIntent, consumePendingAlarmTrigger, ios/Runner/AlarmKitManager.swift
decisions: Native Alarm Trigger Bridge (`consumePendingAlarmTrigger` + `onAlarmTriggered`) — supports both cold launches (`onCreate` / `OpenFajrChallengeIntent` buffered ... | Keep `dryRunScheduledAt` persistent across SnackBar dismiss — tracked transient feedback via `dryRunJustScheduled` / `dryRunCancelled` flag... | Defer Phase B Walkthrough (`tutorial_coach_mark`) to post-merge branch + explicit user approval — honors Constitution/Non-Negotiable rules (separate PR after `main` merge, exp...
files: AndroidManifest.xml, AlarmForegroundService.kt, MainActivity.kt, AlarmKitManager.swift, injection.dart, app_en.arb, app_router.dart, pr-11-review.md
status: in-progress
---

## 2026-11-13 | wayfinder-srs-and-repo-onboarding
keywords: wayfinder, save-session, ElGenius-developer/Fajr-Alarm, SRS-Fajr-alarm.md, claude, agents, CLAUDE.md, AGENTS.md, GEMINI.md, docs/agents, main, claude/CONSTITUTION.md, claude/rules/common, claude/rules/dart, claude/skills
decisions: Personal-use + Open Source without secrets — removes Play/App Store review blockers for sideloaded Android permissions whi... | v1.0 target platforms: Android 10+ (`minSdk 29`, `targetSdk 35`) + iOS 26+ (`AlarmKit`) — owner's personal iPhone runs iOS 27; `iOS 15–25` 64-notification best-effort ... | Android Direct Boot & Onboarding Permission Gate — `LOCKED_BOOT_COMPLETED` + `deviceProtectedStorage` ensures alarms survive ove... | Relentless AlarmKit Cascade on iOS 26+ — Apple's `AlarmKit` Lock Screen UI includes an unhideable OS `Stop` button; pr... | Feature-Based Clean Architecture + local cache — pure-Dart `domain/`, `flutter_bloc`, `get_it`, `freezed`, `fpdart`, and local...
files: SRS-Fajr-alarm.md, CONSTITUTION.md, CLAUDE.md, memory.md, {issue-tracker,triage-labels,domain}.md
status: in-progress
---

## 2026-11-13 | threat-model-and-emergency-policy
keywords: GLOSSARY.md, agy remote-control, claude/memory.md, claude/sessions/2026-11-13_threat-model-and-emergency-policy.md, claude/sessions/INDEX.md, claude/sessions/DIGEST.md, memory.md, 2026-11-13_threat-model-and-emergency-policy.md, INDEX.md, DIGEST.md, GitHub, 13_threat, Anti-Cheating, remote-control, 2026-11-13_threat-model-and-emergency-policy
decisions: Sleepy-Self Threat Model (`#6`) — personal-use open-source app only needs to defeat quick in-bed cheats by the ... | Offline Fallback Hierarchy (`#6` — `FR-4.2`) — Bathroom Barcode Scan is the primary offline challenge to force physical loco... | Pragmatic POV Verification (`#6` — `FR-03` / `FR-04`) — live camera stream + standing tilt check (`-45°` to `-90°`) + balanced Gemini... | Monotonic Clock & 30-Minute Pre-Fajr Lock Window (`#6` — `FR-5.4`) — monotonic clock prevents wall-clock tampering during ringing/snooze, and lock... | Touch-Mute + 60s Continuous Hold Emergency Override (`#7` — `FR-6.2`) — muting audio immediately while the finger is held down makes real emergencies... | Bounded Vacation Mode with Streak Freeze (`#7` — `FR-6.1`) — requiring an explicit number of days upfront (editable outside `T - 30m`), fr...
files: GLOSSARY.md, memory.md, 2026-11-13_threat-model-and-emergency-policy.md, INDEX.md
status: in-progress
---

## 2026-11-13 | architecture-testing-and-srs-lock
keywords: SRS-Fajr-alarm.md, GLOSSARY.md, claude/memory.md, Dry-Run Alarm, claude/sessions/2026-11-13_architecture-testing-and-srs-lock.md, claude/sessions/INDEX.md, claude/sessions/DIGEST.md, memory.md, 2026-11-13_architecture-testing-and-srs-lock.md, INDEX.md, DIGEST.md, 13_architecture, SRS-Fajr-alarm, Dry-Run, 2026-11-13_architecture-testing-and-srs-lock
decisions: 5 Feature Modules under `lib/features/` (`#8`) — clean separation of concerns across `onboarding`, `prayer_schedule`, `alarm_r... | Three-Tier Local Persistence with `hive_ce` (`#8`) — `FlutterSecureStorage` for BYOK Gemini API key, Android `deviceProtectedStora... | Strict Native Channel Isolation (`#8`) — keeping `domain/` 100% OS-agnostic pure Dart and isolating all Android/iOS ch... | Automated Testing + 10-Second Dry-Run Test Alarm (`#9`) — `mocktail` + `bloc_test` + `fake_async` + `setMockMethodCallHandler` cover 80... | 4-Step Onboarding, Full `ar`/`en` `.arb` Localization & Local-Only KPIs (`#9`) — completes all remaining `Not yet specified` items on Map `#1` while preservin...
files: SRS-Fajr-alarm.md, GLOSSARY.md, memory.md, 2026-11-13_architecture-testing-and-srs-lock.md, INDEX.md
status: complete
---

