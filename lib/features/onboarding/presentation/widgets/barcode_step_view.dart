import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/widgets/barcode_scanner_input.dart';
import 'package:flutter/material.dart';

export 'package:fajr_alarm/core/widgets/barcode_scanner_input.dart'
    show BarcodeScannerBuilder;

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

  @override
  void initState() {
    super.initState();
    _barcodeController = TextEditingController(
      text: widget.initialBarcode ?? '',
    );
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(l10n.onboardingStep4Title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(l10n.onboardingStep4Subtitle, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        BarcodeScannerInput(
          controller: _barcodeController,
          enabled: !widget.isSubmitting,
          scannerBuilder: widget.scannerBuilder,
          scanButtonKey: const Key('onboarding_scan_barcode_button'),
          stopScanButtonKey: const Key('onboarding_stop_scan_button'),
          toggleFlashButtonKey: const Key('onboarding_toggle_flash_button'),
          scannedBadgeKey: const Key('onboarding_barcode_scanned_badge'),
          textFieldKey: const Key('onboarding_barcode_field'),
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
}
