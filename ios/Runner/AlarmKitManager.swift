import AVFoundation
import Flutter
import Foundation
import UIKit

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
  static var supportedModes: IntentModes = .foreground(.immediate)

  @MainActor
  func perform() async throws -> some IntentResult {
    UserDefaults.standard.set(true, forKey: AlarmKitManager.pendingTriggerDefaultsKey)
    NotificationCenter.default.post(
      name: AlarmKitManager.openChallengeNotificationName,
      object: nil
    )
    return .result()
  }
}

@available(iOS 26.0, *)
struct FajrAlarmMetadata: AlarmMetadata {}
#endif

/// Manages the `com.elgenius.fajralarm/alarm_platform` and
/// `com.elgenius.fajralarm/onboarding_permissions` MethodChannels on iOS 26+
/// using Apple's `AlarmKit` Relentless Cascade ($T_0, T_0+5m, T_0+6m, \dots$).
final class AlarmKitManager {
  static let channelName = "com.elgenius.fajralarm/alarm_platform"
  static let permissionsChannelName = "com.elgenius.fajralarm/onboarding_permissions"
  static let pendingTriggerDefaultsKey = "fajr_alarm_pending_trigger"
  static let openChallengeNotificationName = Notification.Name(
    "com.elgenius.fajralarm.openChallenge"
  )

  private static let cascadeIdsDefaultsKey = "fajr_alarm_cascade_ids"
  private static let lastDryRunDefaultsKey = "fajr_alarm_last_is_dry_run"

  /// Cascade offsets in seconds: T0, T0+5m, then every 1m up to T0+15m.
  private static let cascadeOffsetsSeconds: [TimeInterval] = [
    0, 300, 360, 420, 480, 540, 600, 660, 720, 780, 840, 900,
  ]

  private var audioPlayer: AVAudioPlayer?
  private var isMuted = false
  private var isRinging = false
  private weak var methodChannel: FlutterMethodChannel?
  private var pendingTrigger: [String: Any]?
  private var handledAlertingAlarmIds: Set<UUID> = []
  private var alarmUpdatesTask: Task<Void, Never>?
  private var openChallengeObserver: NSObjectProtocol?
  private var didBecomeActiveObserver: NSObjectProtocol?
  private var audioInterruptionObserver: NSObjectProtocol?

