import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let alarmKitManager = AlarmKitManager()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AlarmPlatformPlugin") {
      let channel = FlutterMethodChannel(
        name: AlarmKitManager.channelName,
        binaryMessenger: registrar.messenger()
      )
      alarmKitManager.attachChannel(channel)
      channel.setMethodCallHandler { [weak self] call, result in
        self?.alarmKitManager.handle(call, result: result)
      }
    }
    if let permissionsRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "OnboardingPermissionsPlugin") {
      let permissionsChannel = FlutterMethodChannel(
        name: AlarmKitManager.permissionsChannelName,
        binaryMessenger: permissionsRegistrar.messenger()
      )
      permissionsChannel.setMethodCallHandler { [weak self] call, result in
        self?.alarmKitManager.handleOnboardingPermissions(call, result: result)
      }
    }
  }
}
