### Topic
Fixed iOS 26+ AlarmKit ringing handoff and audio session, adjusted standing tilt range to `[-15.0°, 25.0°]`, completed all missing Settings controls (including Bathroom Barcode, Location/Method/Timing, Gemini API Key, Permissions, and early Vacation deactivation), hardened Challenge camera handoff & 400/401 fallback, deployed Release to iPhone 16 Pro Max, and merged PR #14 (`d3f4c9e`) into `main`.

### Context
- `ios/Runner/AlarmKitManager.swift`: AlarmKit alert presentation, `FajrOpenChallengeIntent`, `alarmUpdates` observation, playback audio session.
- `lib/features/challenge_verification/`: Standing tilt range (`tilt_angle_reading.dart`, `tilt_sensor_datasource.dart`, `verify_standing_typing_usecase.dart`), camera disposal before barcode fallback (`challenge_page.dart`), and `400`/`401` Gemini offline fallback (`challenge_cubit.dart`).
- `lib/features/settings_and_streak/` & shared widgets: Full Settings UI (`settings_page.dart`, `settings_extended_cards.dart`, `settings_sheets.dart`, `settings_cubit.dart`, `update_settings_usecase.dart`, `barcode_scanner_input.dart`, `location_method_helpers.dart`), ARB localizations (`app_en.arb`, `app_ar.arb`), DI (`injection.dart`), and schedule reload on Settings pop (`app_router.dart`).

### What WORKED (with evidence)
- **Full static & test verification** — confirmed by: `dart format --output=none --set-exit-if-changed .` (0 changed), `dart analyze --fatal-infos` (`No issues found!`), and `flutter test --no-pub --coverage` (`250/250` tests passed).
- **Clean Architecture layer coverage >= 80%** — confirmed by: `coverage/lcov.info` (`domain`: 91.0% 384/422, `data/repositories`: 87.2% 225/258, `presentation/bloc|cubit`: 81.2% 524/645, `settings_and_streak`: 84.5% 1114/1319).
- **Wireless signed Release build & device launch** — confirmed by: `flutter build ios --release --no-codesign`, `xcodebuild ... DEVELOPMENT_TEAM=J52H7284YY CODE_SIGN_STYLE=Automatic` (`** BUILD SUCCEEDED **`, `git diff --stat ios/Runner.xcodeproj/project.pbxproj` empty), `codesign --verify --deep --strict` (exit 0), and `xcrun devicectl device install app` + `xcrun devicectl device process launch` on `B8E65ED4-0C27-584F-9A63-5E37FFE7CBBB` (`com.elgenius.fajralarm.fajrAlarm`).
- **PR #14 commit, review, and merge** — confirmed by: commit `ce94734` on `fix/ios-alarmkit-ringing-flow`, PR `https://github.com/ElGenius-developer/Fajr-Alarm/pull/14` reviewed (`VERDICT: APPROVED`) and merged into `main` (`d3f4c9e`), local/remote branch deleted, untracked `spec/` preserved.

### Problems & Solutions
- **Problem:** Save button in `_LocationMethodSheet` was scrolled off-screen below the 7 calculation methods on an `800x600` test viewport (`Found 0 widgets with key <'settings_save_location_method_button'>`).
  - **Root cause:** The `FilledButton` was placed inside the `ListView` inside `DraggableScrollableSheet`.
  - **Final solution:** Moved the error text and Save `FilledButton` into a sticky bottom footer outside `Expanded(child: ListView(...))` in `lib/features/settings_and_streak/presentation/widgets/settings_sheets.dart`.
- **Problem:** `deactivateVacationMode` tests failed with `type 'Null' is not a subtype of type 'Future<Either<Failure, StreakStats>>'`.
  - **Root cause:** `AutoResumeVacationUseCase` calls `repository.saveStreakStats(any())` to unfreeze the streak, which wasn't stubbed in the new Mocktail tests.
  - **Final solution:** Stubbed `when(() => repository.saveStreakStats(any()))` in `test/features/settings_and_streak/presentation/settings_cubit_and_page_test.dart`.
- **Problem:** Potential `AVCaptureSession` contention on iOS when falling back from `PhotoVision` to `BathroomBarcode` in `ChallengePage`, and missing fallback on Gemini `400`/`401` errors.
  - **Root cause:** `_cameraController` stayed alive until `ChallengePage.dispose()`, and `_shouldTriggerOfflineFallback` only handled `403`/`429`/`>=500`.
  - **Final solution:** Added `_disposePhotoCamera` in `ChallengePage` listener on mode change + `_BathroomBarcodeViewState.dispose()`, and added `400`/`401` to `_shouldTriggerOfflineFallback` in `ChallengeCubit`.

### Decisions Made
- **Standing tilt pitch range changed to `[-15.0°, 25.0°]`** — reason: `[45°, 90°]` prevented users from aiming the phone downward toward their feet on the prayer rug during POV capture.
- **No `DEVELOPMENT_TEAM` in `project.pbxproj`** — reason: pass `DEVELOPMENT_TEAM=J52H7284YY CODE_SIGN_STYLE=Automatic` exclusively on `xcodebuild` CLI to keep the open-source repo clean.
- **Shared `BarcodeScannerInput` & `location_method_helpers.dart`** — reason: eliminate duplication between Onboarding/Schedule and the extended Settings screens.

### Files Touched
- `ios/Runner/AlarmKitManager.swift`: Added `FajrOpenChallengeIntent`, alert presentation wiring, `alarmUpdates` listener, and playback audio session handling.
- `lib/core/widgets/barcode_scanner_input.dart` & `lib/features/onboarding/presentation/widgets/barcode_step_view.dart`: Extracted shared camera/manual barcode widget.
- `lib/features/prayer_schedule/presentation/widgets/location_method_helpers.dart` & `prayer_schedule_page.dart`: Extracted shared city presets and calculation method localization helpers.
- `lib/features/settings_and_streak/`: Added `settings_extended_cards.dart`, `settings_sheets.dart`, updated `settings_page.dart`, `settings_cubit.dart`, and `update_settings_usecase.dart`.
- `lib/features/challenge_verification/`: Updated tilt range to `[-15.0°, 25.0°]`, added camera handoff disposal (`challenge_page.dart`), and added `400`/`401` fallback (`challenge_cubit.dart`).
- `lib/core/l10n/` (`app_en.arb`, `app_ar.arb`, generated), `lib/core/di/injection.dart`, `lib/core/router/app_router.dart`: Added localization keys, DI wiring, and schedule refresh on Settings pop.
- `test/features/settings_and_streak/` & `test/features/challenge_verification/`: Added/updated unit and widget tests (`250` total passing).

### Open Questions / Blockers
- Live interactive verification on physical `Ahmed's iphone` (camera/barcode scan in Settings and live scheduled AlarmKit wake flow) awaits user testing on the installed Release build.

### Exact Next Step
Run a live 2-minute AlarmKit test and test the new Settings controls (Bathroom Barcode scan/clear, Location/Method, Gemini Key) on `Ahmed's iphone`, then decide whether to commit or archive `spec/ios-alarmkit-ringing-fix.md`.
