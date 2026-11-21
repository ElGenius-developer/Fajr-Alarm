# PR Review — #18 `fix/ios-alarm-stop-keeps-ringing` (stacked on #17)

**Reviewed HEAD:** `4193469` · **Date:** 2026-11-21 · **Decision: APPROVE**

## Summary
Fixes the iOS alarm going silent after Stop on a locked phone:
- A reschedule no longer cancels a cascade that has already started.
- Stop runs a background re-arm intent.
- Open Challenge re-arms before it asks to continue in the foreground.

## Independent review (opus, read-only) → fixed in `4193469`
- **HIGH:** the dry-run flag came from the global last-scheduled value, so a dry run could be reported as a real alarm. **Fixed:** `FajrCascadePolicy.ringingIsDryRun`, with a test.
- **HIGH:** Open Challenge did not re-arm, so a failed unlock after the cascade ended left nothing to ring. **Fixed:** `supportedModes [.background, .foreground(.dynamic)]`, which re-arms and then calls `continueInForeground`.
- **MEDIUM:** a re-arm in flight could survive completion. **Fixed:** `@MainActor` plus a cancel generation check after the await.
- **LOW:** the schedule loop saved a stale copy of the records. **Fixed:** it reloads before each save.
- **LOW (open):** unknown whether the app's own `stop(id:)` runs the Stop intent. Even if it does, completion clears the records, so it is bounded.

## Validation (real output)
| Check | Result |
|---|---|
| RunnerTests (iOS 26.5 sim) | 7/7 passed, TEST SUCCEEDED |
| `dart analyze --fatal-infos` | No issues found! |
| `flutter test --coverage` | +250: All tests passed! |
| Device: iPhone 16 Pro Max, iOS 27.2.1 | Slide to stop on the locked phone → rings again about 1 min later. Open Challenge → keeps ringing and asks for the passcode. Open Challenge with the passcode cancelled after 15 min → rings again (verified by Ahmed) |
