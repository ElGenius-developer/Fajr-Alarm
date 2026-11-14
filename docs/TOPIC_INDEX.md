# Topic Index — fajr_alarm

**Purpose:** Map domain concepts to anchor files so any agent (or human) finds the entry points in
one `Read`, without grepping or running graphify. This is **rung 1** of the search ladder.

**How to use:**
1. Find the topic that matches your question.
2. Read the anchor files listed under it — these are the entry points.
3. The `Grep:` patterns locate a domain; they are **not** usage scans. For "what calls X?" use the
   LSP (`findReferences`) — see the ladder in `CLAUDE.md`.
4. For deeper exploration, the topic links to its spec, ADR or session log.

**Update rule:** When adding a new domain, append to this file in the same commit. **Stale entries
are worse than missing entries** — an agent trusts rung 1, so a dead link sends it the wrong way.
Remove anything that no longer exists.

---

### core-infrastructure
DI container (`get_it`), error `Failure` union, `go_router`, theme, l10n (`ar`/`en`), monotonic clock.
- [injection.dart](../lib/core/di/injection.dart)
- [failures.dart](../lib/core/error/failures.dart)
- [app_router.dart](../lib/core/router/app_router.dart)
- [app_theme.dart](../lib/core/theme/app_theme.dart)
- [monotonic_clock.dart](../lib/core/time/monotonic_clock.dart)
- Grep: `class Failure|configureDependencies|AppRouter`

### alarm-ringing
Relentless alarm state machine, snooze/complete/emergency override, and platform channel bridge.
- [alarm_ringing_bloc.dart](../lib/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart)
- [alarm_platform_repository.dart](../lib/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart)
- [alarm_platform_data_source.dart](../lib/features/alarm_ringing/data/datasources/alarm_platform_data_source.dart)
- [alarm_ringing_page.dart](../lib/features/alarm_ringing/presentation/pages/alarm_ringing_page.dart)
- Grep: `AlarmRingingBloc|AlarmPlatformRepository|StartRelentlessRinging`

### challenge-verification
Proof-of-Action verification: Gemini Vision prayer-rug POV photo, tilt sensor, offline barcode & standing typing fallbacks.
- [challenge_cubit.dart](../lib/features/challenge_verification/presentation/cubit/challenge_cubit.dart)
- [gemini_vision_remote_datasource.dart](../lib/features/challenge_verification/data/datasources/gemini_vision_remote_datasource.dart)
- [tilt_sensor_datasource.dart](../lib/features/challenge_verification/data/datasources/tilt_sensor_datasource.dart)
- [verify_prayer_rug_photo_usecase.dart](../lib/features/challenge_verification/domain/usecases/verify_prayer_rug_photo_usecase.dart)
- Grep: `ChallengeCubit|GeminiVision|VerifyPrayerRugPhoto|TiltAngleReading`

### prayer-schedule
30-day astronomical Fajr calculation, local Hive caching, pre-Fajr lock window, and next-day rescheduling.
- [prayer_schedule_cubit.dart](../lib/features/prayer_schedule/presentation/bloc/prayer_schedule_cubit.dart)
- [calculate_30_day_fajr_schedule_usecase.dart](../lib/features/prayer_schedule/domain/usecases/calculate_30_day_fajr_schedule_usecase.dart)
- [prayer_schedule_repository_impl.dart](../lib/features/prayer_schedule/data/repositories/prayer_schedule_repository_impl.dart)
- [prayer_schedule_page.dart](../lib/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart)
- Grep: `PrayerScheduleCubit|Calculate30DayFajrSchedule|RescheduleTomorrowFajr`

### onboarding
First-run setup: permissions gate, location, BYOK Gemini key + free-tier privacy consent, bathroom barcode registration.
- [onboarding_cubit.dart](../lib/features/onboarding/presentation/bloc/onboarding_cubit.dart)
- [validate_and_save_gemini_key_usecase.dart](../lib/features/onboarding/domain/usecases/validate_and_save_gemini_key_usecase.dart)
- [onboarding_permissions_data_source.dart](../lib/features/onboarding/data/datasources/onboarding_permissions_data_source.dart)
- [onboarding_page.dart](../lib/features/onboarding/presentation/pages/onboarding_page.dart)
- Grep: `OnboardingCubit|ValidateAndSaveGeminiKey|CheckPermissionsGate`

### settings-and-streak
User settings, streak tracking, vacation mode, emergency quota, and dry-run alarm testing.
- [settings_cubit.dart](../lib/features/settings_and_streak/presentation/cubit/settings_cubit.dart)
- [settings_and_streak_repository_impl.dart](../lib/features/settings_and_streak/data/repositories/settings_and_streak_repository_impl.dart)
- [activate_vacation_mode_usecase.dart](../lib/features/settings_and_streak/domain/usecases/activate_vacation_mode_usecase.dart)
- [settings_page.dart](../lib/features/settings_and_streak/presentation/pages/settings_page.dart)
- Grep: `SettingsCubit|VacationMode|DryRunAlarm|StreakStats`

### native-android-alarm
Android 10+ exact alarm scheduling, `ForegroundService` (`mediaPlayback`), `DirectBootReceiver` (`deviceProtectedStorage`), `MainActivity` channel.
- [MainActivity.kt](../android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/MainActivity.kt)
- [AlarmForegroundService.kt](../android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/AlarmForegroundService.kt)
- [AlarmReceiver.kt](../android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/AlarmReceiver.kt)
- [DirectBootReceiver.kt](../android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/DirectBootReceiver.kt)
- [AlarmStorage.kt](../android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/AlarmStorage.kt)
- Grep: `AlarmForegroundService|DirectBootReceiver|AlarmStorage`

### native-ios-alarmkit
iOS 26+ `AlarmKit` Relentless Cascade & `LiveActivityIntent` Swift channel bridge.
- [AlarmKitManager.swift](../ios/Runner/AlarmKitManager.swift)
- [AppDelegate.swift](../ios/Runner/AppDelegate.swift)
- [ios-alarmkit-ringing-fix.md](../spec/ios-alarmkit-ringing-fix.md)
- Grep: `AlarmKitManager|AlarmKit`

### specs-and-governance
Canonical SRS, agent constitution, domain docs, and session memory.
- [SRS-Fajr-alarm.md](../docs/SRS-Fajr-alarm.md)
- [CONSTITUTION.md](../.claude/CONSTITUTION.md)
- [domain.md](../docs/agents/domain.md)
- [INDEX.md](../.claude/sessions/INDEX.md)

---

## Request / Data Flows

Answers "how does <screen / endpoint / job> get its data?" — the **read path only**, as one chain
per entry point, e.g. UI entry → the hook/controller that owns the fetch → client API function →
route → handler → service/repository/query → tables. Write paths are out of scope.

**Why this section exists:** these chains usually span 5–6 files and often two languages. Neither
grep nor the knowledge graph reconstructs them cheaply — the graph stores structural edges and
cannot say which query feeds which screen, and `graphify query` anchors on literal name tokens, so a
screen name returns a flat dump of neighbours rather than the chain.

**How to add one:** trace it once by hand (open each hop, confirm the call), then record it here
with the gotcha that bites at that hop. Never write a hop you did not open.

<!-- Template per flow:
### <entry-point>-data-flow
<one line: what the user sees>
- Entry: [path](../path)
- Fetch owner: [path](../path) — <queries/keys it fires, which are parallel, which are deferred>
- Client fn → route: `fn()` → `GET /route`
- Handler → data: [Controller](../path) → [Service/Repo](../path) → `<proc or query>`
- Tables: `...`
- Gotcha: <the thing that bites here>
-->
