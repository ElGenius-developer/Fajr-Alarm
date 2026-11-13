package com.elgenius.fajralarm.fajr_alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Restores the exact alarm schedule after a device reboot, including before lock-screen
 * unlock via `LOCKED_BOOT_COMPLETED` and `deviceProtectedStorage`.
 */
class DirectBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        if (action != Intent.ACTION_LOCKED_BOOT_COMPLETED &&
            action != Intent.ACTION_BOOT_COMPLETED
        ) {
            return
        }

        val saved = AlarmStorage.loadAlarm(context) ?: return
        val now = System.currentTimeMillis()
        // Re-schedule via AlarmManager instead of starting ForegroundService from BOOT_COMPLETED.
        val triggerAt = if (saved.scheduledAtEpochMillis > now) {
            saved.scheduledAtEpochMillis
        } else {
            now + 1_000L
        }
        AlarmReceiver.scheduleExactAlarm(
            context = context,
            scheduledAtEpochMillis = triggerAt,
            isDryRun = saved.isDryRun,
        )
    }
}
