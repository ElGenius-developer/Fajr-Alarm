import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Step 4: Offline Bathroom Barcode registration with skip-for-now option.
class BarcodeStepView extends StatefulWidget {
  const BarcodeStepView({
    super.key,
    required this.initialBarcode,
    required this.isSubmitting,
    required this.onRegisterBarcode,
    required this.onSkip,
    required this.onBack,
  });

  final String? initialBarcode;
  final bool isSubmitting;
  final ValueChanged<String> onRegisterBarcode;
  final VoidCallback onSkip;
  final VoidCallback onBack;

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
        const SizedBox(height: 8),
        Text(l10n.onboardingStep4Subtitle, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        TextField(
          key: const Key('onboarding_barcode_field'),
          controller: _barcodeController,
          decoration: InputDecoration(
            labelText: l10n.onboardingBarcodeLabel,
            hintText: l10n.onboardingBarcodeHint,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          key: const Key('onboarding_register_barcode_button'),
          onPressed: widget.isSubmitting
              ? null
              : () => widget.onRegisterBarcode(_barcodeController.text),
          child: Text(l10n.onboardingRegisterBarcodeButton),
        ),
        const SizedBox(height: 12),
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
