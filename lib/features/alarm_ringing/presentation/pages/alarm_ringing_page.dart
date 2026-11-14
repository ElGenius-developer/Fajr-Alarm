import 'dart:math' as math;

import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:fajr_alarm/features/alarm_ringing/domain/entities/alarm_status.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_bloc.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_event.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/bloc/alarm_ringing_state.dart';
import 'package:fajr_alarm/features/alarm_ringing/presentation/widgets/emergency_override_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lock-screen / full-screen alarm ringing UI obeying 60-30-10 Quiet Dawn (FR-02, FR-6.2).
class AlarmRingingPage extends StatelessWidget {
  const AlarmRingingPage({super.key, this.onStartChallenge});

  final VoidCallback? onStartChallenge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final tokens = FajrDesignTokens.of(context);

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

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 22,
                    vertical: 18,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: math.max(0, constraints.maxHeight - 36),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            if (state.entity.isDryRun)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 12,
                                ),
                                child: Chip(
                                  label: Text(l10n.alarmDryRunBadge),
                                  avatar: Icon(
                                    Icons.science_outlined,
                                    size: 16,
                                    color: tokens.dawnAccent,
                                  ),
                                ),
                              ),
                            if (status == AlarmStatus.ringingRelentless)
                              Container(
                                margin: const EdgeInsetsDirectional.only(
                                  bottom: 16,
                                ),
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: tokens.surfaceElevated,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: tokens.borderSubtle,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: tokens.clayError,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        l10n.alarmRelentlessLoopHint,
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                              color: tokens.textSecondary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(
                              width: 152,
                              height: 152,
                              child: CustomPaint(
                                painter: _AlarmRingPainter(
                                  trackColor: tokens.surfaceElevated,
                                  arcColor: _statusColor(status, tokens),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      color: tokens.surface,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: tokens.borderSubtle,
                                      ),
                                    ),
                                    child: Icon(
                                      _statusIcon(status),
                                      size: 36,
                                      color: _statusColor(status, tokens),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _statusHeadline(status, l10n),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: tokens.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (status == AlarmStatus.snoozed5Min) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: tokens.surfaceElevated,
                                  borderRadius: BorderRadius.circular(
                                    tokens.radiusControl,
                                  ),
                                  border: Border.all(
                                    color: tokens.borderSubtle,
                                  ),
                                ),
                                child: Text(
                                  l10n.alarmSnoozeCountdown(
                                    _formatDuration(
                                      state.snoozeRemainingSeconds,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  style: AppTheme.tabular(
                                    theme.textTheme.titleLarge,
                                  ).copyWith(color: tokens.dawnAccent),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (isRingingOrSnoozed) ...[
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: const EdgeInsetsDirectional.all(16),
                                decoration: BoxDecoration(
                                  color: tokens.surface,
                                  borderRadius: BorderRadius.circular(
                                    tokens.radiusCard,
                                  ),
                                  border: Border.all(
                                    color: tokens.borderSubtle,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 3,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: tokens.dawnAccent,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        l10n.alarmChallengeRuleHint,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: tokens.textSecondary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
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
                              const SizedBox(height: 16),
                              EmergencyOverrideButton(
                                isMuted: state.isEmergencyMuted,
                                elapsedSeconds:
                                    state.emergencyHoldElapsedSeconds,
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
                          ),
                        ] else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                );
              },
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

  Color _statusColor(AlarmStatus status, FajrDesignTokens tokens) {
    return switch (status) {
      AlarmStatus.ringingRelentless => tokens.clayError,
      AlarmStatus.completed => tokens.emeraldSignal,
      AlarmStatus.vacationFrozen => tokens.emeraldSignal,
      _ => tokens.dawnAccent,
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

class _AlarmRingPainter extends CustomPainter {
  const _AlarmRingPainter({required this.trackColor, required this.arcColor});

  final Color trackColor;
  final Color arcColor;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 4.5;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - stroke) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(center, radius, trackPaint);

    final arcPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 1.45,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_AlarmRingPainter oldDelegate) =>
      trackColor != oldDelegate.trackColor || arcColor != oldDelegate.arcColor;
}
