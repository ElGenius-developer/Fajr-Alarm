import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';

/// Preset city definition paired with coordinates and regional calculation method.
typedef FajrCityPreset = ({
  String key,
  double lat,
  double lng,
  FajrCalculationMethod method,
});

/// Canonical preset cities offered in Schedule and Settings location pickers.
const List<FajrCityPreset> presetFajrCities = <FajrCityPreset>[
  (
    key: 'Cairo',
    lat: 30.0444,
    lng: 31.2357,
    method: FajrCalculationMethod.egyptian,
  ),
  (
    key: 'Alexandria',
    lat: 31.2001,
    lng: 29.9187,
    method: FajrCalculationMethod.egyptian,
  ),
  (
    key: 'Makkah',
    lat: 21.4225,
    lng: 39.8262,
    method: FajrCalculationMethod.ummAlQura,
  ),
  (
    key: 'Madinah',
    lat: 24.5247,
    lng: 39.5692,
    method: FajrCalculationMethod.ummAlQura,
  ),
  (
    key: 'Riyadh',
    lat: 24.7136,
    lng: 46.6753,
    method: FajrCalculationMethod.ummAlQura,
  ),
  (
    key: 'Dubai',
    lat: 25.2048,
    lng: 55.2708,
    method: FajrCalculationMethod.dubai,
  ),
  (
    key: 'Istanbul',
    lat: 41.0082,
    lng: 28.9784,
    method: FajrCalculationMethod.turkey,
  ),
  (
    key: 'London',
    lat: 51.5074,
    lng: -0.1278,
    method: FajrCalculationMethod.muslimWorldLeague,
  ),
  (
    key: 'New York',
    lat: 40.7128,
    lng: -74.0060,
    method: FajrCalculationMethod.northAmerica,
  ),
];

/// Supported calculation methods exposed in UI pickers.
const List<FajrCalculationMethod> supportedFajrMethods =
    <FajrCalculationMethod>[
      FajrCalculationMethod.egyptian,
      FajrCalculationMethod.ummAlQura,
      FajrCalculationMethod.muslimWorldLeague,
      FajrCalculationMethod.northAmerica,
      FajrCalculationMethod.karachi,
      FajrCalculationMethod.dubai,
      FajrCalculationMethod.turkey,
    ];

/// Returns the localized city display label or falls back to custom city text.
String localizedCityName(AppLocalizations l10n, String? cityKey) {
  return switch (cityKey) {
    'Cairo' => l10n.cityCairo,
    'Alexandria' => l10n.cityAlexandria,
    'Makkah' => l10n.cityMakkah,
    'Madinah' => l10n.cityMadinah,
    'Riyadh' => l10n.cityRiyadh,
    'Dubai' => l10n.cityDubai,
    'Istanbul' => l10n.cityIstanbul,
    'London' => l10n.cityLondon,
    'New York' => l10n.cityNewYork,
    _ =>
      (cityKey != null && cityKey.trim().isNotEmpty) ? cityKey : l10n.cityCairo,
  };
}

/// Returns the localized calculation method display label.
String localizedMethodName(
  AppLocalizations l10n,
  FajrCalculationMethod method,
) {
  return switch (method) {
    FajrCalculationMethod.egyptian => l10n.methodEgyptian,
    FajrCalculationMethod.ummAlQura => l10n.methodUmmAlQura,
    FajrCalculationMethod.muslimWorldLeague => l10n.methodMuslimWorldLeague,
    FajrCalculationMethod.northAmerica => l10n.methodNorthAmerica,
    FajrCalculationMethod.karachi => l10n.methodKarachi,
    FajrCalculationMethod.dubai => l10n.methodDubai,
    FajrCalculationMethod.turkey => l10n.methodTurkey,
    _ => method.name,
  };
}
