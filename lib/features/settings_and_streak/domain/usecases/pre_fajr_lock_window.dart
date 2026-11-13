/// Duration before Fajr alarm when destructive/bypass settings are locked.
const Duration kPreFajrLockDuration = Duration(minutes: 30);

/// Returns `true` if [now] falls in the `T - 30m` Pre-Fajr Lock Window or if
/// the alarm is currently ringing/in-challenge (`[isAlarmRinging]`).
bool isWithinPreFajrLockWindow({
  required DateTime now,
  DateTime? nextFajrAlarmAt,
  bool isAlarmRinging = false,
}) {
  if (isAlarmRinging) return true;
  if (nextFajrAlarmAt == null) return false;
  final lockStart = nextFajrAlarmAt.subtract(kPreFajrLockDuration);
  return !now.isBefore(lockStart);
}
