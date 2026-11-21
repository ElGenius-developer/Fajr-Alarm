package com.elgenius.fajralarm.fajr_alarm

import android.content.Context
import android.content.SharedPreferences

data class ScheduledAlarmData(
    val scheduledAtEpochMillis: Long,
    val isDryRun: Boolean,
)

/**
 * Direct-Boot-safe storage backed by Android `deviceProtectedStorage` so scheduled
 * Fajr alarm metadata survives device reboots before the user unlocks the lock screen.
 */
object AlarmStorage {
    private const val PREFS_NAME = "fajr_alarm_direct_boot_prefs"
    private const val KEY_SCHEDULED_AT = "scheduled_at_epoch_millis"
    private const val KEY_IS_DRY_RUN = "is_dry_run"
    private const val KEY_SNOOZED_AT = "snoozed_at_epoch_millis"
    private const val KEY_SNOOZE_DUE_AT = "snooze_due_at_epoch_millis"
    private const val KEY_SNOOZE_IS_DRY_RUN = "snooze_is_dry_run"

    /** A snooze older than this belongs to a previous Fajr, not the one ringing now. */
    private const val SNOOZE_SESSION_MS = 2 * 60 * 60 * 1_000L

    private fun prefs(context: Context): SharedPreferences {
        val deviceContext = context.createDeviceProtectedStorageContext()
        return deviceContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    }

    fun saveAlarm(context: Context, scheduledAtEpochMillis: Long, isDryRun: Boolean) {
        prefs(context)
            .edit()
            .putLong(KEY_SCHEDULED_AT, scheduledAtEpochMillis)
            .putBoolean(KEY_IS_DRY_RUN, isDryRun)
            .apply()
    }

    fun clearAlarm(context: Context) {
        prefs(context)
            .edit()
            .remove(KEY_SCHEDULED_AT)
            .remove(KEY_IS_DRY_RUN)
            .apply()
    }

    /** Keeps the first snooze time, so re-arming after a reboot doesn't extend the session. */
    fun markSnoozed(context: Context, nowEpochMillis: Long, dueAtEpochMillis: Long, isDryRun: Boolean) {
        val sp = prefs(context)
        val snoozedAt = sp.getLong(KEY_SNOOZED_AT, -1L).takeIf { it > 0L } ?: nowEpochMillis
        sp.edit()
            .putLong(KEY_SNOOZED_AT, snoozedAt)
            .putLong(KEY_SNOOZE_DUE_AT, dueAtEpochMillis)
            .putBoolean(KEY_SNOOZE_IS_DRY_RUN, isDryRun)
            .apply()
    }

    fun clearSnooze(context: Context) {
        prefs(context).edit()
            .remove(KEY_SNOOZED_AT)
            .remove(KEY_SNOOZE_DUE_AT)
            .remove(KEY_SNOOZE_IS_DRY_RUN)
            .apply()
    }

    /** The snooze alarm still owed after a reboot, or null when there is none. */
    fun pendingSnooze(context: Context, nowEpochMillis: Long): ScheduledAlarmData? {
        if (!isSnoozeUsed(context, nowEpochMillis)) return null
        val sp = prefs(context)
        val dueAt = sp.getLong(KEY_SNOOZE_DUE_AT, -1L)
        if (dueAt <= 0L) return null
        return ScheduledAlarmData(dueAt, sp.getBoolean(KEY_SNOOZE_IS_DRY_RUN, false))
    }

    fun isSnoozeUsed(context: Context, nowEpochMillis: Long): Boolean {
        val snoozedAt = prefs(context).getLong(KEY_SNOOZED_AT, -1L)
        return snoozedAt > 0L && nowEpochMillis - snoozedAt < SNOOZE_SESSION_MS
    }

    fun loadAlarm(context: Context): ScheduledAlarmData? {
        val sp = prefs(context)
        val scheduledAt = sp.getLong(KEY_SCHEDULED_AT, -1L)
        if (scheduledAt <= 0L) {
            return null
        }
        return ScheduledAlarmData(
            scheduledAtEpochMillis = scheduledAt,
            isDryRun = sp.getBoolean(KEY_IS_DRY_RUN, false),
        )
    }
}
