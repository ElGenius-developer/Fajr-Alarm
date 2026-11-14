### Topic
Completed Fajr-Alarm v1.0 phases (0–7), fixed Cairo prayer schedule defaults, added 7 multi-mode design themes, and configured Google Stitch MCP.

### Context
- Branch: `feat/fajr-alarm-v1` (HEAD `2b2bf12`, with verified uncommitted UI/theme/Cairo-default changes in working tree).
- Core & Features touched:
  - `lib/main.dart`, `lib/core/theme/app_theme.dart`, `lib/core/theme/appearance_sheet.dart`, `lib/core/l10n/app_{ar,en}.arb`
  - `lib/features/prayer_schedule/data/repositories/prayer_schedule_repository_impl.dart`, `lib/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart`
  - `lib/features/settings_and_streak/domain/entities/user_settings.dart`, `data/datasources/settings_local_data_source.dart`, `presentation/cubit/settings_cubit.dart`, `presentation/pages/settings_page.dart`
  - Global IDE config outside repo: `~/.gemini/antigravity/mcp_config.json` and `~/.gemini/config/mcp_config.json` (Stitch MCP).

### What WORKED (with evidence)
- **Full v1.0 Phases 0–7 implementation & wiring** — confirmed by: committed on `feat/fajr-alarm-v1` up to `2b2bf12`, 194 tests passing, 83.48% core coverage prior to theme additions.
- **Cairo default prayer schedule (`4:50 AM` Fajr, `6:19 AM` Sunrise) + City/Method picker** — confirmed by: simulator run on `iPhone 17 Pro` (`A1A2128C-8DD6-4824-9A04-9FD6350C5BB8`) and full `flutter test` pass.
- **7 design themes (`horizon`, `sanctuary`, `editorial`, `liquid`, `desert`, `nordic`, `velvet`) + Light/Dark/System modes** — confirmed by: `dart format --set-exit-if-changed .` (0 changed across 139 files), `dart analyze --fatal-infos` (No issues found), `flutter test` (194 passed).
- **Google Stitch MCP configuration & discovery** — confirmed by: valid JSON in both `~/.gemini/antigravity/mcp_config.json` and `~/.gemini/config/mcp_config.json` and Antigravity discovering `/Users/ahmed/.gemini/antigravity/mcp/stitch` with all 18 Stitch tool schemas (`create_project`, `generate_screen_from_text`, `create_design_system`, etc.).

### Problems & Solutions
- **Problem:** Default Fajr time showed Makkah time (`4:12 AM` in Cairo TZ) instead of Cairo (`4:50 AM`).
  - **Root cause:** `defaultConfig` in `prayer_schedule_repository_impl.dart` defaulted to Makkah coordinates and Umm al-Qura calculation method.
  - **Attempts:**
    - Updated `defaultConfig` to Cairo (`30.0444, 31.2357`, `FajrCalculationMethod.egyptian`) and added City & Calculation Method picker sheet on `PrayerSchedulePage` — **outcome:** worked (`4:50 AM` Fajr verified on simulator).
  - **Final solution:** `lib/features/prayer_schedule/data/repositories/prayer_schedule_repository_impl.dart` + `prayer_schedule_page.dart`.
- **Problem:** Google Stitch MCP initially appeared missing/unloaded after adding `stitch` only to `~/.gemini/antigravity/mcp_config.json`.
  - **Root cause:** `gcloud` is not installed (`STITCH_API_KEY` header auth required), `~/.gemini/config/mcp_config.json` (documented global Antigravity config) did not have the `stitch` entry, and Antigravity needed an MCP Refresh / new session to discover schemas.
  - **Attempts:**
    - Checked `mcp_config.json` schemas (`serverUrl` + `headers` pattern confirmed active via `browser-use`) and added `"stitch"` to `~/.gemini/antigravity/mcp_config.json` — **outcome:** partial (config valid, not yet discovered in `~/.gemini/config/mcp_config.json`).
    - Synced `"stitch"` (keeping the user's key untouched) to `~/.gemini/config/mcp_config.json` and refreshed MCP Servers — **outcome:** worked (`/Users/ahmed/.gemini/antigravity/mcp/stitch` populated with 18 tool schemas).
  - **Final solution:** Streamable HTTP `"stitch"` block (`https://stitch.googleapis.com/mcp` with `X-Goog-Api-Key`) synced in both `~/.gemini/antigravity/mcp_config.json` and `~/.gemini/config/mcp_config.json`.

### Decisions Made
- **7 selectable `AppDesignStyle` presets + `ThemeMode` persisted in `UserSettings` (`Hive` backward-compatible `reader.availableBytes > 0`)** — reason: lets user preview and choose a flagship design direction live without breaking existing Hive records.
- **Streamable HTTP (`serverUrl` + `X-Goog-Api-Key`) for Google Stitch MCP** — reason: `gcloud` is not installed on this machine, and `browser-use` confirmed Antigravity supports `serverUrl` + `headers`.

### Files Touched
- `lib/core/theme/app_theme.dart` — added 7 `AppDesignStyle` presets, `FajrDesignTokens`, Light/Dark theme builders, and `parseThemeMode`.
- `lib/core/theme/appearance_sheet.dart` — created modal appearance picker sheet (Light/Dark/System + 7 themes).
- `lib/core/l10n/app_en.arb`, `app_ar.arb` (& generated localizations) — added appearance, theme names, city, and method strings.
- `lib/features/prayer_schedule/data/repositories/prayer_schedule_repository_impl.dart` — changed default city/method to Cairo & Egyptian General Authority.
- `lib/features/prayer_schedule/presentation/pages/prayer_schedule_page.dart` — added City/Method picker sheet, appearance trigger, and 7 custom hero painters.
- `lib/features/settings_and_streak/domain/entities/user_settings.dart` (& `.freezed.dart`) — added `themeMode` and `designStyle`.
- `lib/features/settings_and_streak/data/datasources/settings_local_data_source.dart` — backward-compatible Hive adapter read/write for `themeMode` and `designStyle`.
- `lib/features/settings_and_streak/presentation/cubit/settings_cubit.dart` — added `switchThemeMode` and `switchDesignStyle`.
- `lib/features/settings_and_streak/presentation/pages/settings_page.dart` — added `_AppearanceCard` and Bento `_KpiTile` styling.
- `lib/main.dart` — wired live `themeMode` and `designStyle` into `MaterialApp.router`.

### Open Questions / Blockers
- Uncommitted working-tree changes on `feat/fajr-alarm-v1` (Cairo default, city/method picker, 7 themes + Light/Dark) need to be committed cleanly before or alongside the Stitch UI redesign pass.
- Re-run full `flutter test --coverage` (>= 80% gate across `domain/`, `data/repositories/`, `presentation/bloc|cubit/`) after completing Stitch-driven UI updates.

### Exact Next Step
Use the newly connected **Google Stitch MCP** (`create_project`, `create_design_system`, `generate_screen_from_text`, `get_screen`) alongside `design-md`, `ui-ux-pro-max`, `flutter-adaptive-ui`, and `frontend-design` to design a cohesive modern visual identity & screens for **Fajr-Alarm** (Prayer Schedule, Alarm Ringing + Touch-Mute Emergency Override, Challenge Verification, Settings & Streak, Onboarding) in Light & Dark modes, translate the approved Stitch design system into Flutter, verify on iPhone Simulator, and run the full quality/coverage gate.

