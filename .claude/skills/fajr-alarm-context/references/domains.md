# Domains — fajr_alarm

Subsystems and sample queries:

- **Core Infrastructure (`lib/core/`):** DI (`get_it`), `Failure` union, `go_router`, theme, l10n (`ar`/`en`), monotonic clock.
  - `graphify query "Failure injection AppRouter"`
- **Alarm Ringing (`lib/features/alarm_ringing/`):** Relentless alarm state machine, snooze/complete/emergency override.
  - `graphify query "AlarmRingingBloc AlarmPlatformRepository"`
- **Challenge Verification (`lib/features/challenge_verification/`):** Gemini Vision rug POV photo, tilt sensor, offline barcode & typing fallbacks.
  - `graphify query "ChallengeCubit VerifyPrayerRugPhotoUseCase"`
- **Prayer Schedule (`lib/features/prayer_schedule/`):** 30-day Fajr calculation, Hive caching, pre-Fajr lock window.
  - `graphify query "PrayerScheduleCubit Calculate30DayFajrScheduleUseCase"`
- **Onboarding (`lib/features/onboarding/`):** Permissions gate, location, BYOK Gemini key + privacy consent, barcode registration.
  - `graphify query "OnboardingCubit ValidateAndSaveGeminiKeyUseCase"`
- **Settings & Streak (`lib/features/settings_and_streak/`):** Settings, streak stats, vacation mode, dry-run alarm.
  - `graphify query "SettingsCubit ActivateVacationModeUseCase"`
- **Native Android (`android/app/src/main/kotlin/.../`):** `AlarmForegroundService`, `AlarmReceiver`, `DirectBootReceiver`, `AlarmStorage`, `MainActivity`.
  - `graphify query "AlarmForegroundService DirectBootReceiver"`
- **Native iOS (`ios/Runner/`):** `AlarmKitManager`, `AppDelegate`.
  - `graphify explain "AlarmKitManager.swift"`
