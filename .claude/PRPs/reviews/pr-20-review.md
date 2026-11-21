# PR Review — #20 `fix/android-snooze-native-rearm` → `main`

**Date:** 2026-11-21 · **Decision: APPROVE** (Ahmed pre-approved a direct merge if the review is clean)

## Independent review (opus, read-only)
CRITICAL 0 · HIGH 0 · MEDIUM 2 · LOW 2

- **MEDIUM:** a reboot during the snooze lost alarm 1003. **Fixed in this PR:** `AlarmStorage.pendingSnooze` plus a re-arm in `DirectBootReceiver`.
- **MEDIUM (fixed in a follow-up PR via `cancelNextFajrAlarm`):** `cancelAllAlarms`, called from `saveNextScheduledAlarm(null)` and from the dry-run cancel, clears the snooze. This is only reachable if Settings are unlocked during a snooze.
- **LOW (open):** a failed escalation on relaunch never retries in Dart. Native audio keeps ringing.
- **LOW (open):** the 2h snooze window can expire during a very long ring.

## Gates
Domain purity, l10n and secrets pass. The use case stays pure Dart; `now` is injected.

## Validation (real output)
| Check | Result |
|---|---|
| `dart format --set-exit-if-changed .` | 0 changed |
| `dart analyze --fatal-infos` | No issues found! |
| `flutter test` | +253: All tests passed! |
| `flutter build apk --debug` | Built |
| `flutter build ios --simulator --debug` | Built |
| Android device test | not done |
