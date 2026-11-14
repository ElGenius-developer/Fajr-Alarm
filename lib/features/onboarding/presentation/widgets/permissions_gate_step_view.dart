import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:fajr_alarm/features/onboarding/domain/entities/onboarding_state_entity.dart';
import 'package:flutter/material.dart';

/// Step 2: Mandatory OS permissions gate (FullScreenIntent, Battery, Camera, AlarmKit).
class PermissionsGateStepView extends StatelessWidget {
  const PermissionsGateStepView({
    super.key,
    required this.status,
    required this.isSubmitting,
    required this.onRequestPermissions,
    required this.onRefreshStatus,
    required this.onContinue,
    required this.onBack,
  });

  final PermissionsGateStatus status;
  final bool isSubmitting;
  final VoidCallback onRequestPermissions;
  final VoidCallback onRefreshStatus;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(l10n.onboardingStep2Title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(l10n.onboardingStep2Subtitle, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        _PermissionTile(
          title: l10n.onboardingPermFullScreenTitle,
          subtitle: l10n.onboardingPermFullScreenDesc,
          granted: status.fullScreenIntentGranted,
          grantedLabel: l10n.onboardingPermGranted,
          missingLabel: l10n.onboardingPermMissing,
        ),
        _PermissionTile(
          title: l10n.onboardingPermBatteryTitle,
          subtitle: l10n.onboardingPermBatteryDesc,
          granted: status.batteryOptimizationIgnored,
          grantedLabel: l10n.onboardingPermGranted,
          missingLabel: l10n.onboardingPermMissing,
        ),
        _PermissionTile(
          title: l10n.onboardingPermCameraTitle,
          subtitle: l10n.onboardingPermCameraDesc,
          granted: status.cameraGranted,
          grantedLabel: l10n.onboardingPermGranted,
          missingLabel: l10n.onboardingPermMissing,
        ),
        _PermissionTile(
          title: l10n.onboardingPermAlarmTitle,
          subtitle: l10n.onboardingPermAlarmDesc,
          granted: status.alarmPermissionGranted,
          grantedLabel: l10n.onboardingPermGranted,
          missingLabel: l10n.onboardingPermMissing,
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: FilledButton.tonal(
                key: const Key('onboarding_request_perms_button'),
                onPressed: isSubmitting ? null : onRequestPermissions,
                child: Text(l10n.onboardingPermRequestButton),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              key: const Key('onboarding_refresh_perms_button'),
              onPressed: isSubmitting ? null : onRefreshStatus,
              child: Text(l10n.onboardingPermRefreshButton),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: <Widget>[
            OutlinedButton(onPressed: onBack, child: Text(l10n.commonBack)),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                key: const Key('onboarding_perms_continue_button'),
                onPressed: isSubmitting ? null : onContinue,
                child: Text(l10n.commonContinue),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.title,
    required this.subtitle,
    required this.granted,
    required this.grantedLabel,
    required this.missingLabel,
  });

  final String title;
  final String subtitle;
  final bool granted;
  final String grantedLabel;
  final String missingLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FajrDesignTokens tokens = FajrDesignTokens.of(context);
    final Color statusColor = granted ? tokens.emeraldSignal : tokens.clayError;
    return Card(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          granted ? Icons.check_circle : Icons.warning_amber_rounded,
          color: statusColor,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          granted ? grantedLabel : missingLabel,
          style: theme.textTheme.labelMedium?.copyWith(color: statusColor),
        ),
      ),
    );
  }
}
