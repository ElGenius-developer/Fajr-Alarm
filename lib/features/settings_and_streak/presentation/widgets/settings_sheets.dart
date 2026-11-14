import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:fajr_alarm/core/widgets/barcode_scanner_input.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/widgets/location_method_helpers.dart';
import 'package:flutter/material.dart';

/// Result returned when the bathroom barcode sheet finishes saving or clearing.
typedef BarcodeSheetResult = ({bool cleared, String? barcode});

/// Opens the bathroom barcode scanner and manual entry bottom sheet.
Future<BarcodeSheetResult?> showBathroomBarcodeSheet(
  BuildContext context, {
  String? initialBarcode,
  BarcodeScannerBuilder? scannerBuilder,
  required Future<bool> Function(String? barcode) onSaveBarcode,
}) {
  return showModalBottomSheet<BarcodeSheetResult>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _BathroomBarcodeSheet(
      initialBarcode: initialBarcode,
      scannerBuilder: scannerBuilder,
      onSaveBarcode: onSaveBarcode,
    ),
  );
}

/// Opens the location coordinates and calculation method bottom sheet.
Future<FajrAlarmConfig?> showLocationMethodSheet(
  BuildContext context, {
  required FajrAlarmConfig initialConfig,
  required Future<bool> Function(FajrAlarmConfig updated) onSaveConfig,
}) {
  return showModalBottomSheet<FajrAlarmConfig>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _LocationMethodSheet(
      initialConfig: initialConfig,
      onSaveConfig: onSaveConfig,
    ),
  );
}

/// Opens the Gemini API key and privacy consent bottom sheet.
Future<bool?> showGeminiKeySheet(
  BuildContext context, {
  required bool initialConsentAccepted,
  required Future<bool> Function(String apiKey, bool consentAccepted)
  onSaveApiKey,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _GeminiKeySheet(
      initialConsentAccepted: initialConsentAccepted,
      onSaveApiKey: onSaveApiKey,
    ),
  );
}

class _BathroomBarcodeSheet extends StatefulWidget {
  const _BathroomBarcodeSheet({
    required this.initialBarcode,
    required this.scannerBuilder,
    required this.onSaveBarcode,
  });

  final String? initialBarcode;
  final BarcodeScannerBuilder? scannerBuilder;
  final Future<bool> Function(String? barcode) onSaveBarcode;

  @override
  State<_BathroomBarcodeSheet> createState() => _BathroomBarcodeSheetState();
}

class _BathroomBarcodeSheetState extends State<_BathroomBarcodeSheet> {
  late final TextEditingController _controller;
  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialBarcode ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave(AppLocalizations l10n) async {
    final trimmed = _controller.text.trim();
    if (trimmed.isEmpty) {
      setState(() => _errorText = l10n.settingsErrorValidation);
      return;
    }
    await _submit(barcode: trimmed, cleared: false);
  }

  Future<void> _handleClear() => _submit(barcode: null, cleared: true);

  Future<void> _submit({
    required String? barcode,
    required bool cleared,
  }) async {
    if (_isSaving) return;
    setState(() {
      _isSaving = true;
      _errorText = null;
    });
    final ok = await widget.onSaveBarcode(barcode);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop((cleared: cleared, barcode: barcode));
      return;
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = FajrDesignTokens.of(context);
    final hasExisting = (widget.initialBarcode ?? '').trim().isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.settingsBarcodeTitle,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.settingsBarcodeSubtitle,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: tokens.textSecondary),
              ),
              const SizedBox(height: 16),
              BarcodeScannerInput(
                controller: _controller,
                enabled: !_isSaving,
                scannerBuilder: widget.scannerBuilder,
                scanButtonKey: const Key('settings_scan_barcode_button'),
                stopScanButtonKey: const Key(
                  'settings_stop_scan_barcode_button',
                ),
                toggleFlashButtonKey: const Key('settings_toggle_flash_button'),
                scannedBadgeKey: const Key('settings_barcode_scanned_badge'),
                textFieldKey: const Key('settings_barcode_input_field'),
                onBarcodeChanged: (_) {
                  if (_errorText != null) setState(() => _errorText = null);
                },
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('settings_save_barcode_button'),
                onPressed: _isSaving ? null : () => _handleSave(l10n),
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.commonSave),
              ),
              if (hasExisting) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  key: const Key('settings_clear_barcode_button'),
                  onPressed: _isSaving ? null : _handleClear,
                  child: Text(l10n.settingsBarcodeClearButton),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationMethodSheet extends StatefulWidget {
  const _LocationMethodSheet({
    required this.initialConfig,
    required this.onSaveConfig,
  });

  final FajrAlarmConfig initialConfig;
  final Future<bool> Function(FajrAlarmConfig updated) onSaveConfig;

  @override
  State<_LocationMethodSheet> createState() => _LocationMethodSheetState();
}

