# Query Recipes — fajr_alarm

Copy-paste templates per task:

- **Find where a Dart symbol is defined (rung 2, fastest):**
  `jq '.AlarmRingingBloc' docs/SYMBOLS.json`

- **Trace blast radius before changing a repository or usecase (rung 4):**
  `graphify affected "PrayerScheduleRepository" --depth 2`

- **Inspect a single class or file node and its neighbors (rung 5):**
  `graphify explain "AlarmKitManager.swift"`

- **Find shortest connection between two components (rung 5):**
  `graphify path "AlarmRingingBloc" "AlarmPlatformDataSource"`

- **Check graph multigraph health:**
  `graphify diagnose multigraph`
