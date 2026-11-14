import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Touch-Mute + 60s continuous hold button for Emergency Override (FR-6.2).
class EmergencyOverrideButton extends StatelessWidget {
  const EmergencyOverrideButton({
    required this.isMuted,
    required this.elapsedSeconds,
    required this.remainingQuota,
    required this.releasedEarly,
    required this.onHoldStart,
    required this.onHoldRelease,
    super.key,
    this.totalSeconds = 60,
  });

  final bool isMuted;
  final int elapsedSeconds;
  final int remainingQuota;
  final bool releasedEarly;
  final VoidCallback onHoldStart;
  final VoidCallback onHoldRelease;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final tokens = FajrDesignTokens.of(context);
    final remainingSeconds = (totalSeconds - elapsedSeconds).clamp(
      0,
      totalSeconds,
    );
    final progress = (elapsedSeconds / totalSeconds).clamp(0.0, 1.0);
    final hasQuota = remainingQuota > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Listener(
          onPointerDown: hasQuota ? (_) => onHoldStart() : null,
          onPointerUp: hasQuota ? (_) => onHoldRelease() : null,
          onPointerCancel: hasQuota ? (_) => onHoldRelease() : null,
          child: Semantics(
            button: true,
            label: l10n.alarmEmergencyHoldButton,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: !hasQuota
                    ? tokens.surfaceElevated
                    : isMuted
                    ? tokens.clayError.withValues(alpha: 0.14)
                    : tokens.surfaceElevated,
                borderRadius: BorderRadius.circular(tokens.radiusControl),
                border: Border.all(
                  color: !hasQuota
                      ? tokens.borderSubtle
                      : isMuted
                      ? tokens.clayError
                      : tokens.borderSubtle,
                  width: isMuted ? 1.5 : tokens.borderWidth,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isMuted ? Icons.volume_off : Icons.emergency_outlined,
                        size: 20,
                        color: hasQuota ? tokens.clayError : tokens.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          isMuted
                              ? l10n.alarmEmergencyMutedHint(remainingSeconds)
                              : l10n.alarmEmergencyHoldButton,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: hasQuota
                                ? tokens.textPrimary
                                : tokens.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isMuted) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        color: tokens.clayError,
                        backgroundColor: tokens.surface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          hasQuota
              ? l10n.alarmEmergencyRemainingCount(remainingQuota)
              : l10n.alarmEmergencyNoQuota,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: hasQuota ? tokens.textSecondary : tokens.clayError,
          ),
        ),
        if (releasedEarly) ...[
          const SizedBox(height: 6),
          Text(
            l10n.alarmEmergencyReleasedError,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: tokens.clayError),
          ),
        ],
      ],
    );
  }
}
