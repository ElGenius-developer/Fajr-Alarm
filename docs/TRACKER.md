# Fajr-Alarm project tracker

This tracker records every completed milestone for Fajr-Alarm v1.0, active
post-merge tasks, technical follow-ups from code review, and future standalone
initiatives. Keep this document updated as branches merge into `main`.

<!-- prettier-ignore -->
> [!NOTE]
> The interactive `tutorial_coach_mark` user guide is intentionally tracked as
> an independent future task so it receives dedicated planning, dependency
> approval, and per-screen test coverage in its own branch and PR.

---

## Completed work (v1.0 — merged to `main`)

The core Fajr-Alarm v1.0 application passed Hydrogen QA and Argon review and
merged into `main` via PR #11 (`d8c2b46`). Each phase below reflects the exact
git history on `main`.

- [x] **Governance, BRD, SRS, and project onboarding (`2f4d3c0`, `3035481`, `228a386`)**
  Locked v1.0 requirements in `SRS-Fajr-alarm.md`, domain terms in
  `GLOSSARY.md`, Clean Architecture rules in `CLAUDE.md`, `.claude/CONSTITUTION.md`,
  Flutter/Dart guidelines, and session memory infrastructure (`#10`).
- [x] **Phase 0: Core foundation scaffold (`fc83682`)**
  Established Clean Architecture directories (`lib/core/`, `lib/features/`),
  failure/result abstractions, lint configuration, and localization setup.
- [x] **Phase 1: Prayer schedule (`88bba41`, `18d03a3`)**
  Implemented offline 30-day Fajr calculation, configurable alarm lock window,
  offset chips, manual time override, and local Hive caching.
- [x] **Phase 2: Native alarm platform channels (`ca0babb`, `0767db6`)**
  Built Android 10+ (`minSdk 29`, `targetSdk 35`) foreground alarm service and
  iOS 26+ `AlarmKit` cascade bridge via method and event channels.
- [x] **Phase 3: Settings and streak (`5be6f38`, `0f537a2`)**
  Added streak KPIs, vacation mode, monthly emergency quota controls, and the
  dry-run alarm test scheduler with cancel support.
- [x] **Phase 4: Alarm ringing (`2941552`, `281a708`)**
  Implemented alarm ringing domain rules, `AlarmRingingBloc`, escalation audio
  handling, and emergency override termination flow.
- [x] **Phase 5: Challenge verification (`dfdc1f3`, `ab30e35`)**
  Built Proof-of-Action verification supporting Gemini Vision photo checks
  (RAM-only purge), device tilt detection, barcode scanning, and standing typing.
- [x] **Phase 6: Onboarding (`813cf00`, `3a77db2`)**
  Implemented the 4-step onboarding flow covering location setup, permissions,
  explicit Gemini privacy consent, and BYOK API key storage in
  `FlutterSecureStorage`.
- [x] **Phase 7: DI, routing, and live locale switching (`2b2bf12`)**
  Wired `get_it` dependencies (`lib/core/di/injection.dart`), `GoRouter`
  routes (`/`, `/onboarding`, `/alarm-ringing`, `/challenge`, `/settings`),
  Hive type adapters, and runtime Arabic/English switching.
- [x] **v1.0 UI polish and themes (`f018922`)**
  Applied 60-30-10 Stitch UI layouts, Cairo font defaults, 7 light/dark themes,
  and 195 localization keys per `.arb` file (`ar` and `en`).
- [x] **QA fixes, Argon approval, and PR #11 merge (`c4034b4`, `034ffd9`, `d8c2b46`)**
  Resolved all 8 Hydrogen QA findings (native trigger delivery on cold launch,
  Android `SCHEDULE_EXACT_ALARM` permission compatibility, iOS settings link,
  offset/manual picker UI, dry-run cancellation, bloc safety, onboarding copy),
  passed 234/234 unit and widget tests (`90.97%` domain coverage, `87.21%` data
  repository coverage, `81.36%` bloc/cubit coverage), earned Hydrogen
  `QA_VERDICT: PASS` and Argon `VERDICT: APPROVE`, and merged PR #11 into `main`.
