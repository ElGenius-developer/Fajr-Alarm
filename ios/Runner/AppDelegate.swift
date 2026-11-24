import Flutter
import UIKit
import Vision

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let alarmKitManager = AlarmKitManager()
  private let barcodeDecoderPlugin = BarcodeDecoderPlugin()

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
    if let barcodeRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "BarcodeDecoderPlugin") {
      let barcodeChannel = FlutterMethodChannel(
        name: BarcodeDecoderPlugin.channelName,
        binaryMessenger: barcodeRegistrar.messenger()
      )
      barcodeChannel.setMethodCallHandler { [weak self] call, result in
        self?.barcodeDecoderPlugin.handle(call, result: result)
      }
    }
  }
}

private final class BarcodeDecoderPlugin {
  static let channelName = "com.elgenius.fajralarm/barcode_decoder"
  private let decodeQueue = DispatchQueue(label: "com.elgenius.fajralarm.barcode_decoder", qos: .userInitiated)

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "decodeFrame" else {
      result(FlutterMethodNotImplemented)
      return
    }
    guard
      let args = call.arguments as? [String: Any],
      let typedBytes = args["bytes"] as? FlutterStandardTypedData,
      let width = args["width"] as? Int,
      let height = args["height"] as? Int,
      let bytesPerRow = args["bytesPerRow"] as? Int,
      width > 0,
      height > 0,
      bytesPerRow >= width * 4
    else {
      result(nil)
      return
    }

    let data = typedBytes.data
    let requiredBytes = bytesPerRow * (height - 1) + width * 4
    guard data.count >= requiredBytes else {
      result(nil)
      return
    }

    decodeQueue.async {
      let decoded = Self.decodeBGRA(data: data, width: width, height: height, bytesPerRow: bytesPerRow)
      DispatchQueue.main.async {
        result(decoded)
      }
    }
  }

  private static func decodeBGRA(data: Data, width: Int, height: Int, bytesPerRow: Int) -> String? {
    guard let provider = CGDataProvider(data: data as CFData) else {
      return nil
    }
    let bitmapInfo = CGBitmapInfo(
      rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
    )
    guard let cgImage = CGImage(
      width: width,
      height: height,
      bitsPerComponent: 8,
      bitsPerPixel: 32,
      bytesPerRow: bytesPerRow,
      space: CGColorSpaceCreateDeviceRGB(),
      bitmapInfo: bitmapInfo,
      provider: provider,
      decode: nil,
      shouldInterpolate: false,
      intent: .defaultIntent
    ) else {
      return nil
    }

    let request = VNDetectBarcodesRequest()
    let handler = VNImageRequestHandler(cgImage: cgImage, orientation: .right, options: [:])
    do {
      try handler.perform([request])
      guard let observations = request.results else {
        return nil
      }
      for observation in observations {
        if let value = observation.payloadStringValue?.trimmingCharacters(in: .whitespacesAndNewlines),
           !value.isEmpty {
          return value
        }
      }
      return nil
    } catch {
      return nil
    }
  }
}
