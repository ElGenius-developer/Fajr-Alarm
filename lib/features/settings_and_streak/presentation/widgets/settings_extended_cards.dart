import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/widgets/location_method_helpers.dart';
import 'package:flutter/material.dart';

/// Card managing location, calculation method, and Fajr alarm timing settings.
class LocationAndAlarmCard extends StatelessWidget {
  const LocationAndAlarmCard({
    super.key,
    required this.l10n,
    required this.config,
    required this.isLocked,
    required this.onEditLocationMethod,
    required this.onConfigChanged,
  });

  final AppLocalizations l10n;
  final FajrAlarmConfig? config;
  final bool isLocked;
  final VoidCallback onEditLocationMethod;
  final ValueChanged<FajrAlarmConfig> onConfigChanged;

  @override
  Widget build(BuildContext context) {
    final effective =
        config ??
        const FajrAlarmConfig(
          latitude: 30.0444,
          longitude: 31.2357,
          cityName: 'Cairo',
        );
    final tokens = FajrDesignTokens.of(context);
    final textTheme = Theme.of(context).textTheme;
    final locationSummary =
        '${localizedCityName(l10n, effective.cityName)} · '
        '${localizedMethodName(l10n, effective.calculationMethod)}';

    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(
              icon: Icons.location_on_outlined,
              title: l10n.settingsAlarmAndLocationTitle,
            ),
            const SizedBox(height: 8),
            Text(
              locationSummary,
              style: textTheme.bodyMedium?.copyWith(
                color: tokens.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              key: const Key('settings_edit_location_method_button'),
              onPressed: isLocked ? null : onEditLocationMethod,
              icon: const Icon(Icons.edit_location_alt_outlined),
              label: Text(l10n.settingsEditLocationMethodButton),
            ),
            const SizedBox(height: 12),
            Divider(color: tokens.borderSubtle, height: 1),
            SwitchListTile(
              key: const Key('settings_alarm_enabled_switch'),
              contentPadding: EdgeInsetsDirectional.zero,
              title: Text(l10n.scheduleEnableSwitchLabel),
              value: effective.isEnabled,
              onChanged: isLocked
                  ? null
                  : (enabled) =>
                        onConfigChanged(effective.copyWith(isEnabled: enabled)),
            ),
            _AlarmModeControls(
              l10n: l10n,
              config: effective,
              isLocked: isLocked,
              onConfigChanged: onConfigChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _AlarmModeControls extends StatelessWidget {
  const _AlarmModeControls({
    required this.l10n,
    required this.config,
    required this.isLocked,
    required this.onConfigChanged,
  });

  final AppLocalizations l10n;
  final FajrAlarmConfig config;
  final bool isLocked;
  final ValueChanged<FajrAlarmConfig> onConfigChanged;

  Widget _segmentLabel(String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(text, maxLines: 1, softWrap: false),
    );
  }

  Future<void> _pickManualTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: config.manualHour,
        minute: config.manualMinute,
      ),
    );
    if (picked == null || !context.mounted) return;
    onConfigChanged(
      config.copyWith(manualHour: picked.hour, manualMinute: picked.minute),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<FajrAlarmMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: FajrAlarmMode.relativeToAdhan,
              label: _segmentLabel(l10n.scheduleModeRelative),
            ),
            ButtonSegment(
              value: FajrAlarmMode.manualTime,
              label: _segmentLabel(l10n.scheduleModeManual),
            ),
          ],
          selected: {config.mode},
          onSelectionChanged: isLocked
              ? null
              : (selection) =>
                    onConfigChanged(config.copyWith(mode: selection.first)),
        ),
        const SizedBox(height: 12),
        if (config.mode == FajrAlarmMode.relativeToAdhan)
          _RelativeOffsetControls(
            l10n: l10n,
            config: config,
            isLocked: isLocked,
            segmentLabel: _segmentLabel,
            onConfigChanged: onConfigChanged,
          )
        else
          ListTile(
            key: const Key('settings_manual_time_picker'),
            contentPadding: EdgeInsetsDirectional.zero,
            leading: const Icon(Icons.access_time_rounded),
            title: Text(l10n.scheduleManualTimeLabel),
            trailing: Text(
              TimeOfDay(
                hour: config.manualHour,
                minute: config.manualMinute,
              ).format(context),
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            enabled: !isLocked,
            onTap: isLocked ? null : () => _pickManualTime(context),
          ),
      ],
    );
  }
}

class _RelativeOffsetControls extends StatelessWidget {
  const _RelativeOffsetControls({
    required this.l10n,
    required this.config,
    required this.isLocked,
    required this.segmentLabel,
    required this.onConfigChanged,
  });

