import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Step 1: Location and city selection for offline Fajr calculation.
class LocationStepView extends StatefulWidget {
  const LocationStepView({
    super.key,
    required this.initialCity,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.isSubmitting,
    required this.onSaveLocation,
  });

  final String? initialCity;
  final double? initialLatitude;
  final double? initialLongitude;
  final bool isSubmitting;
  final void Function({
    required double latitude,
    required double longitude,
    required String cityName,
  })
  onSaveLocation;

  @override
  State<LocationStepView> createState() => _LocationStepViewState();
}

class _LocationStepViewState extends State<LocationStepView> {
  late final TextEditingController _cityController;
  late final TextEditingController _latController;
  late final TextEditingController _lonController;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController(text: widget.initialCity ?? '');
    _latController = TextEditingController(
      text: widget.initialLatitude?.toString() ?? '',
    );
    _lonController = TextEditingController(
      text: widget.initialLongitude?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  void _selectPreset(String city, double lat, double lon) {
    setState(() {
      _cityController.text = city;
      _latController.text = lat.toString();
      _lonController.text = lon.toString();
      _validationError = null;
    });
  }

  void _submit(AppLocalizations l10n) {
    final String city = _cityController.text.trim();
    final double? lat = double.tryParse(_latController.text.trim());
    final double? lon = double.tryParse(_lonController.text.trim());
    if (city.isEmpty ||
        lat == null ||
        lon == null ||
        lat < -90 ||
        lat > 90 ||
        lon < -180 ||
        lon > 180) {
      setState(() {
        _validationError = l10n.onboardingLocationErrorInvalid;
      });
      return;
    }
    setState(() => _validationError = null);
    widget.onSaveLocation(latitude: lat, longitude: lon, cityName: city);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    final List<({String label, double lat, double lon})> presets =
        <({String label, double lat, double lon})>[
          (label: l10n.onboardingCityCairo, lat: 30.0444, lon: 31.2357),
          (label: l10n.onboardingCityMakkah, lat: 21.3891, lon: 39.8579),
          (label: l10n.onboardingCityMadinah, lat: 24.5247, lon: 39.5692),
          (label: l10n.onboardingCityRiyadh, lat: 24.7136, lon: 46.6753),
          (label: l10n.onboardingCityIstanbul, lat: 41.0082, lon: 28.9784),
          (label: l10n.onboardingCityLondon, lat: 51.5072, lon: -0.1276),
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(l10n.onboardingStep1Title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(l10n.onboardingStep1Subtitle, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        Text(
          l10n.onboardingPresetCitiesLabel,
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presets
              .map(
                (({String label, double lat, double lon}) preset) => ActionChip(
                  label: Text(preset.label),
                  onPressed: () =>
                      _selectPreset(preset.label, preset.lat, preset.lon),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        TextField(
          key: const Key('onboarding_city_field'),
          controller: _cityController,
          decoration: InputDecoration(
            labelText: l10n.onboardingCityLabel,
            hintText: l10n.onboardingCityHint,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                key: const Key('onboarding_lat_field'),
                controller: _latController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: InputDecoration(
                  labelText: l10n.onboardingLatitudeLabel,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                key: const Key('onboarding_lon_field'),
                controller: _lonController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: InputDecoration(
                  labelText: l10n.onboardingLongitudeLabel,
                ),
              ),
            ),
          ],
        ),
        if (_validationError != null) ...<Widget>[
          const SizedBox(height: 12),
          Text(
            _validationError!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          key: const Key('onboarding_save_location_button'),
          onPressed: widget.isSubmitting ? null : () => _submit(l10n),
          child: Text(l10n.onboardingLocationSaveButton),
        ),
      ],
    );
  }
}
