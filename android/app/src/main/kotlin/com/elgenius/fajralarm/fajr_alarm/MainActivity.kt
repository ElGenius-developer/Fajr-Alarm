package com.elgenius.fajralarm.fajr_alarm

import android.Manifest
import android.app.Activity
import android.app.AlarmManager
import android.app.NotificationManager
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import android.view.KeyEvent
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingPermissionResult: MethodChannel.Result? = null
    private var pendingAlarmTrigger: Map<String, Any>? = null
    private var alarmPlatformChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setShowWhenLocked(true)
        setTurnScreenOn(true)
        captureAlarmTrigger(intent, forwardImmediately = false)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        captureAlarmTrigger(intent, forwardImmediately = true)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            AlarmPlatformPlugin.CHANNEL_NAME,
        )
        alarmPlatformChannel = channel
        channel.setMethodCallHandler(
            AlarmPlatformPlugin(
                activity = this,
                consumePendingTrigger = {
                    val trigger = pendingAlarmTrigger
                    pendingAlarmTrigger = null
                    trigger ?: if (AlarmForegroundService.isRinging) {
                        mapOf("isDryRun" to AlarmForegroundService.currentIsDryRun)
                    } else {
                        null
                    }
                },
            ),
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            OnboardingPermissionsPlugin.CHANNEL_NAME,
        ).setMethodCallHandler(
            OnboardingPermissionsPlugin(
                activity = this,
                onRequestCameraPermission = { result ->
                    pendingPermissionResult?.error(
                        "CANCELLED",
                        "Replaced by newer permission request",
                        null,
                    )
                    pendingPermissionResult = result
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(Manifest.permission.CAMERA),
                        REQUEST_CODE_CAMERA,
                    )
                },
            ),
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CODE_CAMERA) {
            val result = pendingPermissionResult
            pendingPermissionResult = null
            result?.success(OnboardingPermissionsPlugin.buildStatusMap(this))
        }
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

    private fun captureAlarmTrigger(intent: Intent?, forwardImmediately: Boolean) {
        if (intent?.getBooleanExtra(AlarmForegroundService.EXTRA_ALARM_RINGING, false) != true) {
            return
        }
        val isDryRun = intent.getBooleanExtra(AlarmForegroundService.EXTRA_IS_DRY_RUN, false)
        intent.removeExtra(AlarmForegroundService.EXTRA_ALARM_RINGING)
        intent.removeExtra(AlarmForegroundService.EXTRA_IS_DRY_RUN)
        val payload = mapOf<String, Any>("isDryRun" to isDryRun)
        val channel = alarmPlatformChannel
        if (forwardImmediately && channel != null) {
            channel.invokeMethod("onAlarmTriggered", payload)
        } else {
            pendingAlarmTrigger = payload
        }
    }

    private fun isVolumeHardwareKey(keyCode: Int): Boolean {
        return keyCode == KeyEvent.KEYCODE_VOLUME_DOWN ||
            keyCode == KeyEvent.KEYCODE_VOLUME_UP ||
            keyCode == KeyEvent.KEYCODE_VOLUME_MUTE
    }

    companion object {
        private const val REQUEST_CODE_CAMERA = 4102
    }
}

/**
 * Handles MethodChannel calls for `com.elgenius.fajralarm/onboarding_permissions`.
 */
class OnboardingPermissionsPlugin(
    private val activity: Activity,
    private val onRequestCameraPermission: (MethodChannel.Result) -> Unit,
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkPermissions" -> result.success(buildStatusMap(activity))
            "requestPermissions" -> handleRequestPermissions(result)
            else -> result.notImplemented()
        }
    }

    private fun handleRequestPermissions(result: MethodChannel.Result) {
        if (!hasCameraPermission(activity)) {
            onRequestCameraPermission(result)
            return
        }
        if (!canUseFullScreenIntent(activity) && Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            launchPackageSettings(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT)
        } else if (!isIgnoringBatteryOptimizations(activity)) {
            launchPackageSettings(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
        } else if (!canScheduleExactAlarms(activity) && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            launchPackageSettings(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
        }
        result.success(buildStatusMap(activity))
    }

    private fun launchPackageSettings(action: String) {
        val intent = Intent(
            action,
            Uri.fromParts("package", activity.packageName, null),
        ).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        try {
            activity.startActivity(intent)
        } catch (_: ActivityNotFoundException) {
            // Device OEM does not expose the settings activity directly.
        }
    }

    companion object {
        const val CHANNEL_NAME = "com.elgenius.fajralarm/onboarding_permissions"

        fun buildStatusMap(context: Context): Map<String, Boolean> {
            return mapOf(
                "fullScreenIntentGranted" to canUseFullScreenIntent(context),
                "batteryOptimizationIgnored" to isIgnoringBatteryOptimizations(context),
                "cameraGranted" to hasCameraPermission(context),
                "alarmPermissionGranted" to canScheduleExactAlarms(context),
            )
        }

        private fun hasCameraPermission(context: Context): Boolean {
            return ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.CAMERA,
            ) == PackageManager.PERMISSION_GRANTED
        }

        private fun canUseFullScreenIntent(context: Context): Boolean {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                return true
            }
            val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            return manager.canUseFullScreenIntent()
        }

        private fun isIgnoringBatteryOptimizations(context: Context): Boolean {
            val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            return powerManager.isIgnoringBatteryOptimizations(context.packageName)
        }

        private fun canScheduleExactAlarms(context: Context): Boolean {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
                return true
            }
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            return alarmManager.canScheduleExactAlarms()
        }
    }
}

/**
 * Handles MethodChannel calls for `com.elgenius.fajralarm/alarm_platform`.
 */
class AlarmPlatformPlugin(
    private val activity: Activity,
    private val consumePendingTrigger: () -> Map<String, Any>?,
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
            "consumePendingAlarmTrigger" -> {
                result.success(consumePendingTrigger())
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
