import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/challenge_mode.dart';
import 'package:fajr_alarm/features/challenge_verification/domain/entities/tilt_angle_reading.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/cubit/challenge_cubit.dart';
import 'package:fajr_alarm/features/challenge_verification/presentation/cubit/challenge_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Proof-of-Action challenge screen supporting Live Prayer-Rug Photo Vision,
/// Bathroom Barcode Challenge, and Standing Typing Challenge.
class ChallengePage extends StatefulWidget {
  const ChallengePage({
    super.key,
    this.onChallengeCompleted,
    this.cameraPreviewOverride,
    this.scannerOverride,
    this.onCapturePhotoOverride,
  });

  /// Invoked when any challenge mode reaches [ChallengeStatus.verified].
  final VoidCallback? onChallengeCompleted;

  /// Optional override for widget tests without hardware camera.
  final Widget? cameraPreviewOverride;

  /// Optional override for widget tests without hardware barcode scanner.
  final Widget? scannerOverride;

  /// Optional override for capturing photo bytes in widget tests.
  final Future<Uint8List> Function()? onCapturePhotoOverride;

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  CameraController? _cameraController;
  MobileScannerController? _scannerController;
  bool _cameraInitialized = false;

  @override
  void initState() {
    super.initState();
    final ChallengeCubit cubit = context.read<ChallengeCubit>();
    cubit.startTiltMonitoring();
    if (widget.cameraPreviewOverride == null) {
      _initCamera();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    context.read<ChallengeCubit>().setTypingPrompt(l10n.challengeAdhkarPrompt);
  }

  Future<void> _initCamera() async {
    try {
      final List<CameraDescription> cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          await context.read<ChallengeCubit>().reportCameraUnavailable();
        }
        return;
      }

      final CameraDescription backCamera = cameras.firstWhere(
        (CameraDescription c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final CameraController controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _cameraInitialized = true;
      });
    } on CameraException {
      if (mounted) {
        await context.read<ChallengeCubit>().reportCameraUnavailable();
      }
    }
  }

  Future<void> _toggleTorch(ChallengeState state) async {
    final ChallengeCubit cubit = context.read<ChallengeCubit>();
    cubit.toggleTorch();
    final bool nextTorch = !state.isTorchOn;

    if (state.mode == ChallengeMode.photoVision && _cameraController != null) {
      await _cameraController!.setFlashMode(
        nextTorch ? FlashMode.torch : FlashMode.off,
      );
    } else if (state.mode == ChallengeMode.bathroomBarcode &&
        _scannerController != null) {
      await _scannerController!.toggleTorch();
    }
  }

  Future<void> _captureAndSubmitPhoto() async {
    final ChallengeCubit cubit = context.read<ChallengeCubit>();
    final String localeCode = Localizations.localeOf(context).languageCode;

    if (widget.onCapturePhotoOverride != null) {
      final Uint8List bytes = await widget.onCapturePhotoOverride!();
      await cubit.submitPhoto(imageBytes: bytes, localeCode: localeCode);
      return;
    }

    final CameraController? controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      await cubit.reportCameraUnavailable();
      return;
    }

    try {
      final XFile file = await controller.takePicture();
      final Uint8List bytes;
      try {
        bytes = await file.readAsBytes();
      } finally {
        final File tempFile = File(file.path);
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      }
      await cubit.submitPhoto(imageBytes: bytes, localeCode: localeCode);
    } on CameraException {
      await cubit.reportCameraUnavailable();
    }
  }

  Future<void> _disposePhotoCamera({bool updateUi = true}) async {
    final CameraController? controller = _cameraController;
    _cameraController = null;
    if (updateUi && mounted && _cameraInitialized) {
      setState(() => _cameraInitialized = false);
    } else {
      _cameraInitialized = false;
    }
    await controller?.dispose();
  }

  @override
  void dispose() {
    unawaited(_disposePhotoCamera(updateUi: false));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ChallengeCubit, ChallengeState>(
      listener: (BuildContext context, ChallengeState state) {
        if (state.mode != ChallengeMode.photoVision &&
            _cameraController != null) {
          unawaited(_disposePhotoCamera());
        }
        if (state.status == ChallengeStatus.verified) {
          widget.onChallengeCompleted?.call();
        }
      },
      builder: (BuildContext context, ChallengeState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.challengeTitle),
            actions: <Widget>[
              if (state.mode != ChallengeMode.standingTyping)
                IconButton(
                  tooltip: l10n.challengeToggleTorch,
                  icon: Icon(
                    state.isTorchOn ? Icons.flash_on : Icons.flash_off,
                  ),
                  onPressed: () => _toggleTorch(state),
                ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (state.status == ChallengeStatus.fallbackTriggered)
                    _BannerMessage(
                      message: state.isCameraAvailable
                          ? l10n.challengeOfflineFallbackNotice
                          : l10n.challengeCameraUnavailable,
                      accentColor: FajrDesignTokens.of(context).dawnAccent,
                    ),
                  if (state.status == ChallengeStatus.rejected)
                    _BannerMessage(
                      message: _resolveRejectionMessage(l10n, state),
                      accentColor: FajrDesignTokens.of(context).clayError,
                    ),
                  if (state.status == ChallengeStatus.verified)
                    _BannerMessage(
                      message: l10n.challengeVerifiedSuccess,
                      accentColor: FajrDesignTokens.of(context).emeraldSignal,
                    ),
                  Expanded(
                    child: switch (state.mode) {
                      ChallengeMode.photoVision => _PhotoVisionView(
                        l10n: l10n,
                        state: state,
                        cameraController: _cameraController,
                        cameraInitialized: _cameraInitialized,
                        cameraPreviewOverride: widget.cameraPreviewOverride,
                        onCapture: _captureAndSubmitPhoto,
                      ),
                      ChallengeMode.bathroomBarcode => _BathroomBarcodeView(
                        l10n: l10n,
                        state: state,
                        scannerOverride: widget.scannerOverride,
                        onControllerCreated: (MobileScannerController? ctrl) {
                          _scannerController = ctrl;
                        },
                        onBarcodeDetected: (String code) {
                          context.read<ChallengeCubit>().submitBarcode(code);
                        },
                      ),
                      ChallengeMode.standingTyping => _StandingTypingView(
                        l10n: l10n,
                        state: state,
                      ),
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _resolveRejectionMessage(AppLocalizations l10n, ChallengeState state) {
    final String? custom = state.rejectionMessage;
    if (custom != null && custom.trim().isNotEmpty) {
      return custom;
    }
    return switch (state.mode) {
      ChallengeMode.photoVision => l10n.challengeRejectedDefault,
      ChallengeMode.bathroomBarcode => l10n.challengeBarcodeMismatch,
      ChallengeMode.standingTyping => l10n.challengeTypingMismatch,
    };
  }
}

class _BannerMessage extends StatelessWidget {
  const _BannerMessage({required this.message, required this.accentColor});

  final String message;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final tokens = FajrDesignTokens.of(context);
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 12),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceElevated,
        borderRadius: BorderRadius.circular(tokens.radiusControl),
        border: Border.all(color: accentColor.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: tokens.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _TiltStatusIndicator extends StatelessWidget {
  const _TiltStatusIndicator({required this.l10n, required this.reading});

  final AppLocalizations l10n;
  final TiltAngleReading? reading;

  @override
  Widget build(BuildContext context) {
    final tokens = FajrDesignTokens.of(context);
    final bool valid = reading?.isWithinStandingRange ?? false;
    final double pitch = reading?.pitchDegrees ?? 0.0;
    final String degrees = pitch.toStringAsFixed(0);
    final double distance = pitch < TiltAngleReading.minValidPitchDegrees
        ? (TiltAngleReading.minValidPitchDegrees - pitch)
        : (pitch > TiltAngleReading.maxValidPitchDegrees
              ? (pitch - TiltAngleReading.maxValidPitchDegrees)
              : 0.0);
    final double progress = valid
        ? 1.0
        : (1.0 - (distance / 65.0)).clamp(0.0, 1.0);
    final Color signalColor = valid ? tokens.emeraldSignal : tokens.clayError;

    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(tokens.radiusControl),
        border: Border.all(color: tokens.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                valid ? Icons.check_circle : Icons.screen_rotation,
                size: 18,
                color: signalColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  valid
                      ? l10n.challengeTiltValid(degrees)
                      : l10n.challengeTiltInvalid(degrees),
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: tokens.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              color: valid ? tokens.emeraldSignal : tokens.dawnAccent,
              backgroundColor: tokens.surfaceElevated,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoVisionView extends StatelessWidget {
  const _PhotoVisionView({
    required this.l10n,
    required this.state,
    required this.cameraController,
    required this.cameraInitialized,
    required this.cameraPreviewOverride,
    required this.onCapture,
  });

  final AppLocalizations l10n;
  final ChallengeState state;
  final CameraController? cameraController;
  final bool cameraInitialized;
  final Widget? cameraPreviewOverride;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final tokens = FajrDesignTokens.of(context);
    final bool canCapture =
        (state.tiltReading?.isWithinStandingRange ?? false) &&
        state.status != ChallengeStatus.verifying;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: tokens.surfaceElevated,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: tokens.borderSubtle),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.lock_outline_rounded,
                  size: 14,
                  color: tokens.emeraldSignal,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.challengeRamOnlyBadge,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: tokens.textSecondary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.challengePhotoInstruction,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: tokens.textSecondary),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: tokens.surface,
              borderRadius: BorderRadius.circular(tokens.radiusCard),
              border: Border.all(color: tokens.borderSubtle),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(tokens.radiusCard),
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  cameraPreviewOverride ??
                      (cameraInitialized && cameraController != null
                          ? CameraPreview(cameraController!)
                          : const Center(child: CircularProgressIndicator())),
                  IgnorePointer(
                    child: CustomPaint(
                      painter: _ViewfinderBracketsPainter(
                        bracketColor: tokens.dawnAccent.withValues(alpha: 0.72),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _TiltStatusIndicator(l10n: l10n, reading: state.tiltReading),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: canCapture ? onCapture : null,
          icon: state.status == ChallengeStatus.verifying
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.camera_alt),
          label: Text(
            state.status == ChallengeStatus.verifying
                ? l10n.challengeVerifying
                : l10n.challengeCapturePhoto,
          ),
        ),
      ],
    );
  }
}

class _ViewfinderBracketsPainter extends CustomPainter {
  const _ViewfinderBracketsPainter({required this.bracketColor});

  final Color bracketColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = bracketColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    const inset = 18.0;
    const len = 22.0;

    final left = inset;
    final top = inset;
    final right = size.width - inset;
    final bottom = size.height - inset;
    if (right <= left || bottom <= top) return;

    canvas.drawPath(
      Path()
        ..moveTo(left, top + len)
        ..lineTo(left, top)
        ..lineTo(left + len, top)
        ..moveTo(right - len, top)
        ..lineTo(right, top)
        ..lineTo(right, top + len)
        ..moveTo(left, bottom - len)
        ..lineTo(left, bottom)
        ..lineTo(left + len, bottom)
        ..moveTo(right - len, bottom)
        ..lineTo(right, bottom)
        ..lineTo(right, bottom - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ViewfinderBracketsPainter oldDelegate) =>
      bracketColor != oldDelegate.bracketColor;
}

class _BathroomBarcodeView extends StatefulWidget {
  const _BathroomBarcodeView({
    required this.l10n,
    required this.state,
    required this.scannerOverride,
    required this.onControllerCreated,
    required this.onBarcodeDetected,
  });

  final AppLocalizations l10n;
  final ChallengeState state;
  final Widget? scannerOverride;
  final ValueChanged<MobileScannerController?> onControllerCreated;
  final ValueChanged<String> onBarcodeDetected;

  @override
  State<_BathroomBarcodeView> createState() => _BathroomBarcodeViewState();
}

class _BathroomBarcodeViewState extends State<_BathroomBarcodeView> {
  MobileScannerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.scannerOverride == null) {
      _controller = MobileScannerController();
      widget.onControllerCreated(_controller);
    }
  }

  @override
  void dispose() {
    final MobileScannerController? controller = _controller;
    _controller = null;
    widget.onControllerCreated(null);
    if (controller != null) {
      unawaited(controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          widget.l10n.challengeBarcodeTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(widget.l10n.challengeBarcodeInstruction),
        const SizedBox(height: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                widget.scannerOverride ??
                MobileScanner(
                  controller: _controller!,
                  onDetect: (BarcodeCapture capture) {
                    for (final Barcode barcode in capture.barcodes) {
                      final String? value = barcode.rawValue;
                      if (value != null && value.isNotEmpty) {
                        widget.onBarcodeDetected(value);
                        break;
                      }
                    }
                  },
                ),
          ),
        ),
      ],
    );
  }
}

class _StandingTypingView extends StatelessWidget {
  const _StandingTypingView({required this.l10n, required this.state});

  final AppLocalizations l10n;
  final ChallengeState state;

  @override
  Widget build(BuildContext context) {
    final bool canSubmit =
        (state.tiltReading?.isWithinStandingRange ?? false) &&
        state.status != ChallengeStatus.verifying;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            l10n.challengeTypingTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(l10n.challengeTypingInstruction),
          const SizedBox(height: 12),
          _TiltStatusIndicator(l10n: l10n, reading: state.tiltReading),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsetsDirectional.all(14),
            decoration: BoxDecoration(
              color: FajrDesignTokens.of(context).surface,
              borderRadius: BorderRadius.circular(
                FajrDesignTokens.of(context).radiusControl,
              ),
              border: Border.all(
                color: FajrDesignTokens.of(context).borderSubtle,
              ),
            ),
            child: Text(
              state.typingPrompt,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: FajrDesignTokens.of(context).textPrimary),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            enableInteractiveSelection: false,
            contextMenuBuilder: null,
            maxLines: 4,
            onChanged: (String value) {
              context.read<ChallengeCubit>().updateTypedText(value);
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              helperText: l10n.challengeTypingCounter(
                state.typedText.length,
                120,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: canSubmit
                ? () => context.read<ChallengeCubit>().submitStandingTyping()
                : null,
            child: Text(
              state.status == ChallengeStatus.verifying
                  ? l10n.challengeVerifying
                  : l10n.challengeTypingSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