class _LocationMethodSheetState extends State<_LocationMethodSheet> {
  late final TextEditingController _cityController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;
  late FajrCalculationMethod _selectedMethod;
  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final config = widget.initialConfig;
    _cityController = TextEditingController(text: config.cityName ?? '');
    _latController = TextEditingController(
      text: config.latitude.toStringAsFixed(4),
    );
    _lngController = TextEditingController(
      text: config.longitude.toStringAsFixed(4),
    );
    _selectedMethod = config.calculationMethod;
  }

  @override
  void dispose() {
    _cityController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  void _selectPreset(FajrCityPreset city) {
    setState(() {
      _cityController.text = city.key;
      _latController.text = city.lat.toStringAsFixed(4);
      _lngController.text = city.lng.toStringAsFixed(4);
      _selectedMethod = city.method;
      _errorText = null;
    });
  }

  Future<void> _save(AppLocalizations l10n) async {
    if (_isSaving) return;
    final city = _cityController.text.trim();
    final lat = double.tryParse(_latController.text.trim());
    final lng = double.tryParse(_lngController.text.trim());
    if (city.isEmpty ||
        lat == null ||
        lng == null ||
        lat < -90 ||
        lat > 90 ||
        lng < -180 ||
        lng > 180) {
      setState(() => _errorText = l10n.onboardingLocationErrorInvalid);
      return;
    }

    final updated = widget.initialConfig.copyWith(
      cityName: city,
      latitude: lat,
      longitude: lng,
      calculationMethod: _selectedMethod,
    );
    setState(() {
      _isSaving = true;
      _errorText = null;
    });
    final ok = await widget.onSaveConfig(updated);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(updated);
      return;
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = FajrDesignTokens.of(context);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.78,
        minChildSize: 0.45,
        maxChildSize: 0.94,
        builder: (_, scrollController) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      20,
                      4,
                      20,
                      12,
                    ),
                    children: [
                      Text(
                        l10n.scheduleSelectCityTitle,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: presetFajrCities.map((city) {
                          return ChoiceChip(
                            label: Text(localizedCityName(l10n, city.key)),
                            selected: _cityController.text.trim() == city.key,
                            onSelected: _isSaving
                                ? null
                                : (_) => _selectPreset(city),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        key: const Key('settings_location_city_field'),
                        controller: _cityController,
                        enabled: !_isSaving,
                        decoration: InputDecoration(
                          labelText: l10n.onboardingCityLabel,
                          hintText: l10n.onboardingCityHint,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: const Key('settings_location_lat_field'),
                              controller: _latController,
                              enabled: !_isSaving,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    signed: true,
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: l10n.onboardingLatitudeLabel,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              key: const Key('settings_location_lng_field'),
                              controller: _lngController,
                              enabled: !_isSaving,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    signed: true,
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                labelText: l10n.onboardingLongitudeLabel,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Divider(color: tokens.borderSubtle, height: 1),
                      const SizedBox(height: 14),
                      Text(
                        l10n.scheduleSelectMethodTitle,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...supportedFajrMethods.map((method) {
                        final selected = _selectedMethod == method;
                        return ListTile(
                          contentPadding: EdgeInsetsDirectional.zero,
                          title: Text(localizedMethodName(l10n, method)),
                          trailing: selected
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color: tokens.dawnAccent,
                                )
                              : null,
                          onTap: _isSaving
                              ? null
                              : () => setState(() => _selectedMethod = method),
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_errorText != null) ...[
                        Text(
                          _errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      FilledButton(
                        key: const Key('settings_save_location_method_button'),
                        onPressed: _isSaving ? null : () => _save(l10n),
                        child: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.commonSave),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GeminiKeySheet extends StatefulWidget {
  const _GeminiKeySheet({
    required this.initialConsentAccepted,
    required this.onSaveApiKey,
  });

  final bool initialConsentAccepted;
  final Future<bool> Function(String apiKey, bool consentAccepted) onSaveApiKey;

  @override
  State<_GeminiKeySheet> createState() => _GeminiKeySheetState();
}

class _GeminiKeySheetState extends State<_GeminiKeySheet> {
  final TextEditingController _controller = TextEditingController();
  late bool _consentAccepted;
  bool _obscureKey = true;
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _consentAccepted = widget.initialConsentAccepted;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (_isSubmitting) return;
    if (!_consentAccepted) {
      setState(() => _errorText = l10n.onboardingConsentRequiredError);
      return;
    }
    final key = _controller.text.trim();
    if (key.isEmpty) {
      setState(() => _errorText = l10n.onboardingApiKeyInvalidError);
      return;
    }
    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });
    final ok = await widget.onSaveApiKey(key, _consentAccepted);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _isSubmitting = false;
      _errorText = l10n.onboardingApiKeyInvalidError;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = FajrDesignTokens.of(context);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.settingsApiKeyTitle,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsetsDirectional.all(12),
                decoration: BoxDecoration(
                  color: tokens.surfaceElevated,
                  borderRadius: BorderRadius.circular(tokens.radiusControl),
                  border: Border.all(color: tokens.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.onboardingPrivacyNoticeTitle,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.onboardingPrivacyNoticeBody,
                      style: textTheme.bodySmall?.copyWith(
                        color: tokens.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      avatar: const Icon(Icons.memory_rounded, size: 16),
                      label: Text(l10n.challengeRamOnlyBadge),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                key: const Key('settings_privacy_consent_checkbox'),
                contentPadding: EdgeInsetsDirectional.zero,
                value: _consentAccepted,
                onChanged: _isSubmitting
                    ? null
                    : (val) => setState(() {
                        _consentAccepted = val ?? false;
                        _errorText = null;
                      }),
                title: Text(
                  l10n.onboardingPrivacyConsentCheckbox,
                  style: textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                key: const Key('settings_api_key_field'),
                controller: _controller,
                enabled: !_isSubmitting,
                obscureText: _obscureKey,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: l10n.onboardingApiKeyLabel,
                  hintText: l10n.onboardingApiKeyHint,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureKey ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _obscureKey = !_obscureKey),
                  ),
                ),
                onChanged: (_) {
                  if (_errorText != null) setState(() => _errorText = null);
                },
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('settings_save_api_key_button'),
                onPressed: _isSubmitting ? null : () => _submit(l10n),
                child: _isSubmitting
                    ? Text(l10n.onboardingTestingKey)
                    : Text(l10n.onboardingTestKeyButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
