package com.elgenius.fajralarm.fajr_alarm

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import androidx.core.app.NotificationCompat

class AlarmForegroundService : Service() {
    private var mediaPlayer: MediaPlayer? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private val handler = Handler(Looper.getMainLooper())
    private var currentVolumeScale = CRESCENDO_START_SCALE
    private var isDryRun = false

    private val volumeEnforcerRunnable = object : Runnable {
        override fun run() {
            if (!isRinging) return
            if (!isMuted) {
                enforceMaxAlarmStreamVolume(applicationContext)
                if (currentVolumeScale < 1.0f) {
                    currentVolumeScale = (currentVolumeScale + CRESCENDO_STEP).coerceAtMost(1.0f)
                    mediaPlayer?.setVolume(currentVolumeScale, currentVolumeScale)
                }
            }
            handler.postDelayed(this, VOLUME_ENFORCE_INTERVAL_MS)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP -> {
                stopAlarmAndSelf()
                return START_NOT_STICKY
            }
            ACTION_MUTE -> {
                isMuted = true
                mediaPlayer?.setVolume(0f, 0f)
                return START_STICKY
            }
            ACTION_UNMUTE -> {
                isMuted = false
                enforceMaxAlarmStreamVolume(applicationContext)
                mediaPlayer?.setVolume(currentVolumeScale, currentVolumeScale)
                return START_STICKY
            }
            else -> {
                isDryRun = intent?.getBooleanExtra(EXTRA_IS_DRY_RUN, false) ?: false
                startAlarmForeground()
                return START_STICKY
            }
        }
    }

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        if (isRinging) {
            val relaunchIntent = buildChallengeIntent(applicationContext, isDryRun)
            startActivity(relaunchIntent)
        }
    }

    override fun onDestroy() {
        cleanup()
        super.onDestroy()
    }

    private fun startAlarmForeground() {
        isRinging = true
        currentIsDryRun = isDryRun
        isMuted = false
        currentVolumeScale = CRESCENDO_START_SCALE

        acquireWakeLock()
        createNotificationChannel()
        val notification = buildAlarmNotification()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK,
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }

        startCrescendoPlayback()
        handler.removeCallbacks(volumeEnforcerRunnable)
        handler.post(volumeEnforcerRunnable)
    }

    private fun stopAlarmAndSelf() {
        cleanup()
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    private fun cleanup() {
        isRinging = false
        isMuted = false
        handler.removeCallbacks(volumeEnforcerRunnable)
        try {
            mediaPlayer?.stop()
        } catch (_: IllegalStateException) {
        }
        mediaPlayer?.release()
        mediaPlayer = null
        if (wakeLock?.isHeld == true) {
            wakeLock?.release()
        }
        wakeLock = null
    }

    private fun acquireWakeLock() {
        if (wakeLock?.isHeld == true) return
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "FajrAlarm::AlarmRingWakeLock",
        ).apply {
            acquire(WAKE_LOCK_TIMEOUT_MS)
        }
    }

    private fun startCrescendoPlayback() {
        mediaPlayer?.release()
        val alarmUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)

        enforceMaxAlarmStreamVolume(applicationContext)

        mediaPlayer = MediaPlayer().apply {
            setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build(),
            )
            setDataSource(applicationContext, alarmUri)
            isLooping = true
            setVolume(currentVolumeScale, currentVolumeScale)
            prepare()
            start()
        }
    }

    private fun createNotificationChannel() {
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channel = NotificationChannel(
            CHANNEL_ID,
            CHANNEL_NAME,
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            setSound(null, null)
            enableVibration(true)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
        }
        manager.createNotificationChannel(channel)
    }

    private fun buildAlarmNotification(): Notification {
        val fullScreenIntent = buildChallengeIntent(applicationContext, isDryRun)
        val fullScreenPendingIntent = PendingIntent.getActivity(
            this,
            REQUEST_CODE_FULL_SCREEN,
            fullScreenIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Fajr Alarm")
            .setContentText("Wake up and verify standing on your prayer rug")
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setAutoCancel(false)
            .setFullScreenIntent(fullScreenPendingIntent, true)
            .setContentIntent(fullScreenPendingIntent)
            .build()
    }

    companion object {
        const val ACTION_START = "com.elgenius.fajralarm.action.START_ALARM"
        const val ACTION_STOP = "com.elgenius.fajralarm.action.STOP_ALARM"
        const val ACTION_MUTE = "com.elgenius.fajralarm.action.MUTE_ALARM"
        const val ACTION_UNMUTE = "com.elgenius.fajralarm.action.UNMUTE_ALARM"
        const val EXTRA_IS_DRY_RUN = "extra_is_dry_run"
        const val EXTRA_ALARM_RINGING = "extra_alarm_ringing"

        private const val CHANNEL_ID = "fajr_alarm_ringing_channel"
        private const val CHANNEL_NAME = "Fajr Alarm Ringing"
        private const val NOTIFICATION_ID = 4001
        private const val REQUEST_CODE_FULL_SCREEN = 4002
        private const val VOLUME_ENFORCE_INTERVAL_MS = 1_000L
        private const val WAKE_LOCK_TIMEOUT_MS = 10 * 60 * 1_000L
        private const val CRESCENDO_START_SCALE = 0.15f
        private const val CRESCENDO_STEP = 0.10f

        @Volatile
        var isRinging: Boolean = false
            private set

        @Volatile
        var currentIsDryRun: Boolean = false
            private set

        @Volatile
        var isMuted: Boolean = false
            private set

        fun enforceMaxAlarmStreamVolume(context: Context) {
            val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
            val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_ALARM)
            val currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_ALARM)
            if (currentVolume < maxVolume) {
                audioManager.setStreamVolume(AudioManager.STREAM_ALARM, maxVolume, 0)
            }
        }

        fun buildChallengeIntent(context: Context, isDryRun: Boolean): Intent {
            return Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP
                putExtra(EXTRA_ALARM_RINGING, true)
                putExtra(EXTRA_IS_DRY_RUN, isDryRun)
            }
        }
    }
}
