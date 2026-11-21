### Topic
Fixed the Android snooze. Before, snooze could silence the alarm for good, and relaunching the app reset it. Snooze now arms a native exact alarm before it stops ringing, and the "snooze used" flag survives a relaunch and a reboot.

### Context
- Dart: `lib/features/alarm_ringing/domain/usecases/snooze_alarm_usecase.dart`, `alarm_ringing_bloc.dart`, `alarm_ringing_event.dart`, the `alarm_platform_*` repository and data source, `lib/main.dart`, `lib/core/router/app_router.dart`
- Android: `android/app/src/main/kotlin/com/elgenius/fajralarm/fajr_alarm/{AlarmReceiver,AlarmStorage,DirectBootReceiver,MainActivity}.kt`
- iOS: `ios/Runner/AlarmKitManager.swift`, where `scheduleSnoozeAlarm` is a no-op

### What WORKED (with evidence)
- **Snooze arms a native alarm 5 minutes out before it stops ringing, and keeps ringing if arming fails** — confirmed by: new tests in `alarm_usecases_test.dart`; `flutter test` → `+253: All tests passed!`
- **A relaunch after a used snooze rings relentlessly, with no new snooze** — confirmed by: new bloc test `relaunch after the snooze was used rings relentlessly with no new snooze`.
- **The snoozeUsed flag crosses the channel** — confirmed by: `alarm_platform_data_source_test.dart` (`native trigger after a used snooze reaches Dart with snoozeUsed set`).
- **Native code compiles** — confirmed by: `flutter build apk --debug` → `Built app-debug.apk`; `flutter build ios --simulator --debug` → `Built Runner.app`; `dart analyze --fatal-infos` → `No issues found!`

### Problems & Solutions
- **Problem:** On Android, the alarm never came back after a snooze if the process died or Doze froze it.
  - **Root cause:** `SnoozeAlarmUseCase` called `stopRinging()`, which kills the foreground service and the wake lock. The only resume path was a Dart `Timer.periodic` in `AlarmRingingBloc`.
  - **Final solution:** the use case calls `scheduleSnoozeAlarm(at: now+5m)` first (Android `setAlarmClock`, request code 1003), and only then `stopRinging()`. If arming fails, it returns Left and the alarm keeps ringing.
- **Problem:** Relaunching the app during a snooze gave the user a fresh snooze.
  - **Root cause:** `_onAlarmTriggered` always set `snoozeUsed: false`.
  - **Final solution:**
    - `AlarmStorage.markSnoozed` stores the snooze time in device-protected storage, with a 2h session window.
    - The native trigger payload carries `snoozeUsed`.
    - The `alarmTriggered(snoozeUsed: true)` event goes straight to relentless ringing.
- **Problem (from the independent review, MEDIUM):** a reboot during the snooze lost alarm 1003.
  - **Final solution:** `AlarmStorage` stores the snooze due time and the dry-run flag. `DirectBootReceiver` re-arms 1003 at `max(due, now+1s)` through `pendingSnooze`.
- **Test:** `dart run build_runner build --delete-conflicting-outputs` regenerated only `alarm_ringing_event.freezed.dart`.

### Decisions Made
- **The snooze alarm uses its own request code, 1003, separate from the next-Fajr alarm (1001).** — reason: rescheduling tomorrow (for example when the schedule page reloads) must not replace a snooze that is in progress.
- **Arm before stop.** — reason: a ringing alarm the user can still silence is safer than a silent one that depends on a Dart timer.
- **iOS `scheduleSnoozeAlarm` is a no-op.** — reason: the AlarmKit cascade already rings at T0+5m whether or not the app is alive.

### Files Touched
- `lib/features/alarm_ringing/domain/usecases/snooze_alarm_usecase.dart` — arm the native alarm, then stop
- `lib/features/alarm_ringing/domain/repositories/alarm_platform_repository.dart`, `data/repositories/alarm_platform_repository_impl.dart`, `data/datasources/alarm_platform_data_source.dart` — `scheduleSnoozeAlarm`, plus `snoozeUsed` in the trigger callback
- `lib/features/alarm_ringing/presentation/bloc/alarm_ringing_event.dart` (+ freezed), `alarm_ringing_bloc.dart` — `snoozeUsed` sends the alarm to relentless
- `lib/main.dart`, `lib/core/router/app_router.dart` — pass `snoozeUsed` through the route
- `android/.../AlarmReceiver.kt` — `scheduleSnoozeAlarm` (1003); `cancelAllAlarms` cancels 1001 and 1003 and clears the snooze
- `android/.../AlarmStorage.kt` — snooze time, due time, dry-run flag, 2h window
- `android/.../DirectBootReceiver.kt` — re-arm the pending snooze after a reboot
- `android/.../MainActivity.kt` — `scheduleSnoozeAlarm` channel method; `snoozeUsed` in both trigger payloads
- `ios/Runner/AlarmKitManager.swift` — no-op `scheduleSnoozeAlarm`
- 3 test files — snooze arming, failure stays loud, relaunch goes relentless, channel flag
- `.claude/PRPs/reviews/pr-20-review.md`, `.claude/memory.md`

### Open Questions / Blockers
- **MEDIUM (review), fixed in a follow-up PR:** disable/vacation/dry-run cancel now call `cancelNextFajrAlarm` (cancels 1001 only). `cancelAllAlarms` is also called by `saveNextScheduledAlarm(null)` (alarm disabled or vacation) and by the dry-run cancel. If one of those runs during a snooze, it clears 1003 and the snooze mark, and the user escapes the snooze. This is only reachable if Settings are unlocked during a snooze. Fix: a separate native "cancel next Fajr only" call for those paths.
- **LOW:** if `_escalateToRelentless` fails on relaunch, the Dart loop never starts. Native audio keeps ringing.
- **LOW:** the 2h snooze window can expire during a very long ring.
- **Not tested on a physical Android device.** There is no Kotlin unit test harness.
- **The other Android items from the code review are still open:**
  - real and dry-run alarms share 1001
  - completion ignores a reschedule failure
  - the emergency quota is checked after the alarm stops
  - the lock-window monotonic path is dead

### Exact Next Step
Test on an Android device: set a dry-run alarm, snooze, then swipe the app away. Expect a ring 5 minutes later with no snooze button.
