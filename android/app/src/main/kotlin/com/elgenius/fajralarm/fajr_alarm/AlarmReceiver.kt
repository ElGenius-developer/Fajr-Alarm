package com.elgenius.fajralarm.fajr_alarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val isDryRun = intent.getBooleanExtra(EXTRA_IS_DRY_RUN, false)
        val serviceIntent = Intent(context, AlarmForegroundService::class.java).apply {
            action = AlarmForegroundService.ACTION_START
            putExtra(AlarmForegroundService.EXTRA_IS_DRY_RUN, isDryRun)
        }
        ContextCompat.startForegroundService(context, serviceIntent)
    }

    companion object {
        private const val REQUEST_CODE_ALARM = 1001
        private const val REQUEST_CODE_SHOW = 1002
        const val EXTRA_IS_DRY_RUN = "extra_is_dry_run"

        fun scheduleExactAlarm(
            context: Context,
            scheduledAtEpochMillis: Long,
            isDryRun: Boolean,
        ) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val triggerIntent = Intent(context, AlarmReceiver::class.java).apply {
                putExtra(EXTRA_IS_DRY_RUN, isDryRun)
            }
            val triggerPendingIntent = PendingIntent.getBroadcast(
                context,
                REQUEST_CODE_ALARM,
                triggerIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            val showIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
            val showPendingIntent = PendingIntent.getActivity(
                context,
                REQUEST_CODE_SHOW,
                showIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )

            val alarmClockInfo = AlarmManager.AlarmClockInfo(
                scheduledAtEpochMillis,
                showPendingIntent,
            )
            alarmManager.setAlarmClock(alarmClockInfo, triggerPendingIntent)
            AlarmStorage.saveAlarm(context, scheduledAtEpochMillis, isDryRun)
        }

        fun cancelAllAlarms(context: Context) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val triggerIntent = Intent(context, AlarmReceiver::class.java)
            val triggerPendingIntent = PendingIntent.getBroadcast(
                context,
                REQUEST_CODE_ALARM,
                triggerIntent,
                PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE,
            )
            if (triggerPendingIntent != null) {
                alarmManager.cancel(triggerPendingIntent)
                triggerPendingIntent.cancel()
            }
            AlarmStorage.clearAlarm(context)
        }
    }
}
