# iOS AlarmKit ringing and challenge routing fix spec

This specification documents the root causes behind failed alarm ringing and
challenge routing on physical iOS 26+ hardware (`iPhone 16 Pro Max`,
`iOS 27.2.1`) and defines the implementation plan to wire Apple `AlarmKit`
directly into Fajr-Alarm's `/alarm-ringing` and `/challenge` flow.

<!-- prettier-ignore -->
> [!NOTE]
> Live testing on a physical device scheduled for 5:35 PM triggered an OS alarm
> that could be cancelled without opening `/alarm-ringing`, displaying a
> challenge button, or playing in-app ringing audio. The findings below come
> from inspecting `ios/Runner/AlarmKitManager.swift`, `lib/main.dart`, and the
> `iPhoneOS.sdk` `AlarmKit` and `AppIntents` Swift interfaces.

---

## Root cause analysis

Four native iOS integration defects prevent scheduled alarms from launching the
ringing and Proof-of-Action UI cleanly.

1. **Deprecated `stopButton` ignored on iOS 26.1+:** In
   `ios/Runner/AlarmKitManager.swift` lines 179–186, `AlarmPresentation.Alert`
   passes the `stopButton:` initializer parameter, which `AlarmKit` marks
   `@available(iOS, deprecated: 26.1, message: "stopButton is deprecated and will
   no longer be used")`. iOS renders only the system default Cancel/Stop button
   unless `secondaryButton` and `secondaryButtonBehavior: .custom` are supplied.
2. **Missing `stopIntent` in `AlarmConfiguration`:** In
   `ios/Runner/AlarmKitManager.swift` lines 191–195, `AlarmManager.AlarmConfiguration`
   sets `secondaryIntent: OpenFajrChallengeIntent()` while omitting
   `stopIntent:`. Tapping the system Stop/Cancel button dismisses the alarm
   without running `OpenFajrChallengeIntent` or opening the app.
3. **Unreliable cold-start delivery and missing `.alerting` state checks:**
   `OpenFajrChallengeIntent` uses deprecated `openAppWhenRun = true` instead of
   iOS 26 `supportedModes` (`IntentModes.foreground(.immediate)`), posts only to
   an in-memory `NotificationCenter` observer (race-prone on cold launch), and
   `AlarmKitManager` never observes `AlarmManager.shared.alarmUpdates` or
   checks `AlarmManager.shared.alarms` for active `.alerting` alarms during
   `consumePendingAlarmTrigger()`.
4. **Silent foreground `AVAudioPlayer`:** `AlarmKitManager` declares
   `private var audioPlayer: AVAudioPlayer?` on line 49 but never initializes it
   with an audio asset or synthesized tone, so `startForegroundAudio()` produces
   no sound when `/alarm-ringing` opens.

---

## Platform reality on iOS 26+

Apple's `AlarmKit` renders a system-controlled Lock Screen and Dynamic Island
alarm presentation that always includes a system stop control; third-party iOS
apps cannot suppress the OS lock-screen sheet the way Android `USE_FULL_SCREEN_INTENT`
and `startLockTask()` do. Within Apple's contract, attaching
`OpenFajrChallengeIntent` to both `stopIntent` and `secondaryIntent`, retaining
the `Relentless Cascade` alarms (`T0+5m`, `T0+6m`, ..., `T0+15m`) until
challenge completion or 60-second emergency override, and routing active
`.alerting` alarms into `/alarm-ringing` ensures tapping any alarm control or
opening the app launches the Proof-of-Action ringing flow immediately.

---

## Step-by-step implementation plan

Work through these steps sequentially on a dedicated feature branch after user
approval.

1. **Create feature branch:** Branch `fix/ios-alarmkit-ringing-flow` from
   `main`.
2. **Upgrade `AlarmPresentation.Alert` and `AlarmConfiguration` in
   `ios/Runner/AlarmKitManager.swift`:**
   - Configure `AlarmPresentation.Alert(title:secondaryButton:secondaryButtonBehavior:)`
     on iOS 26.1+ (keeping an `iOS 26.0` fallback branch) with `secondaryButton`
     set to **Open Challenge** (`camera.viewfinder`) and `secondaryButtonBehavior: .custom`.
   - Pass `OpenFajrChallengeIntent()` to both `stopIntent:` and
     `secondaryIntent:` in `AlarmManager.AlarmConfiguration`.
   - Confirm `Localization` / copy works cleanly across English and Arabic.
3. **Harden foreground launch and active-alarm detection:**
   - Update `OpenFajrChallengeIntent` to set `supportedModes = .foreground(.immediate)`
     in addition to persisting a pending-trigger flag in `UserDefaults.standard`
     alongside `NotificationCenter.default.post`.
   - Observe `AlarmManager.shared.alarmUpdates` in `AlarmKitManager` so any
     cascade alarm entering `.alerting` notifies Flutter immediately while the
     app is open or foregrounded.
   - Update `consumePendingAlarmTrigger()` to inspect `UserDefaults` and active
     `.alerting` cascade alarms in `AlarmManager.shared.alarms`, clearing the
     flag atomically on read and leaving Flutter route guards in
     `lib/main.dart` intact (`_openAlarmRinging` ignores duplicate triggers when
     already on `/alarm-ringing` or `/challenge`).
4. **Add looping in-app alarm audio:**
   - Generate an in-memory PCM/WAV alarm chime buffer (or bundled asset) inside
     `AlarmKitManager`, initialize `AVAudioPlayer(data:)` with
     `numberOfLoops = -1`, configure `AVAudioSession` playback category cleanly,
     and wire `startForegroundAudio()`, `stopForegroundAudio()`, `muteRingingAudio()`,
     and `unmuteRingingAudio()` to control it reliably.
5. **Verify Flutter checks and physical device test:**
   - Check Snooze (`SnoozeRequested`), Mute during Challenge, Challenge Pass
     (`CompleteAlarmUseCase`), and 60-second Emergency Override state
     transitions alongside `lib/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart`.
   - Run `dart format --output=none --set-exit-if-changed .`,
     `dart analyze --fatal-infos`, and `flutter test --no-pub --coverage`.
   - Build a wireless Release iOS binary signed with Personal Team
     `J52H7284YY` onto `Ahmed's iphone` (`iOS 27.2.1`) and run a live 2-minute
     alarm verification covering lock screen, background, and foreground states.
6. **Ship via Pull Request:** Open a PR from `fix/ios-alarmkit-ringing-flow` into
   `main`, review against `.claude/CONSTITUTION.md` gates, and merge after
   verification passes.
