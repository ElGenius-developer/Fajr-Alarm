package com.elgenius.fajralarm.fajr_alarm

import android.app.Activity
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import android.view.KeyEvent
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setShowWhenLocked(true)
        setTurnScreenOn(true)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            AlarmPlatformPlugin.CHANNEL_NAME,
        ).setMethodCallHandler(AlarmPlatformPlugin(this))
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (AlarmForegroundService.isRinging && isVolumeHardwareKey(keyCode)) {
            if (!AlarmForegroundService.isMuted) {
                AlarmForegroundService.enforceMaxAlarmStreamVolume(applicationContext)
            }
            return true
        }
        return super.onKeyDown(keyCode, event)
    }

    private fun isVolumeHardwareKey(keyCode: Int): Boolean {
        return keyCode == KeyEvent.KEYCODE_VOLUME_DOWN ||
            keyCode == KeyEvent.KEYCODE_VOLUME_UP ||
            keyCode == KeyEvent.KEYCODE_VOLUME_MUTE
    }
}

/**
 * Handles MethodChannel calls for `com.elgenius.fajralarm/alarm_platform`.
 */
class AlarmPlatformPlugin(
    private val activity: Activity,
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "scheduleAlarm" -> handleScheduleAlarm(call, result)
            "cancelAllAlarms" -> {
                AlarmReceiver.cancelAllAlarms(activity.applicationContext)
                stopAlarmService()
                result.success(null)
            }
            "startRinging" -> {
                val isDryRun = call.argument<Boolean>("isDryRun") ?: false
                startAlarmService(isDryRun)
                result.success(null)
            }
            "stopRinging" -> {
                stopAlarmService()
                result.success(null)
            }
            "muteRingingAudio" -> {
                sendServiceAction(AlarmForegroundService.ACTION_MUTE)
                result.success(null)
            }
            "unmuteRingingAudio" -> {
                sendServiceAction(AlarmForegroundService.ACTION_UNMUTE)
                result.success(null)
            }
            "enableScreenPinning" -> {
                try {
                    activity.startLockTask()
                } catch (_: IllegalStateException) {
                } catch (_: SecurityException) {
                }
                result.success(null)
            }
            "disableScreenPinning" -> {
                try {
                    activity.stopLockTask()
                } catch (_: IllegalStateException) {
                } catch (_: SecurityException) {
                }
                result.success(null)
            }
            "canUseFullScreenIntent" -> {
                result.success(canUseFullScreenIntent())
            }
            "requestFullScreenIntentPermission" -> {
                requestFullScreenIntentPermission()
                result.success(null)
            }
            "isIgnoringBatteryOptimizations" -> {
                result.success(isIgnoringBatteryOptimizations())
            }
            "requestIgnoreBatteryOptimizations" -> {
                requestIgnoreBatteryOptimizations()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun handleScheduleAlarm(call: MethodCall, result: MethodChannel.Result) {
        val epochMillis = call.argument<Number>("scheduledAtEpochMillis")?.toLong()
        val isDryRun = call.argument<Boolean>("isDryRun") ?: false
        if (epochMillis == null) {
            result.error("INVALID_ARGS", "scheduledAtEpochMillis is required", null)
            return
        }
        try {
            AlarmReceiver.scheduleExactAlarm(
                context = activity.applicationContext,
                scheduledAtEpochMillis = epochMillis,
                isDryRun = isDryRun,
            )
            result.success(null)
        } catch (se: SecurityException) {
            result.error("PERMISSION_DENIED", se.message, null)
        }
    }

    private fun startAlarmService(isDryRun: Boolean) {
        val intent = Intent(activity, AlarmForegroundService::class.java).apply {
            action = AlarmForegroundService.ACTION_START
            putExtra(AlarmForegroundService.EXTRA_IS_DRY_RUN, isDryRun)
        }
        ContextCompat.startForegroundService(activity, intent)
    }

    private fun stopAlarmService() {
        val intent = Intent(activity, AlarmForegroundService::class.java).apply {
            action = AlarmForegroundService.ACTION_STOP
        }
        activity.startService(intent)
    }

    private fun sendServiceAction(action: String) {
        val intent = Intent(activity, AlarmForegroundService::class.java).apply {
            this.action = action
        }
        activity.startService(intent)
    }

    private fun canUseFullScreenIntent(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            return true
        }
        val manager = activity.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        return manager.canUseFullScreenIntent()
    }

    private fun requestFullScreenIntentPermission() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            return
        }
        val intent = Intent(
            Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT,
            Uri.parse("package:${activity.packageName}"),
        ).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        activity.startActivity(intent)
    }

    private fun isIgnoringBatteryOptimizations(): Boolean {
        val powerManager = activity.getSystemService(Context.POWER_SERVICE) as PowerManager
        return powerManager.isIgnoringBatteryOptimizations(activity.packageName)
    }

    private fun requestIgnoreBatteryOptimizations() {
        val intent = Intent(
            Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
            Uri.parse("package:${activity.packageName}"),
        ).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        activity.startActivity(intent)
    }

    companion object {
        const val CHANNEL_NAME = "com.elgenius.fajralarm/alarm_platform"
    }
}
