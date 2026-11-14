import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Builder hook allowing widget tests to supply a deterministic scanner widget.
typedef BarcodeScannerBuilder = Widget Function(
  BuildContext context,
  ValueChanged<String> onBarcodeDetected,
);

/// Step 4: Offline Bathroom Barcode registration with camera scan + manual fallback.
class BarcodeStepView extends StatefulWidget {
  const BarcodeStepView({
    super.key,
    required this.initialBarcode,
    required this.isSubmitting,
    required this.onRegisterBarcode,
    required this.onSkip,
    required this.onBack,
    this.scannerBuilder,
  });

  final String? initialBarcode;
  final bool isSubmitting;
  final ValueChanged<String> onRegisterBarcode;
  final VoidCallback onSkip;
  final VoidCallback onBack;
  final BarcodeScannerBuilder? scannerBuilder;

  @override
  State<BarcodeStepView> createState() => _BarcodeStepViewState();
}

class _BarcodeStepViewState extends State<BarcodeStepView> {
  late final TextEditingController _barcodeController;
  MobileScannerController? _scannerController;
  bool _isScanning = false;
  bool _torchEnabled = false;
  String? _scannedCode;

  @override
  void initState() {
    super.initState();
    _barcodeController = TextEditingController(
      text: widget.initialBarcode ?? '',
    );
  }

  @override
  void dispose() {
    _disposeScannerController();
    _barcodeController.dispose();
    super.dispose();
  }

  void _disposeScannerController() {
    final MobileScannerController? controller = _scannerController;
    _scannerController = null;
    controller?.dispose();
  }

  void _startScanning() {
    if (_isScanning || widget.isSubmitting) return;
    if (widget.scannerBuilder == null) {
      _scannerController ??= MobileScannerController();
    }
    setState(() {
      _isScanning = true;
      _torchEnabled = false;
    });
  }

  void _stopScanning() {
    if (!_isScanning) return;
    _disposeScannerController();
    setState(() {
      _isScanning = false;
      _torchEnabled = false;
    });
  }

  Future<void> _toggleTorch() async {
    final MobileScannerController? controller = _scannerController;
    if (controller == null) return;
    await controller.toggleTorch();
    if (!mounted) return;
    setState(() => _torchEnabled = !_torchEnabled);
  }