  init() {
    openChallengeObserver = NotificationCenter.default.addObserver(
      forName: Self.openChallengeNotificationName,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      self?.handleOpenChallengeNotification()
    }

    didBecomeActiveObserver = NotificationCenter.default.addObserver(
      forName: UIApplication.didBecomeActiveNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      self?.deliverPendingTriggerIfActive()
    }

    audioInterruptionObserver = NotificationCenter.default.addObserver(
      forName: AVAudioSession.interruptionNotification,
      object: nil,
      queue: .main
    ) { [weak self] notification in
      self?.handleAudioSessionInterruption(notification)
    }

    #if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      alarmUpdatesTask = Task { @MainActor [weak self] in
        for await alarms in AlarmManager.shared.alarmUpdates {
          guard let self, !Task.isCancelled else { break }
          self.handleAlarmUpdates(alarms)
        }
      }
    }
    #endif
  }

  deinit {
    alarmUpdatesTask?.cancel()
    if let observer = openChallengeObserver {
      NotificationCenter.default.removeObserver(observer)
    }
    if let observer = didBecomeActiveObserver {
      NotificationCenter.default.removeObserver(observer)
    }
    if let observer = audioInterruptionObserver {
      NotificationCenter.default.removeObserver(observer)
    }
  }

  func attachChannel(_ channel: FlutterMethodChannel) {
    methodChannel = channel
    deliverPendingTriggerIfActive()
  }

  private func handleOpenChallengeNotification() {
    UserDefaults.standard.set(true, forKey: Self.pendingTriggerDefaultsKey)
    let isDryRun = UserDefaults.standard.bool(forKey: Self.lastDryRunDefaultsKey)
    pendingTrigger = ["isDryRun": isDryRun]
    if UIApplication.shared.applicationState == .active && methodChannel != nil {
      deliverPendingTriggerIfActive()
    }
  }

  #if canImport(AlarmKit)
  @available(iOS 26.0, *)
  @MainActor
  private func handleAlarmUpdates(_ alarms: [Alarm]) {
    let newlyAlerting = alarms.filter {
      $0.state == .alerting && !handledAlertingAlarmIds.contains($0.id)
    }
    guard !newlyAlerting.isEmpty else {
      return
    }
    for alarm in newlyAlerting {
      handledAlertingAlarmIds.insert(alarm.id)
    }
    UserDefaults.standard.set(true, forKey: Self.pendingTriggerDefaultsKey)
    if UIApplication.shared.applicationState == .active {
      for alarm in newlyAlerting {
        try? AlarmManager.shared.stop(id: alarm.id)
      }
      deliverPendingTriggerIfActive()
    }
  }

  @available(iOS 26.0, *)
  private func stopCurrentlyAlertingAlarms() -> Bool {
    let alarms = (try? AlarmManager.shared.alarms) ?? []
    var foundAlerting = false
    for alarm in alarms where alarm.state == .alerting {
      foundAlerting = true
      handledAlertingAlarmIds.insert(alarm.id)
      try? AlarmManager.shared.stop(id: alarm.id)
    }
    return foundAlerting
  }
  #endif

  private func takePendingTriggerPayload() -> [String: Any]? {
    let hadPendingFlag = UserDefaults.standard.bool(forKey: Self.pendingTriggerDefaultsKey)
    let hadInMemoryTrigger = pendingTrigger != nil
    var hadAlertingAlarm = false
    #if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      hadAlertingAlarm = stopCurrentlyAlertingAlarms()
    }
    #endif
    guard hadPendingFlag || hadInMemoryTrigger || hadAlertingAlarm else {
      return nil
    }
    pendingTrigger = nil
    UserDefaults.standard.set(false, forKey: Self.pendingTriggerDefaultsKey)
    let isDryRun = UserDefaults.standard.bool(forKey: Self.lastDryRunDefaultsKey)
    return ["isDryRun": isDryRun]
  }

  private func deliverPendingTriggerIfActive() {
    guard
      UIApplication.shared.applicationState == .active,
      let channel = methodChannel,
      let payload = takePendingTriggerPayload()
    else {
      return
    }
    channel.invokeMethod("onAlarmTriggered", arguments: payload) { [weak self] callbackResult in
      if let callbackResult,
         !(callbackResult is NSNull),
         !(callbackResult is FlutterError) {
        self?.pendingTrigger = payload
        UserDefaults.standard.set(true, forKey: Self.pendingTriggerDefaultsKey)
      }
    }
  }

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
      if isRinging && audioPlayer?.isPlaying != true {
        audioPlayer?.play()
      }
      result(nil)

    case "enableScreenPinning",
         "disableScreenPinning",
         "requestFullScreenIntentPermission",
         "requestIgnoreBatteryOptimizations":
      result(nil)

    case "canUseFullScreenIntent",
         "isIgnoringBatteryOptimizations":
      result(true)

    case "consumePendingAlarmTrigger":
      result(takePendingTriggerPayload())

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private static func isArabicPreferredLanguage() -> Bool {
    Locale.preferredLanguages.first?.hasPrefix("ar") == true
  }

  private static func localizedAlarmTitle(isDryRun: Bool) -> String {
    if isArabicPreferredLanguage() {
      return isDryRun ? "منبه الفجر التجريبي" : "منبه صلاة الفجر"
    }
    return isDryRun ? "Fajr Dry-Run Alarm" : "Fajr Prayer Alarm"
  }

  private static func localizedChallengeButtonTitle() -> String {
    isArabicPreferredLanguage() ? "بدء التحدي" : "Open Challenge"
  }

  private func scheduleAlarmCascade(
    scheduledAt: Date,
    isDryRun: Bool,
    result: @escaping FlutterResult
  ) {
    #if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      Task { @MainActor [weak self] in
        guard let self else { return }
        do {
          let authState = try await AlarmManager.shared.requestAuthorization()
          guard authState == .authorized else {
            result(
              FlutterError(
                code: "PERMISSION_DENIED",
                message: "AlarmKit authorization denied",
                details: nil
              )
            )
            return
          }

          self.cancelStoredCascade()
          UserDefaults.standard.set(isDryRun, forKey: Self.lastDryRunDefaultsKey)

          var scheduledIds: [String] = []
          let title = LocalizedStringResource(
            stringLiteral: Self.localizedAlarmTitle(isDryRun: isDryRun)
          )
          let challengeButton = AlarmButton(
            text: LocalizedStringResource(
              stringLiteral: Self.localizedChallengeButtonTitle()
            ),
            textColor: .white,
            systemImageName: "camera.viewfinder"
          )

          for offset in Self.cascadeOffsetsSeconds {
            let fireDate = scheduledAt.addingTimeInterval(offset)
            let alarmId = UUID()
            let alert: AlarmPresentation.Alert
            if #available(iOS 26.1, *) {
              alert = AlarmPresentation.Alert(
                title: title,
                secondaryButton: challengeButton,
                secondaryButtonBehavior: .custom
              )
            } else {
              alert = AlarmPresentation.Alert(
                title: title,
                stopButton: challengeButton,
                secondaryButton: challengeButton,
                secondaryButtonBehavior: .custom
              )
            }
            let attributes = AlarmAttributes<FajrAlarmMetadata>(
              presentation: AlarmPresentation(alert: alert),
              tintColor: .green
            )
            let config = AlarmManager.AlarmConfiguration(
              schedule: .fixed(fireDate),
              attributes: attributes,
              stopIntent: OpenFajrChallengeIntent(),
              secondaryIntent: OpenFajrChallengeIntent()
            )
            _ = try await AlarmManager.shared.schedule(id: alarmId, configuration: config)
            scheduledIds.append(alarmId.uuidString)
          }

          UserDefaults.standard.set(scheduledIds, forKey: Self.cascadeIdsDefaultsKey)
          result(nil)
        } catch {
          result(
            FlutterError(
              code: "ALARMKIT_ERROR",
              message: error.localizedDescription,
              details: nil
            )
          )
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
      cancelStoredCascade()
      result(nil)
      return
    }
    #endif
    result(nil)
  }

  #if canImport(AlarmKit)
  @available(iOS 26.0, *)
  private func cancelStoredCascade() {
    let stored = UserDefaults.standard.stringArray(forKey: Self.cascadeIdsDefaultsKey) ?? []
    for rawId in stored {
      if let uuid = UUID(uuidString: rawId) {
        try? AlarmManager.shared.stop(id: uuid)
        try? AlarmManager.shared.cancel(id: uuid)
      }
    }
    let activeAlarms = (try? AlarmManager.shared.alarms) ?? []
    for alarm in activeAlarms {
      try? AlarmManager.shared.stop(id: alarm.id)
      try? AlarmManager.shared.cancel(id: alarm.id)
    }
    UserDefaults.standard.removeObject(forKey: Self.cascadeIdsDefaultsKey)
    UserDefaults.standard.removeObject(forKey: Self.pendingTriggerDefaultsKey)
    pendingTrigger = nil
    handledAlertingAlarmIds.removeAll()
  }
  #endif

  private func startForegroundAudio() {
    isRinging = true
    isMuted = false
    configurePlaybackSession()

    if audioPlayer == nil {
      let wavData = Self.makeAlarmToneWavData()
      if let player = try? AVAudioPlayer(data: wavData, fileTypeHint: AVFileType.wav.rawValue) {
        player.numberOfLoops = -1
        audioPlayer = player
      }
    }

    guard let player = audioPlayer else {
      return
    }
    player.volume = 1.0
    player.prepareToPlay()
    if !player.isPlaying {
      player.currentTime = 0
      player.play()
    }
  }

  private func stopForegroundAudio() {
    isRinging = false
    isMuted = false
    audioPlayer?.stop()
    audioPlayer?.currentTime = 0
  }

  private func configurePlaybackSession() {
    let session = AVAudioSession.sharedInstance()
    try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
    try? session.setActive(true)
  }

  private func handleAudioSessionInterruption(_ notification: Notification) {
    guard
      isRinging,
      let userInfo = notification.userInfo,
      let rawType = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
      let interruptionType = AVAudioSession.InterruptionType(rawValue: rawType),
      interruptionType == .ended
    else {
      return
    }
    configurePlaybackSession()
    audioPlayer?.volume = isMuted ? 0.0 : 1.0
    if audioPlayer?.isPlaying != true {
      audioPlayer?.play()
    }
  }

  private static func makeAlarmToneWavData() -> Data {
    let sampleRate: UInt32 = 44_100
    let durationSeconds = 2.0
    let totalSamples = Int(Double(sampleRate) * durationSeconds)
    let numChannels: UInt16 = 1
    let bitsPerSample: UInt16 = 16
    let bytesPerSample = Int(bitsPerSample / 8)
    let dataSize = UInt32(totalSamples * bytesPerSample)
    let riffChunkSize = UInt32(36) + dataSize
    let byteRate = sampleRate * UInt32(numChannels) * UInt32(bytesPerSample)
    let blockAlign = numChannels * UInt16(bytesPerSample)

    var data = Data()
    data.reserveCapacity(44 + Int(dataSize))

    func appendLittleEndian<T: FixedWidthInteger>(_ value: T) {
      var little = value.littleEndian
      withUnsafeBytes(of: &little) { data.append(contentsOf: $0) }
    }

    data.append(contentsOf: [0x52, 0x49, 0x46, 0x46]) // RIFF
    appendLittleEndian(riffChunkSize)
    data.append(contentsOf: [0x57, 0x41, 0x56, 0x45]) // WAVE
    data.append(contentsOf: [0x66, 0x6D, 0x74, 0x20]) // fmt 
    appendLittleEndian(UInt32(16))
    appendLittleEndian(UInt16(1))
    appendLittleEndian(numChannels)
    appendLittleEndian(sampleRate)
    appendLittleEndian(byteRate)
    appendLittleEndian(blockAlign)
    appendLittleEndian(bitsPerSample)
    data.append(contentsOf: [0x64, 0x61, 0x74, 0x61]) // data
    appendLittleEndian(dataSize)

    let slotDuration = 0.5
    let pulseDuration = 0.35
    let fadeDuration = 0.01
    let maxAmplitude = 0.85

    for i in 0..<totalSamples {
      let time = Double(i) / Double(sampleRate)
      let slotIndex = Int(time / slotDuration)
      let slotTime = time - Double(slotIndex) * slotDuration

      let int16Sample: Int16
      if slotTime < pulseDuration {
        let frequency = (slotIndex % 2 == 0) ? 880.0 : 1174.66
        let envelope: Double
        if slotTime < fadeDuration {
          envelope = slotTime / fadeDuration
        } else if slotTime > pulseDuration - fadeDuration {
          envelope = max(0.0, (pulseDuration - slotTime) / fadeDuration)
        } else {
          envelope = 1.0
        }
        let sampleValue = sin(2.0 * Double.pi * frequency * time) * maxAmplitude * envelope
        int16Sample = Int16(max(-1.0, min(1.0, sampleValue)) * Double(Int16.max))
      } else {
        int16Sample = 0
      }
      appendLittleEndian(int16Sample)
    }

    return data
  }

  func handleOnboardingPermissions(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "checkPermissions":
      result(currentPermissionsStatus())

    case "requestPermissions":
      Task {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraStatus == .notDetermined {
          _ = await AVCaptureDevice.requestAccess(for: .video)
        }
        var shouldOpenSettings =
          AVCaptureDevice.authorizationStatus(for: .video) == .denied
        #if canImport(AlarmKit)
        if #available(iOS 26.0, *) {
          let state = AlarmManager.shared.authorizationState
          if state == .notDetermined {
            _ = try? await AlarmManager.shared.requestAuthorization()
          }
          if AlarmManager.shared.authorizationState == .denied {
            shouldOpenSettings = true
          }
        }
        #endif
        if shouldOpenSettings {
          await MainActor.run {
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(settingsUrl)
            }
          }
        }
        let updated = currentPermissionsStatus()
        await MainActor.run {
          result(updated)
        }
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func currentPermissionsStatus() -> [String: Bool] {
    let cameraGranted = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    var alarmGranted = false
    #if canImport(AlarmKit)
    if #available(iOS 26.0, *) {
      alarmGranted = AlarmManager.shared.authorizationState == .authorized
    }
    #endif
    return [
      "fullScreenIntentGranted": true,
      "batteryOptimizationIgnored": true,
      "cameraGranted": cameraGranted,
      "alarmPermissionGranted": alarmGranted,
    ]
  }
}
