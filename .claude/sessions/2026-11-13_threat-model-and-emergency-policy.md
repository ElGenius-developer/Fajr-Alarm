### Topic
Resolution of Wayfinder tickets `#6` (Threat Model & Anti-Cheating Policy) and `#7` (Emergency Override & Vacation Mode), creation of `GLOSSARY.md`, and activation of Antigravity Remote Control (`agy remote-control`).

### Context
Wayfinder decision map (`#1` on GitHub), domain vocabulary (`GLOSSARY.md`), shared team memory (`.claude/memory.md`), and local Antigravity CLI remote-control daemon.

### What WORKED (with evidence)
- **Interactive step-by-step Grilling via `ask_question`** — confirmed by: user answered all 4 questions of `#6` and all 3 questions of `#7` one by one with plain-Arabic scenario explanations.
- **Wayfinder ticket `#6` ("نموذج التهديد وسياسة الغش") resolved & closed** — confirmed by: `gh issue comment 6` posted `#issuecomment-6860676270`, `gh issue close 6` succeeded, and `#7` `blocked_by` dropped to `0`.
- **Wayfinder ticket `#7` ("تصميم الطوارئ والإجازة ضد الاستغلال") resolved & closed** — confirmed by: `gh issue comment 7` posted `#issuecomment-6864880904`, `gh issue close 7` succeeded, and Map `#1` `Decisions so far` updated.
- **Domain Glossary (`GLOSSARY.md`) created & updated** — confirmed by: `GLOSSARY.md` written at repo root with 9 canonical Arabic/English domain terms (`Proof-of-Action Challenge`, `Sleepy Self`, `Relentless Ringing`, `Bathroom Barcode Challenge`, `Standing Typing Challenge`, `Pre-Fajr Lock Window`, `Vacation Mode`, `Emergency Override`, `Streak Freeze`).
- **Antigravity Remote Control daemon (`agy remote-control`) started** — confirmed by: `/Users/ahmed/.gemini/bin/agy remote-control start` and `status` reported `Daemon state = running`, `Daemon pid = 25260`, and `Instance name: renders-macbook-pro-local-blazing-axis`.

### Problems & Solutions
- **Problem:** User found technical jargon in the initial `#6` Q2 prompt (`Airplane Mode`, `Offline Fallback`, `-45° to -90°`) unclear when presented without a concrete everyday scenario.
  - **Root cause:** Asking multi-part or technical questions at once instead of one question at a time with an everyday scenario preface.
  - **Attempts:**
    - Re-asked Q2–Q4 (and all of `#7`) one question at a time via `ask_question` with a `توضيح الفكرة ببساطة` scenario block — **outcome:** worked immediately.
  - **Final solution:** Always lead each `ask_question` call with a short `توضيح الفكرة ببساطة` concrete scenario and ask one question at a time.
- **Problem:** Initial attempt to enable "remote controller" ran `claude remote-control --name "Fajr-Alarm"` instead of Antigravity's `agy remote-control`.
  - **Root cause:** Ambiguous request ("please enable remote controller") initially interpreted as Claude Code Remote Control (`claude remote-control`), which failed with `Error: Remote Control requires claude.ai subscription auth. ANTHROPIC_API_KEY is set`.
  - **Attempts:**
    - Ran `claude remote-control --name "Fajr-Alarm"` — **outcome:** failed (`ANTHROPIC_API_KEY is set`).
    - Ran `env -u ANTHROPIC_API_KEY claude remote-control --name "Fajr-Alarm"` — **outcome:** failed because `ANTHROPIC_API_KEY` is also present in `~/.claude/settings.json`.
    - After user clarified `antigravity remote controller`, ran `/Users/ahmed/.gemini/bin/agy remote-control start` — **outcome:** worked (`PID 25260`, instance `renders-macbook-pro-local-blazing-axis`).
  - **Final solution:** Reverted `.claude/settings.json` and started `/Users/ahmed/.gemini/bin/agy remote-control start`.

### Decisions Made
- **Sleepy-Self Threat Model (`#6`)** — reason: personal-use open-source app only needs to defeat quick in-bed cheats by the sleepy user (volume, screen, toggling Wi-Fi/Airplane mode, screen photo, clock change), not complex `adb` or source-code tampering.
- **Offline Fallback Hierarchy (`#6` — `FR-4.2`)** — reason: Bathroom Barcode Scan is the primary offline challenge to force physical locomotion out of bed; the 120-char zero-error no-paste typing challenge is only available if no barcode is registered or camera fails, and requires holding the phone at the standing tilt angle (`-45°` to `-90°`).
- **Pragmatic POV Verification (`#6` — `FR-03` / `FR-04`)** — reason: live camera stream + standing tilt check (`-45°` to `-90°`) + balanced Gemini prompt that accepts any clear live photo of a foot standing on a prayer rug avoids frustrating false rejections at dawn.
- **Monotonic Clock & 30-Minute Pre-Fajr Lock Window (`#6` — `FR-5.4`)** — reason: monotonic clock prevents wall-clock tampering during ringing/snooze, and locking alarm edits / disabling / Vacation Mode starting at `T - 30m` prevents waking up 10 minutes early and disabling the alarm.
- **Touch-Mute + 60s Continuous Hold Emergency Override (`#7` — `FR-6.2`)** — reason: muting audio immediately while the finger is held down makes real emergencies safe, while requiring a continuous 60-second hold (plus a user-configurable monthly allowance in Settings, locked during `T - 30m`) prevents casual sleepy abuse.
- **Bounded Vacation Mode with Streak Freeze (`#7` — `FR-6.1`)** — reason: requiring an explicit number of days upfront (editable outside `T - 30m`), freezing the streak (`Streak Freeze`), and auto-resuming the alarm when the duration ends prevents forgetting the alarm disabled indefinitely.

### Files Touched
- `GLOSSARY.md` — created canonical project glossary with 9 resolved domain terms.
- `.claude/memory.md` — recorded `#6` (Threat Model & Anti-Cheating Policy) and `#7` (Emergency Override & Vacation Mode Policy).
- `.claude/sessions/2026-11-13_threat-model-and-emergency-policy.md` — saved structured session log.
- `.claude/sessions/INDEX.md` & `.claude/sessions/DIGEST.md` — updated session index and rebuilt keyword digest.

### Open Questions / Blockers
- Remaining open Wayfinder tickets on GitHub:
  - `#8`: [حدود الطبقات في Clean Architecture والـ cache](https://github.com/ElGenius-developer/Fajr-Alarm/issues/8) (`blocked_by: 0`, open on frontier).
  - `#9`: [استراتيجية الاختبار للأجزاء الـ native](https://github.com/ElGenius-developer/Fajr-Alarm/issues/9) (`blocked_by: 1`, blocked by `#8`).
- Remaining `Not yet specified` items on Map `#1`: local-only KPIs/streaks, i18n (`ar`/`en`) & RTL, and Onboarding + API key entry flow.

### Exact Next Step
Run `/wayfinder #1` to claim and resolve ticket `#8` ("حدود الطبقات في Clean Architecture والـ cache") one question at a time via `ask_question`, which will unblock the final ticket `#9` ("استراتيجية الاختبار للأجزاء الـ native").

