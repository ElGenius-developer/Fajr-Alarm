/// Lifecycle states of the Fajr-Alarm state machine (SRS Section 5).
enum AlarmStatus {
  idle,
  lockedPreFajr,
  ringingInitial,
  snoozed5Min,
  ringingRelentless,
  challengeActive,
  completed,
  vacationFrozen,
}
