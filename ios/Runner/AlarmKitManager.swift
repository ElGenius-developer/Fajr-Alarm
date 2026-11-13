import AVFoundation
import Flutter
import Foundation

#if canImport(AppIntents)
import AppIntents
#endif

#if canImport(AlarmKit)
import AlarmKit
import SwiftUI
#endif

#if canImport(AppIntents) && canImport(AlarmKit)
@available(iOS 26.0, *)
struct OpenFajrChallengeIntent: LiveActivityIntent {
  static var title: LocalizedStringResource = "Open Fajr Challenge"
  static var openAppWhenRun: Bool = true

  @MainActor
  func perform() async throws -> some IntentResult {
    NotificationCenter.default.post(
      name: Notification.Name("com.elgenius.fajralarm.openChallenge"),
      object: nil
    )
    return .result()
  }
}

@available(iOS 26.0, *)
struct FajrAlarmMetadata: AlarmMetadata {}
#endif

/// Manages the `com.elgenius.fajralarm/alarm_platform` MethodChannel on iOS 26+
/// using Apple's `AlarmKit` Relentless Cascade ($T_0, T_0+5m, T_0+6m, \dots$).
final class AlarmKitManager {
  static let channelName = "com.elgenius.fajralarm/alarm_platform"
  private static let cascadeIdsDefaultsKey = "fajr_alarm_cascade_ids"

  /// Cascade offsets in seconds: T0, T0+5m, then every 1m up to T0+15m.
  private static let cascadeOffsetsSeconds: [TimeInterval] = [
    0, 300, 360, 420, 480, 540, 600, 660, 720, 780, 840, 900,
  ]

  private var audioPlayer: AVAudioPlayer?
  private var isMuted = false

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "scheduleAlarm":
      guard
        let args = call.arguments as? [String: Any],
        let epochMillis = args["scheduledAtEpochMillis"] as? NSNumber
      else {
        result(
          FlutterError(
            code: "INVALID_ARGS",
            message: "scheduledAtEpochMillis is required",
            details: nil
          )
        )
        return
      }
      let isDryRun = args["isDryRun"] as? Bool ?? false
      let scheduledDate = Date(timeIntervalSince1970: epochMillis.doubleValue / 1000.0)
      scheduleAlarmCascade(scheduledAt: scheduledDate, isDryRun: isDryRun, result: result)

    case "cancelAllAlarms":
      cancelAllAlarms(result: result)

    case "startRinging":
      startForegroundAudio()
      result(nil)

    case "stopRinging":
      stopForegroundAudio()
      result(nil)

    case "muteRingingAudio":
      isMuted = true
      audioPlayer?.volume = 0.0
      result(nil)

    case "unmuteRingingAudio":
      isMuted = false
      audioPlayer?.volume = 1.0
      result(nil)

    case "enableScreenPinning",
         "disableScreenPinning",
         "requestFullScreenIntentPermission",
         "requestIgnoreBatteryOptimizations":
      result(nil)

    case "canUseFullScreenIntent",
         "isIgnoringBatteryOptimizations":
      result(true)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func scheduleAlarmCascade(
    scheduledAt: Date,
    isDryRun: Bool,
    result: @escaping FlutterResult
  ) {
    #if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      Task {
        do {
          let authState = try await AlarmManager.shared.requestAuthorization()
          guard authState == .authorized else {
            await MainActor.run {
              result(
                FlutterError(
                  code: "PERMISSION_DENIED",
                  message: "AlarmKit authorization denied",
                  details: nil
                )
              )
            }
            return
          }

          await cancelStoredCascade()

          var scheduledIds: [String] = []
          for offset in Self.cascadeOffsetsSeconds {
            let fireDate = scheduledAt.addingTimeInterval(offset)
            let alarmId = UUID()
            let title = isDryRun
              ? LocalizedStringResource("Fajr Dry-Run Alarm")
              : LocalizedStringResource("Fajr Prayer Alarm")
            let alert = AlarmPresentation.Alert(
              title: title,
              stopButton: AlarmButton(
                text: LocalizedStringResource("Open Challenge"),
                textColor: .white,
                systemImageName: "camera.viewfinder"
              )
            )
            let attributes = AlarmAttributes<FajrAlarmMetadata>(
              presentation: AlarmPresentation(alert: alert),
              tintColor: .green
            )
            let config = AlarmManager.AlarmConfiguration(
              schedule: .fixed(fireDate),
              attributes: attributes,
              secondaryIntent: OpenFajrChallengeIntent()
            )
            _ = try await AlarmManager.shared.schedule(id: alarmId, configuration: config)
            scheduledIds.append(alarmId.uuidString)
          }

          UserDefaults.standard.set(scheduledIds, forKey: Self.cascadeIdsDefaultsKey)
          await MainActor.run {
            result(nil)
          }
        } catch {
          await MainActor.run {
            result(
              FlutterError(
                code: "ALARMKIT_ERROR",
                message: error.localizedDescription,
                details: nil
              )
            )
          }
        }
      }
      return
    }
    #endif

    result(
      FlutterError(
        code: "UNSUPPORTED_OS",
        message: "AlarmKit requires iOS 26.0 or newer",
        details: nil
      )
    )
  }

  private func cancelAllAlarms(result: @escaping FlutterResult) {
    stopForegroundAudio()
    #if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      Task {
        await cancelStoredCascade()
        await MainActor.run {
          result(nil)
        }
      }
      return
    }
    #endif
    result(nil)
  }

  #if canImport(AlarmKit)
  @available(iOS 26.0, *)
  private func cancelStoredCascade() async {
    let stored = UserDefaults.standard.stringArray(forKey: Self.cascadeIdsDefaultsKey) ?? []
    for rawId in stored {
      if let uuid = UUID(uuidString: rawId) {
        try? await AlarmManager.shared.cancel(id: uuid)
      }
    }
    UserDefaults.standard.removeObject(forKey: Self.cascadeIdsDefaultsKey)
  }
  #endif

  private func startForegroundAudio() {
    let session = AVAudioSession.sharedInstance()
    try? session.setCategory(.playback, mode: .default, options: [])
    try? session.setActive(true)
    isMuted = false
    audioPlayer?.volume = 1.0
    audioPlayer?.play()
  }

  private func stopForegroundAudio() {
    audioPlayer?.stop()
    isMuted = false
  }
}
