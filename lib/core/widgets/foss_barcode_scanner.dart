import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fajr_alarm/core/barcode/barcode_decoder_data_source.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Controller for [FossBarcodeScanner] supporting torch toggling and cleanup.
final class FossBarcodeScannerController {
  CameraController? _cameraController;
  bool _isTorchOn = false;
  bool _disposed = false;

  /// Whether the camera flash torch is currently active.
  bool get isTorchOn => _isTorchOn;

  void _attach(CameraController controller) {
    if (_disposed) return;
    _cameraController = controller;
  }

  void _detach(CameraController controller) {
    if (identical(_cameraController, controller)) {
      _cameraController = null;
      _isTorchOn = false;
    }
  }

  /// Toggles the camera torch when the underlying camera is initialized.
  Future<void> toggleTorch() async {
    final CameraController? controller = _cameraController;
    if (_disposed || controller == null || !controller.value.isInitialized) {
      return;
    }
    final bool nextTorch = !_isTorchOn;
    try {
      await controller.setFlashMode(
        nextTorch ? FlashMode.torch : FlashMode.off,
      );
      _isTorchOn = nextTorch;
    } on CameraException {
      // Torch may be unsupported on some devices/emulators.
    }
  }

  /// Releases references held by this controller.
  void dispose() {
    _disposed = true;
    _cameraController = null;
    _isTorchOn = false;
  }
}

/// Pure-FOSS live barcode scanner widget backed by `camera` + native
/// ZXing (Android) / Apple Vision (iOS) decoding.
class FossBarcodeScanner extends StatefulWidget {
  const FossBarcodeScanner({
    super.key,
    required this.onDetect,
    this.controller,
    this.errorBuilder,
    this.dataSource,
    this.waitBeforeInit,
  });

  /// Called once a non-empty barcode payload is decoded from the camera stream.
  final ValueChanged<String> onDetect;

  /// Optional controller for toggling torch.
  final FossBarcodeScannerController? controller;

  /// Optional builder displayed when camera initialization fails.
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  /// Optional decoder data source override for testing.
  final BarcodeDecoderDataSource? dataSource;

  /// Optional future to await before acquiring the camera (e.g., after disposing
  /// a prior `CameraController`).
  final Future<void>? waitBeforeInit;

  @override
  State<FossBarcodeScanner> createState() => _FossBarcodeScannerState();
}

class _FossBarcodeScannerState extends State<FossBarcodeScanner> {
  static const Duration _minDecodeInterval = Duration(milliseconds: 150);

  late final BarcodeDecoderDataSource _dataSource =
      widget.dataSource ?? BarcodeDecoderDataSource();
  CameraController? _cameraController;
  Object? _initError;
  bool _cameraInitialized = false;
  bool _isDecoding = false;
  bool _hasDetected = false;
  bool _disposed = false;
  DateTime? _lastDecodeAttempt;

  @override
  void initState() {
    super.initState();
    unawaited(_initScanner());
  }

  Future<void> _initScanner() async {
    try {
      if (widget.waitBeforeInit != null) {
        await widget.waitBeforeInit;
      }
      if (_disposed) return;

      final List<CameraDescription> cameras = await availableCameras();
      if (_disposed) return;
      if (cameras.isEmpty) {
        throw CameraException('no_cameras', 'No cameras available.');
      }

      final CameraDescription backCamera = cameras.firstWhere(
        (CameraDescription c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final CameraController controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isIOS
            ? ImageFormatGroup.bgra8888
            : ImageFormatGroup.yuv420,
      );

      await controller.initialize();
      if (_disposed) {
        await controller.dispose();
        return;
      }

      widget.controller?._attach(controller);
      await controller.startImageStream(_onCameraImage);

      if (_disposed || !mounted) {
        widget.controller?._detach(controller);
        await _safeDisposeCamera(controller);
        return;
      }

      setState(() {
        _cameraController = controller;
        _cameraInitialized = true;
      });
    } on CameraException catch (error) {
      if (!_disposed && mounted) {
        setState(() => _initError = error);
      }
    } on MissingPluginException catch (error) {
      if (!_disposed && mounted) {
        setState(() => _initError = error);
      }
    }
  }

  void _onCameraImage(CameraImage image) {
    if (_disposed || _hasDetected || _isDecoding || image.planes.isEmpty) {
      return;
    }

    final DateTime now = DateTime.now();
    if (_lastDecodeAttempt != null &&
        now.difference(_lastDecodeAttempt!) < _minDecodeInterval) {
      return;
    }

    final Plane plane = image.planes.first;
    if (plane.bytes.isEmpty || image.width <= 0 || image.height <= 0) {
      return;
    }

    _isDecoding = true;
    _lastDecodeAttempt = now;
    final Uint8List bytes = Uint8List.fromList(plane.bytes);
    final int width = image.width;
    final int height = image.height;
    final int bytesPerRow = plane.bytesPerRow;
    final String format = Platform.isIOS ? 'bgra8888' : 'yuv420';

    unawaited(
      _decodeAndNotify(
        bytes: bytes,
        width: width,
        height: height,
        bytesPerRow: bytesPerRow,
        format: format,
      ),
    );
  }

  Future<void> _decodeAndNotify({
    required Uint8List bytes,
    required int width,
    required int height,
    required int bytesPerRow,
    required String format,
  }) async {
    try {
      final String? decoded = await _dataSource.decodeFrame(
        bytes: bytes,
        width: width,
        height: height,
        bytesPerRow: bytesPerRow,
        format: format,
      );
      if (!_disposed &&
          mounted &&
          !_hasDetected &&
          decoded != null &&
          decoded.trim().isNotEmpty) {
        _hasDetected = true;
        widget.onDetect(decoded.trim());
      }
    } finally {
      _isDecoding = false;
    }
  }

  Future<void> _safeDisposeCamera(CameraController? controller) async {
    if (controller == null) return;
    widget.controller?._detach(controller);
    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
    } on CameraException {
      // Ignore stream stop failures during teardown.
    }
    try {
      await controller.dispose();
    } on CameraException {
      // Ignore dispose failures during teardown.
    }
  }

  @override
  void dispose() {
    _disposed = true;
    final CameraController? controller = _cameraController;
    _cameraController = null;
    unawaited(_safeDisposeCamera(controller));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initError != null) {
      return widget.errorBuilder?.call(context, _initError!) ??
          const SizedBox.shrink();
    }
    if (!_cameraInitialized || _cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return CameraPreview(_cameraController!);
  }
}