  final AppLocalizations l10n;
  final FajrAlarmConfig config;
  final bool isLocked;
  final Widget Function(String) segmentLabel;
  final ValueChanged<FajrAlarmConfig> onConfigChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<FajrOffsetDirection>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: FajrOffsetDirection.before,
              label: segmentLabel(l10n.scheduleOffsetBefore),
            ),
            ButtonSegment(
              value: FajrOffsetDirection.at,
              label: segmentLabel(l10n.scheduleOffsetAt),
            ),
            ButtonSegment(
              value: FajrOffsetDirection.after,
              label: segmentLabel(l10n.scheduleOffsetAfter),
            ),
          ],
          selected: {config.offsetDirection},
          onSelectionChanged: isLocked
              ? null
              : (selection) {
                  final direction = selection.first;
                  final nextMinutes = direction == FajrOffsetDirection.at
                      ? 0
                      : (config.offsetMinutes <= 0 ? 15 : config.offsetMinutes);
                  onConfigChanged(
                    config.copyWith(
                      offsetDirection: direction,
                      offsetMinutes: nextMinutes,
                    ),
                  );
                },
        ),
        if (config.offsetDirection != FajrOffsetDirection.at) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const <int>[5, 10, 15, 20, 30, 45, 60]
                .map(
                  (minutes) => ChoiceChip(
                    key: Key('settings_offset_chip_$minutes'),
                    label: Text(l10n.scheduleOffsetMinutesLabel(minutes)),
                    selected: config.offsetMinutes == minutes,
                    onSelected: isLocked
                        ? null
                        : (selected) {
                            if (selected) {
                              onConfigChanged(
                                config.copyWith(offsetMinutes: minutes),
                              );
                            }
                          },
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

/// Card showing bathroom barcode registration status and edit/scan sheet trigger.
class BathroomBarcodeCard extends StatelessWidget {
  const BathroomBarcodeCard({
    super.key,
    required this.l10n,
    required this.barcode,
    required this.isLocked,
    required this.onOpenSheet,
  });

  final AppLocalizations l10n;
  final String? barcode;
  final bool isLocked;
  final VoidCallback onOpenSheet;

  @override
  Widget build(BuildContext context) {
    final trimmed = barcode?.trim() ?? '';
    final isSet = trimmed.isNotEmpty;
    final tokens = FajrDesignTokens.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(
              icon: Icons.qr_code_scanner_rounded,
              title: l10n.settingsBarcodeTitle,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.settingsBarcodeSubtitle,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: tokens.textSecondary),
            ),
            const SizedBox(height: 10),
            Text(
              isSet
                  ? l10n.settingsBarcodeRegistered(trimmed)
                  : l10n.settingsBarcodeNotSet,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSet ? tokens.dawnAccent : tokens.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              key: const Key('settings_open_barcode_sheet_button'),
              onPressed: isLocked ? null : onOpenSheet,
              icon: const Icon(Icons.qr_code_2_rounded),
              label: Text(l10n.settingsBarcodeScanOrEditButton),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card showing Gemini BYOK status and opening the key/privacy update sheet.
class GeminiApiKeyCard extends StatelessWidget {
  const GeminiApiKeyCard({
    super.key,
    required this.l10n,
    required this.onboardingState,
    required this.isLocked,
    required this.onOpenSheet,
  });

  final AppLocalizations l10n;
  final OnboardingStateEntity? onboardingState;
  final bool isLocked;
  final VoidCallback onOpenSheet;

  @override
  Widget build(BuildContext context) {
    final verified = onboardingState?.apiKeyValidated ?? false;
    final tokens = FajrDesignTokens.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(
              icon: Icons.key_outlined,
              title: l10n.settingsApiKeyTitle,
            ),
            const SizedBox(height: 8),
            Text(
              verified
                  ? l10n.settingsApiKeyVerified
                  : l10n.settingsApiKeyNotSet,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: verified ? tokens.dawnAccent : tokens.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              key: const Key('settings_open_api_key_sheet_button'),
              onPressed: isLocked ? null : onOpenSheet,
              icon: const Icon(Icons.vpn_key_outlined),
              label: Text(l10n.settingsApiKeyUpdateButton),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card summarizing mandatory system permissions and providing grant/refresh controls.
class PermissionsStatusCard extends StatelessWidget {
  const PermissionsStatusCard({
    super.key,
    required this.l10n,
    required this.status,
    required this.isRequesting,
    required this.onRequestPermissions,
    required this.onRefreshPermissions,
  });

  final AppLocalizations l10n;
  final PermissionsGateStatus? status;
  final bool isRequesting;
  final VoidCallback onRequestPermissions;
  final VoidCallback onRefreshPermissions;

  @override
  Widget build(BuildContext context) {
    final current = status;
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardHeader(
              icon: Icons.verified_user_outlined,
              title: l10n.settingsPermissionsTitle,
            ),
            const SizedBox(height: 8),
            _PermissionRow(
              label: l10n.onboardingPermFullScreenTitle,
              granted: current?.fullScreenIntentGranted ?? false,
              l10n: l10n,
            ),
            _PermissionRow(
              label: l10n.onboardingPermBatteryTitle,
              granted: current?.batteryOptimizationIgnored ?? false,
              l10n: l10n,
            ),
            _PermissionRow(
              label: l10n.onboardingPermCameraTitle,
              granted: current?.cameraGranted ?? false,
              l10n: l10n,
            ),
            _PermissionRow(
              label: l10n.onboardingPermAlarmTitle,
              granted: current?.alarmPermissionGranted ?? false,
              l10n: l10n,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  key: const Key('settings_grant_permissions_button'),
                  onPressed: isRequesting ? null : onRequestPermissions,
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  label: Text(l10n.onboardingPermRequestButton),
                ),
                TextButton.icon(
                  key: const Key('settings_refresh_permissions_button'),
                  onPressed: isRequesting ? null : onRefreshPermissions,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.onboardingPermRefreshButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.label,
    required this.granted,
    required this.l10n,
  });

  final String label;
  final bool granted;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final tokens = FajrDesignTokens.of(context);
    final color = granted ? tokens.dawnAccent : tokens.clayError;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            granted ? Icons.check_circle_outline : Icons.error_outline,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(
            granted ? l10n.onboardingPermGranted : l10n.onboardingPermMissing,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
