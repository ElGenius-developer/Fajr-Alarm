# God Nodes — fajr_alarm

Most-connected abstractions in `fajr_alarm` (ranked, no edge counts — see `graphify-out/GRAPH_REPORT.md` for live stats):

1. `AlarmRingingBloc` — `lib/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart` (alarm state machine)
2. `AlarmPlatformRepository` — `lib/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart` (native bridge contract)
3. `Failure` — `lib/core/error/failures.dart` (typed domain failure union across all use cases)
4. `PrayerScheduleRepository` — `lib/features/prayer_schedule/domain/repositories/prayer_schedule_repository.dart` (30-day astronomical schedule & lock window)
5. `ChallengeVerificationRepository` — `lib/features/challenge_verification/domain/repositories/challenge_verification_repository.dart` (Gemini Vision + offline fallbacks)
6. `SettingsAndStreakRepository` — `lib/features/settings_and_streak/domain/repositories/settings_and_streak_repository.dart` (user settings, streak, vacation mode)
7. `OnboardingRepository` — `lib/features/onboarding/domain/repositories/onboarding_repository.dart` (permissions, BYOK Gemini key, barcode setup)
8. `AlarmForegroundService` — `android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/AlarmForegroundService.kt` (Android foreground playback & lock)
9. `AlarmKitManager` — `ios/Runner/AlarmKitManager.swift` (iOS 26+ AlarmKit cascade)
