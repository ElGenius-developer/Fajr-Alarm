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
