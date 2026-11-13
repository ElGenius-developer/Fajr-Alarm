import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_event.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_state.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/widgets/emergency_override_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lock-screen / full-screen alarm ringing UI (FR-02, FR-6.2).
class AlarmRingingPage extends StatelessWidget {
  const AlarmRingingPage({super.key, this.onStartChallenge});

  final VoidCallback? onStartChallenge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.alarmRingingTitle),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: BlocBuilder<AlarmRingingBloc, AlarmRingingState>(
          builder: (context, state) {
            final status = state.entity.status;
            final isRingingOrSnoozed =
                status == AlarmStatus.ringingInitial ||
                status == AlarmStatus.snoozed5Min ||
                status == AlarmStatus.ringingRelentless;

            return Padding(
              padding: const EdgeInsetsDirectional.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      if (state.entity.isDryRun)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 12),
                          child: Chip(
                            label: Text(l10n.alarmDryRunBadge),
                            avatar: const Icon(
                              Icons.science_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                      Icon(
                        _statusIcon(status),
                        size: 72,
                        color: _statusColor(status, theme.colorScheme),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _statusHeadline(status, l10n),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (status == AlarmStatus.snoozed5Min)
                        Text(
                          l10n.alarmSnoozeCountdown(
                            _formatDuration(state.snoozeRemainingSeconds),
                          ),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      if (status == AlarmStatus.ringingRelentless)
                        Text(
                          l10n.alarmRelentlessLoopHint,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                  if (isRingingOrSnoozed)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<AlarmRingingBloc>().add(
                              const AlarmRingingEvent.challengeStarted(),
                            );
                            onStartChallenge?.call();
                          },
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: Text(l10n.alarmStartChallengeButton),
                        ),
                        if (status == AlarmStatus.ringingInitial &&
                            !state.entity.snoozeUsed) ...[
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<AlarmRingingBloc>().add(
                                const AlarmRingingEvent.snoozeRequested(),
                              );
                            },
                            icon: const Icon(Icons.snooze),
                            label: Text(l10n.alarmSnoozeButton),
                          ),
                        ],
                        const SizedBox(height: 24),
                        EmergencyOverrideButton(
                          isMuted: state.isEmergencyMuted,
                          elapsedSeconds: state.emergencyHoldElapsedSeconds,
                          remainingQuota:
                              state.entity.remainingEmergencyOverrides,
                          releasedEarly: state.emergencyReleasedEarly,
                          onHoldStart: () {
                            context.read<AlarmRingingBloc>().add(
                              const AlarmRingingEvent.emergencyHoldStarted(),
                            );
                          },
                          onHoldRelease: () {
                            context.read<AlarmRingingBloc>().add(
                              const AlarmRingingEvent.emergencyHoldReleased(),
                            );
                          },
                        ),
                      ],
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _statusIcon(AlarmStatus status) {
    return switch (status) {
      AlarmStatus.idle => Icons.alarm,
      AlarmStatus.lockedPreFajr => Icons.lock_clock,
      AlarmStatus.ringingInitial => Icons.alarm_on,
      AlarmStatus.snoozed5Min => Icons.snooze,
      AlarmStatus.ringingRelentless => Icons.notifications_active,
      AlarmStatus.challengeActive => Icons.camera_alt,
      AlarmStatus.completed => Icons.check_circle_outline,
      AlarmStatus.vacationFrozen => Icons.beach_access,
    };
  }

  Color _statusColor(AlarmStatus status, ColorScheme scheme) {
    return switch (status) {
      AlarmStatus.ringingRelentless => scheme.error,
      AlarmStatus.completed => scheme.primary,
      AlarmStatus.vacationFrozen => scheme.secondary,
      _ => scheme.primary,
    };
  }

  String _statusHeadline(AlarmStatus status, AppLocalizations l10n) {
    return switch (status) {
      AlarmStatus.idle => l10n.alarmStatusIdle,
      AlarmStatus.lockedPreFajr => l10n.alarmStatusLockedPreFajr,
      AlarmStatus.ringingInitial => l10n.alarmStatusRingingInitial,
      AlarmStatus.snoozed5Min => l10n.alarmStatusSnoozed,
      AlarmStatus.ringingRelentless => l10n.alarmStatusRingingRelentless,
      AlarmStatus.challengeActive => l10n.alarmStatusChallengeActive,
      AlarmStatus.completed => l10n.alarmStatusCompleted,
      AlarmStatus.vacationFrozen => l10n.alarmStatusVacationFrozen,
    };
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