  void _handleBarcodeDetected(String rawValue) {
    final String code = rawValue.trim();
    if (code.isEmpty || !mounted) return;
    HapticFeedback.mediumImpact();
    _disposeScannerController();
    setState(() {
      _isScanning = false;
      _torchEnabled = false;
      _scannedCode = code;
      _barcodeController.text = code;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final FajrDesignTokens tokens = FajrDesignTokens.of(context);
    final bool showScannedBadge =
        _scannedCode != null && _barcodeController.text == _scannedCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(l10n.onboardingStep4Title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(l10n.onboardingStep4Subtitle, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        if (_isScanning)
          _buildLiveScannerCard(l10n, tokens)
        else
          _buildScanPromptCard(l10n, theme, tokens),
        if (showScannedBadge) ...<Widget>[
          const SizedBox(height: 10),
          _buildScannedBadge(l10n, theme, tokens, _scannedCode!),
        ],
        const SizedBox(height: 12),
        _buildManualDivider(l10n, theme, tokens),
        const SizedBox(height: 10),
        TextField(
          key: const Key('onboarding_barcode_field'),
          controller: _barcodeController,
          onChanged: (_) {
            if (_scannedCode != null &&
                _barcodeController.text != _scannedCode) {
              setState(() => _scannedCode = null);
            }
          },
          decoration: InputDecoration(
            labelText: l10n.onboardingBarcodeLabel,
            hintText: l10n.onboardingBarcodeHint,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          key: const Key('onboarding_register_barcode_button'),
          onPressed: widget.isSubmitting
              ? null
              : () => widget.onRegisterBarcode(_barcodeController.text),
          child: Text(l10n.onboardingRegisterBarcodeButton),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            OutlinedButton(
              onPressed: widget.isSubmitting ? null : widget.onBack,
              child: Text(l10n.commonBack),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextButton(
                key: const Key('onboarding_skip_barcode_button'),
                onPressed: widget.isSubmitting ? null : widget.onSkip,
                child: Text(l10n.onboardingSkipBarcodeButton),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScanPromptCard(
    AppLocalizations l10n,
    ThemeData theme,
    FajrDesignTokens tokens,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(tokens.radiusCard),
        border: Border.all(
          color: tokens.dawnAccent.withValues(alpha: 0.45),
          width: tokens.borderWidth,
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: tokens.dawnAccent.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: tokens.dawnAccent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.onboardingScanBarcodeHint,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: tokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              key: const Key('onboarding_scan_barcode_button'),
              onPressed: widget.isSubmitting ? null : _startScanning,
              icon: Icon(
                Icons.camera_alt_outlined,
                color: tokens.dawnAccent,
                size: 20,
              ),
              label: Text(l10n.onboardingScanBarcodeButton),
              style: OutlinedButton.styleFrom(
                foregroundColor: tokens.dawnAccent,
                side: BorderSide(color: tokens.dawnAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveScannerCard(AppLocalizations l10n, FajrDesignTokens tokens) {
    final Widget scannerView =
        widget.scannerBuilder?.call(context, _handleBarcodeDetected) ??
        MobileScanner(
          controller: _scannerController,
          onDetect: (BarcodeCapture capture) {
            for (final Barcode barcode in capture.barcodes) {
              final String? value = barcode.rawValue;
              if (value != null && value.trim().isNotEmpty) {
                _handleBarcodeDetected(value);
                break;
              }
            }
          },
          errorBuilder: (BuildContext context, MobileScannerException error) =>
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.onboardingScannerUnavailable,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: tokens.textSecondary),
                  ),
                ),
              ),
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(tokens.radiusCard),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: tokens.surface,
          border: Border.all(color: tokens.dawnAccent, width: 1.5),
          borderRadius: BorderRadius.circular(tokens.radiusCard),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            scannerView,
            IgnorePointer(
              child: CustomPaint(
                painter: _BarcodeReticlePainter(color: tokens.dawnAccent),
              ),
            ),
            PositionedDirectional(
              top: 8,
              end: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (_scannerController != null)
                    IconButton.filledTonal(
                      key: const Key('onboarding_toggle_flash_button'),
                      tooltip: l10n.onboardingToggleFlashTooltip,
                      onPressed: _toggleTorch,
                      icon: Icon(
                        _torchEnabled
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        size: 20,
                      ),
                    ),
                  const SizedBox(width: 6),
                  IconButton.filledTonal(
                    key: const Key('onboarding_stop_scan_button'),
                    tooltip: l10n.onboardingStopScanButton,
                    onPressed: _stopScanning,
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannedBadge(
    AppLocalizations l10n,
    ThemeData theme,
    FajrDesignTokens tokens,
    String code,
  ) {
    return Container(
      key: const Key('onboarding_barcode_scanned_badge'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: tokens.emeraldSignal.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(tokens.radiusControl),
        border: Border.all(color: tokens.emeraldSignal.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.check_circle_rounded,
            color: tokens.emeraldSignal,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.onboardingBarcodeScannedBadge(code),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualDivider(
    AppLocalizations l10n,
    ThemeData theme,
    FajrDesignTokens tokens,
  ) {
    return Row(
      children: <Widget>[
        Expanded(child: Divider(color: tokens.borderSubtle)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            l10n.onboardingOrEnterManually,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: tokens.textMuted,
            ),
          ),
        ),
        Expanded(child: Divider(color: tokens.borderSubtle)),
      ],
    );
  }
}

class _BarcodeReticlePainter extends CustomPainter {
  const _BarcodeReticlePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double margin = 28;
    const double corner = 22;
    final Rect rect = Rect.fromLTWH(
      margin,
      margin,
      size.width - margin * 2,
      size.height - margin * 2,
    );

    final Path path = Path()
      ..moveTo(rect.left, rect.top + corner)
      ..lineTo(rect.left, rect.top)
      ..lineTo(rect.left + corner, rect.top)
      ..moveTo(rect.right - corner, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.top + corner)
      ..moveTo(rect.left, rect.bottom - corner)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left + corner, rect.bottom)
      ..moveTo(rect.right - corner, rect.bottom)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.right, rect.bottom - corner);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BarcodeReticlePainter oldDelegate) =>
      color != oldDelegate.color;
}