- [x] **UX polish, live barcode scanner, Quiet Dawn icon, and physical device deploy (`55a2130`, PR #12)**
  Added live `MobileScanner` onboarding scan UI, locale-aware English/Arabic
  typography refinements, single-line `SegmentedButton` labels, updated Arabic
  escalation copy, installed full-bleed Quiet Dawn iOS/Android icons, captured
  12 dark/light AR/EN screenshots in `docs/screenshots/`, passed 238/238 tests,
  merged PR #12 into `main`, and installed and launched a Release build over
  Wi-Fi on a physical `iPhone 16 Pro Max` (`iOS 27.2.1`).

---

## Active and upcoming tasks

The items below represent immediate next steps starting from branch
`feat/walkthrough-and-screenshots` alongside non-blocking improvements recorded
during the PR #11 review.

### 1. Visual check, UX polish, and screenshot gallery

Verify rendered UI across device states, polish UX issues surfaced during
review, and maintain the visual reference set under `docs/screenshots/`.

1. [x] Launch the app on the iOS simulator (`iPhone 17 Pro`, iOS 26.5) and
   open the camera verification screen (`/challenge`).
2. [x] Capture screenshots for every primary route (`/onboarding` steps 1–4,
   `/`, `/alarm-ringing`, `/challenge` camera + fallback, and `/settings`)
   across Dark/Light modes and Arabic (RTL) / English (LTR) locales.
3. [x] Store organized, lowercase hyphenated PNG captures inside
   `docs/screenshots/` (12 PNGs verified cleanly) and fix the `Size.fromHeight`
   button theme infinite-width constraint bug discovered in Onboarding steps
   2–4 (`lib/core/theme/app_theme.dart` + regression test).
4. [x] Implement UX polish & custom App Icon from visual screenshot review:
   - Add live camera barcode scanning (`MobileScanner` + viewfinder overlay +
     haptics + confirmation badge + `scannerBuilder` test hook) to Onboarding
     Step 4 (`lib/features/onboarding/presentation/widgets/barcode_step_view.dart`).
   - Soften English typography (`Avenir Next` + softer weights in
     `lib/core/theme/app_theme.dart`) and keep prayer schedule
     `SegmentedButton` labels on a single line (`showSelectedIcon: false` +
     `FittedBox` in `prayer_schedule_page.dart`).
   - Replace `"رنّ ملحّ — استيقظ الآن!"` with
     `"رنين متواصل — استيقظ الآن!"` in `lib/core/l10n/app_ar.arb` and update
     the corresponding widget test.
   - Install the approved Quiet Dawn full-bleed App Icon across all iOS
     (`Assets.xcassets/AppIcon.appiconset/`) and Android (`mipmap-*/`) assets.

### 2. Code review follow-ups and release readiness

Address the low-priority polish items identified in the PR #11 Argon review
before distributing store builds.

- [ ] **Refactor `prayer_schedule_page.dart`:** Split the 1,352-line file into
  focused child widgets inside
  `lib/features/prayer_schedule/presentation/widgets/` to align with the 800-line
  file guideline.
- [ ] **Configure Android release signing:** Replace debug signing fallback in
  `android/app/build.gradle.kts` with an explicit release `signingConfig` backed
  by environment/keystore properties before Google Play distribution.
- [ ] **Localize native alarm strings (optional):** Externalize any remaining
  hardcoded English notification labels in Android/iOS native alarm services so
  background notifications match the selected app locale.

---

## Future independent tasks

These initiatives require separate design review, architecture approval, and
dedicated feature branches before any implementation begins.

### Onboarding BYOK quick-launch button (next version)

Improve Step 3 (`PrivacyKeyStepView`) onboarding so users who do not yet have a
Gemini API key can generate one directly without leaving setup manually.

- **Status:** `[ ] Scheduled for next version (v1.1)`
- **Target surface:** `lib/features/onboarding/presentation/widgets/privacy_key_step_view.dart`
  and `lib/features/onboarding/presentation/pages/onboarding_page.dart`
- **Scope:**
  1. [ ] Add a localized **Get Key from Google AI Studio** action button
     (`ar` and `en` in `.arb` files) that launches
     `https://aistudio.google.com/apikey` in the system browser.
  2. [ ] Expose an injectable URL-launching abstraction (either zero-dependency
     `openExternalUrl` on existing Android/iOS channels or approved
     `url_launcher`) with graceful error feedback and widget/unit tests.

### Interactive step-by-step user guide (`tutorial_coach_mark`)

- **Status:** `[ ] Deferred — future independent task`
- **Reference implementation:** `/Users/ahmed/Documents/GitHub/athkari`
  (`tutorial_coach_mark: ^1.2.11` paired with
  `lib/core/services/walkthrough_service.dart`)

<!-- prettier-ignore -->
> [!IMPORTANT]
> This feature adds a new package dependency (`tutorial_coach_mark`), introduces
> per-screen widget `GlobalKey` hooks, and touches every user-facing page. Plan
> and build it in an isolated branch rather than bundling it with UI checks or
> bug fixes.

When you schedule this task as its own milestone, execute these steps:

1. [ ] **Plan and approve dependency:** Request explicit approval to add
   `tutorial_coach_mark` to `pubspec.yaml`, define walkthrough state rules, and
   publish a step-by-step spec.
2. [ ] **Build walkthrough persistence service:** Create a `WalkthroughService`
   (or clean-architecture equivalent under `lib/core/` + `settings_and_streak`)
   persisting first-run completion flags per screen or globally via Hive.
3. [ ] **Define spotlight steps for every route:** Attach `GlobalKey` targets
   and progressive coach-mark spotlights for:
   - Onboarding steps and permission/consent explanations (`/onboarding`)
   - Prayer schedule card, alarm toggle, lock window, and offset/manual
     controls (`/`)
   - Ringing screen actions and escalation indicator (`/alarm-ringing`)
   - Camera Proof-of-Action / fallback challenge controls (`/challenge`)
   - Streak metrics, vacation mode, emergency quota, and dry-run card
     (`/settings`)
4. [ ] **Localize all coach-mark copy:** Add Arabic (RTL) and English (LTR)
   titles, descriptions, Next/Skip/Finish labels to `lib/core/l10n/app_ar.arb`
   and `lib/core/l10n/app_en.arb`, then regenerate `flutter gen-l10n`.
5. [ ] **Add manual replay control:** Add a **"Replay User Guide"** action in
   Settings so returning users can re-trigger the walkthrough at any time.
6. [ ] **Verify with tests and static checks:** Write unit tests for
   persistence state and widget tests for auto-launch on first visit, skip,
   step progression, RTL card positioning, and manual replay, maintaining 80%+
   coverage plus zero `dart analyze --fatal-infos` or format issues.
