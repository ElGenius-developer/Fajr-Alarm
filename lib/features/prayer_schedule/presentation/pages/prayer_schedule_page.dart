import 'dart:math' as math;

import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:fajr_alarm/core/theme/appearance_sheet.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/fajr_alarm_config.dart';
import 'package:fajr_alarm/features/prayer_schedule/domain/entities/prayer_schedule.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/bloc/prayer_schedule_cubit.dart';
import 'package:fajr_alarm/features/prayer_schedule/presentation/bloc/prayer_schedule_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Displays the 30-day rolling Fajr schedule and alarm timing configuration.
class PrayerSchedulePage extends StatelessWidget {
  const PrayerSchedulePage({super.key, this.onOpenSettings});

  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scheduleTitle),
        actions: onOpenSettings != null
            ? <Widget>[
                IconButton(
                  key: const Key('schedule_open_appearance_button'),
                  icon: const Icon(Icons.palette_outlined),
                  tooltip: l10n.appearanceTitle,
                  onPressed: () => showAppearanceSheet(context),
                ),
                IconButton(
                  key: const Key('schedule_open_settings_button'),
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: l10n.navSettings,
                  onPressed: onOpenSettings,
                ),
              ]
            : null,
      ),
      body: BlocConsumer<PrayerScheduleCubit, PrayerScheduleState>(
        listenWhen: (previous, current) =>
            current is PrayerScheduleLoaded && current.actionFailure != null,
        listener: (context, state) {
          if (state is PrayerScheduleLoaded && state.actionFailure != null) {
            final message = switch (state.actionFailure!) {
              LockWindowFailure() => l10n.scheduleErrorLockWindow,
              _ => l10n.commonErrorGeneric,
            };
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }
        },
        builder: (context, state) {
          return switch (state) {
            PrayerScheduleInitial() || PrayerScheduleLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            PrayerScheduleError(:final failure) => _ErrorView(
              message: switch (failure) {
                LockWindowFailure() => l10n.scheduleErrorLockWindow,
                _ => l10n.commonErrorGeneric,
              },
              retryLabel: l10n.commonRetry,
              onRetry: () => context.read<PrayerScheduleCubit>().loadSchedule(),
            ),
            PrayerScheduleLoaded(
              :final config,
              :final schedules,
              :final nextAlarmTime,
              :final isWithinLockWindow,
            ) =>
              _ScheduleLoadedBody(
                config: config,
                schedules: schedules,
                nextAlarmTime: nextAlarmTime,
                isWithinLockWindow: isWithinLockWindow,
              ),
          };
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: Text(retryLabel)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleLoadedBody extends StatelessWidget {
  const _ScheduleLoadedBody({
    required this.config,
    required this.schedules,
    required this.nextAlarmTime,
    required this.isWithinLockWindow,
  });

  final FajrAlarmConfig config;
  final List<PrayerSchedule> schedules;
  final DateTime? nextAlarmTime;
  final bool isWithinLockWindow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final timeFormat = DateFormat.jm(locale);
    final dateFormat = DateFormat.MMMd(locale);
    final cubit = context.read<PrayerScheduleCubit>();

    final heroCard = _NextAlarmHeroCard(
      label: l10n.scheduleNextAlarmLabel,
      timeText: nextAlarmTime != null
          ? timeFormat.format(nextAlarmTime!)
          : l10n.scheduleAlarmDisabled,
      isEnabled: config.isEnabled && nextAlarmTime != null,
      locationLabel:
          '${_localizedCity(l10n, config.cityName)} · ${_localizedMethod(l10n, config.calculationMethod)}',
      onChangeLocation: isWithinLockWindow
          ? null
          : () => _showLocationMethodSheet(context, config, cubit),
      todayFajrLabel: l10n.scheduleTodayFajrLabel,
      todayFajrText: schedules.isNotEmpty
          ? timeFormat.format(schedules.first.fajrTime)
          : '--:--',
      sunriseLabel: l10n.scheduleSunriseLabel,
      sunriseText: schedules.isNotEmpty
          ? timeFormat.format(schedules.first.sunriseTime)
          : '--:--',
    );

    final controlsCard = _AlarmConfigCard(
      config: config,
      isLocked: isWithinLockWindow,
      onConfigChanged: cubit.updateConfig,
    );

    final scheduleSection = _ThirtyDayScheduleSection(
      title: l10n.schedule30DayTitle,
      recalculateLabel: l10n.scheduleRecalculateButton,
      emptyLabel: l10n.scheduleEmptyState,
      sunriseLabel: l10n.scheduleSunriseLabel,
      schedules: schedules,
      isLocked: isWithinLockWindow,
      timeFormat: timeFormat,
      dateFormat: dateFormat,
      onRecalculate: () => cubit.updateConfig(config),
    );

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 680;
              if (isWide) {
                return SingleChildScrollView(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isWithinLockWindow) ...[
                        _LockWindowBanner(
                          text: l10n.scheduleLockWindowActiveBanner,
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                heroCard,
                                const SizedBox(height: 16),
                                controlsCard,
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(flex: 6, child: scheduleSection),
                        ],
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsetsDirectional.fromSTEB(18, 12, 18, 28),
                children: [
                  if (isWithinLockWindow) ...[
                    _LockWindowBanner(
                      text: l10n.scheduleLockWindowActiveBanner,
                    ),
                    const SizedBox(height: 14),
                  ],
                  heroCard,
                  const SizedBox(height: 16),
                  controlsCard,
                  const SizedBox(height: 24),
                  scheduleSection,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LockWindowBanner extends StatelessWidget {
  const _LockWindowBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = FajrDesignTokens.of(context);
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceElevated,
        borderRadius: BorderRadius.circular(tokens.radiusControl),
        border: Border.all(color: tokens.clayError.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_clock, color: tokens.clayError, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: tokens.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextAlarmHeroCard extends StatelessWidget {
  const _NextAlarmHeroCard({
    required this.label,
    required this.timeText,
    required this.isEnabled,
    required this.locationLabel,
    required this.onChangeLocation,
    required this.todayFajrLabel,
    required this.todayFajrText,
    required this.sunriseLabel,
    required this.sunriseText,
  });

  final String label;
  final String timeText;
  final bool isEnabled;
  final String locationLabel;
  final VoidCallback? onChangeLocation;
  final String todayFajrLabel;
  final String todayFajrText;
  final String sunriseLabel;
  final String sunriseText;

  @override
  Widget build(BuildContext context) {
    final tokens = FajrDesignTokens.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isEditorial = tokens.style == AppDesignStyle.editorial;

    return Container(
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(tokens.radiusCard),
        border: Border.all(
          color: tokens.borderSubtle,
          width: tokens.borderWidth,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(tokens.radiusCard),
        child: Stack(
          children: [
            PositionedDirectional(
              top: 16,
              bottom: 16,
              start: 0,
              width: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isEnabled ? tokens.dawnAccent : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: switch (tokens.style) {
                  AppDesignStyle.horizon => _DawnHorizonPainter(
                    arcColor: (isEnabled ? tokens.dawnAccent : tokens.textMuted)
                        .withValues(alpha: 0.14),
                    dotColor: (isEnabled ? tokens.dawnAccent : tokens.textMuted)
                        .withValues(alpha: 0.25),
                  ),
                  AppDesignStyle.sanctuary => _SanctuaryArchPainter(
                    archColor:
                        (isEnabled ? tokens.dawnAccent : tokens.textMuted)
                            .withValues(alpha: 0.14),
                    accentColor: isEnabled
                        ? tokens.emeraldSignal
                        : tokens.textMuted,
                  ),
                  AppDesignStyle.editorial => _EditorialGridPainter(
                    lineColor: tokens.borderSubtle,
                    accentColor: isEnabled
                        ? tokens.dawnAccent
                        : tokens.textMuted,
                  ),
                  AppDesignStyle.liquid => _LiquidGlassPainter(
                    ringColor:
                        (isEnabled ? tokens.dawnAccent : tokens.textMuted)
                            .withValues(alpha: 0.14),
                    highlightColor: tokens.emeraldSignal.withValues(
                      alpha: 0.12,
                    ),
                  ),
                  AppDesignStyle.desert => _DesertDunesPainter(
                    duneColor:
                        (isEnabled ? tokens.dawnAccent : tokens.textMuted)
                            .withValues(alpha: 0.14),
                    crestColor: tokens.emeraldSignal.withValues(alpha: 0.12),
                  ),
                  AppDesignStyle.nordic => _NordicHorizonPainter(
                    lineColor:
                        (isEnabled ? tokens.dawnAccent : tokens.textMuted)
                            .withValues(alpha: 0.16),
                    accentColor: tokens.emeraldSignal,
                  ),
                  AppDesignStyle.velvet => _VelvetOrbitPainter(
                    orbitColor:
                        (isEnabled ? tokens.dawnAccent : tokens.textMuted)
                            .withValues(alpha: 0.14),
                    starColor: isEnabled
                        ? tokens.emeraldSignal
                        : tokens.textMuted,
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(22, 22, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        isEnabled
                            ? Icons.wb_twilight_rounded
                            : Icons.notifications_off_outlined,
                        size: 16,
                        color: isEnabled ? tokens.dawnAccent : tokens.textMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          style: textTheme.labelLarge?.copyWith(
                            color: tokens.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.surfaceElevated,
                      borderRadius: BorderRadius.circular(tokens.radiusControl),
                      border: Border.all(color: tokens.borderSubtle),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        timeText,
                        style: AppTheme.tabular(textTheme.displayMedium)
                            .copyWith(
                              color: isEnabled
                                  ? tokens.textPrimary
                                  : tokens.textMuted,
                              fontWeight: isEditorial
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              letterSpacing: -1.0,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: onChangeLocation,
                    borderRadius: BorderRadius.circular(tokens.radiusControl),
                    child: Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: tokens.surfaceElevated,
                        borderRadius: BorderRadius.circular(
                          tokens.radiusControl,
                        ),
                        border: Border.all(color: tokens.borderSubtle),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: tokens.dawnAccent,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              locationLabel,
                              style: textTheme.bodySmall?.copyWith(
                                color: tokens.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (onChangeLocation != null) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 16,
                              color: tokens.textSecondary,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Divider(color: tokens.borderSubtle, height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _HeroMetaColumn(
                          label: todayFajrLabel,
                          value: todayFajrText,
                          accentColor: tokens.emeraldSignal,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 28,
                        color: tokens.borderSubtle,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 16),
                          child: _HeroMetaColumn(
                            label: sunriseLabel,
                            value: sunriseText,
                            accentColor: tokens.dawnAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroMetaColumn extends StatelessWidget {
  const _HeroMetaColumn({
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final tokens = FajrDesignTokens.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: tokens.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.tabular(textTheme.titleMedium)
              .copyWith(color: tokens.textPrimary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _DawnHorizonPainter extends CustomPainter {
  const _DawnHorizonPainter({required this.arcColor, required this.dotColor});

  final Color arcColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final arcPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25;

    final rect = Rect.fromLTWH(
      -size.width * 0.1,
      size.height * 0.25,
      size.width * 1.2,
      size.height * 1.4,
    );
    canvas.drawArc(rect, math.pi * 1.08, math.pi * 0.84, false, arcPaint);

    final glowPaint = Paint()
      ..color = dotColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.86, size.height * 0.31),
      3.5,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DawnHorizonPainter oldDelegate) {
    return oldDelegate.arcColor != arcColor || oldDelegate.dotColor != dotColor;
  }
}

class _AlarmConfigCard extends StatelessWidget {
  const _AlarmConfigCard({
    required this.config,
    required this.isLocked,
    required this.onConfigChanged,
  });

  final FajrAlarmConfig config;
  final bool isLocked;
  final ValueChanged<FajrAlarmConfig> onConfigChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = FajrDesignTokens.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(18, 10, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsetsDirectional.zero,
              title: Text(
                l10n.scheduleEnableSwitchLabel,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              value: config.isEnabled,
              onChanged: isLocked
                  ? null
                  : (enabled) =>
                        onConfigChanged(config.copyWith(isEnabled: enabled)),
            ),
            Divider(color: tokens.borderSubtle, height: 1),
            const SizedBox(height: 14),
            SegmentedButton<FajrAlarmMode>(
              segments: [
                ButtonSegment(
                  value: FajrAlarmMode.relativeToAdhan,
                  label: Text(l10n.scheduleModeRelative),
                ),
                ButtonSegment(
                  value: FajrAlarmMode.manualTime,
                  label: Text(l10n.scheduleModeManual),
                ),
              ],
              selected: {config.mode},
              onSelectionChanged: isLocked
                  ? null
                  : (selection) =>
                        onConfigChanged(config.copyWith(mode: selection.first)),
            ),
            if (config.mode == FajrAlarmMode.relativeToAdhan) ...[
              const SizedBox(height: 12),
              SegmentedButton<FajrOffsetDirection>(
                segments: [
                  ButtonSegment(
                    value: FajrOffsetDirection.before,
                    label: Text(l10n.scheduleOffsetBefore),
                  ),
                  ButtonSegment(
                    value: FajrOffsetDirection.at,
                    label: Text(l10n.scheduleOffsetAt),
                  ),
                  ButtonSegment(
                    value: FajrOffsetDirection.after,
                    label: Text(l10n.scheduleOffsetAfter),
                  ),
                ],
                selected: {config.offsetDirection},
                onSelectionChanged: isLocked
                    ? null
                    : (selection) => onConfigChanged(
                        config.copyWith(offsetDirection: selection.first),
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ThirtyDayScheduleSection extends StatelessWidget {
  const _ThirtyDayScheduleSection({
    required this.title,
    required this.recalculateLabel,
    required this.emptyLabel,
    required this.sunriseLabel,
    required this.schedules,
    required this.isLocked,
    required this.timeFormat,
    required this.dateFormat,
    required this.onRecalculate,
  });

  final String title;
  final String recalculateLabel;
  final String emptyLabel;
  final String sunriseLabel;
  final List<PrayerSchedule> schedules;
  final bool isLocked;
  final DateFormat timeFormat;
  final DateFormat dateFormat;
  final VoidCallback onRecalculate;

  @override
  Widget build(BuildContext context) {
    final tokens = FajrDesignTokens.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton.icon(
              onPressed: isLocked ? null : onRecalculate,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(recalculateLabel),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (schedules.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(20),
              child: Text(emptyLabel, textAlign: TextAlign.center),
            ),
          )
        else
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: schedules.length,
              separatorBuilder: (_, _) =>
                  Divider(color: tokens.borderSubtle, height: 1),
              itemBuilder: (context, index) {
                final day = schedules[index];
                final isToday = index == 0;
                return Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateFormat.format(day.date),
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: isToday
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isToday
                                    ? tokens.dawnAccent
                                    : tokens.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$sunriseLabel: ${timeFormat.format(day.sunriseTime)}',
                              style: AppTheme.tabular(textTheme.bodySmall)
                                  .copyWith(color: tokens.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: tokens.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: isToday
                              ? Border.all(
                                  color: tokens.dawnAccent.withValues(
                                    alpha: 0.55,
                                  ),
                                )
                              : Border.all(color: tokens.borderSubtle),
                        ),
                        child: Text(
                          timeFormat.format(day.fajrTime),
                          style: AppTheme.tabular(textTheme.titleMedium)
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: isToday
                                    ? tokens.dawnAccent
                                    : tokens.textPrimary,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _SanctuaryArchPainter extends CustomPainter {
  const _SanctuaryArchPainter({
    required this.archColor,
    required this.accentColor,
  });

  final Color archColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = archColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final path = Path()
      ..moveTo(size.width * 0.62, size.height)
      ..lineTo(size.width * 0.62, size.height * 0.42)
      ..quadraticBezierTo(
        size.width * 0.62,
        size.height * 0.12,
        size.width * 0.78,
        size.height * 0.06,
      )
      ..quadraticBezierTo(
        size.width * 0.94,
        size.height * 0.12,
        size.width * 0.94,
        size.height * 0.42,
      )
      ..lineTo(size.width * 0.94, size.height);
    canvas.drawPath(path, paint);

    final starPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.24),
      3,
      starPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SanctuaryArchPainter oldDelegate) {
    return oldDelegate.archColor != archColor ||
        oldDelegate.accentColor != accentColor;
  }
}

class _EditorialGridPainter extends CustomPainter {
  const _EditorialGridPainter({
    required this.lineColor,
    required this.accentColor,
  });

  final Color lineColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 3.5), barPaint);

    final gridPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.75;
    canvas.drawLine(
      Offset(size.width * 0.72, 0),
      Offset(size.width * 0.72, size.height * 0.65),
      gridPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _EditorialGridPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.accentColor != accentColor;
  }
}

String _localizedCity(AppLocalizations l10n, String? cityKey) {
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
    _ => cityKey ?? l10n.cityCairo,
  };
}

String _localizedMethod(AppLocalizations l10n, FajrCalculationMethod method) {
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

Future<void> _showLocationMethodSheet(
  BuildContext context,
  FajrAlarmConfig currentConfig,
  PrayerScheduleCubit cubit,
) {
  const cities =
      <({String key, double lat, double lng, FajrCalculationMethod method})>[
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

  const methods = <FajrCalculationMethod>[
    FajrCalculationMethod.egyptian,
    FajrCalculationMethod.ummAlQura,
    FajrCalculationMethod.muslimWorldLeague,
    FajrCalculationMethod.northAmerica,
    FajrCalculationMethod.karachi,
    FajrCalculationMethod.dubai,
    FajrCalculationMethod.turkey,
  ];

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      final l10n = AppLocalizations.of(sheetContext)!;
      final tokens = FajrDesignTokens.of(sheetContext);
      final textTheme = Theme.of(sheetContext).textTheme;
      return SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.45,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
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
                  children: cities.map((city) {
                    final selected = currentConfig.cityName == city.key;
                    return ChoiceChip(
                      label: Text(_localizedCity(l10n, city.key)),
                      selected: selected,
                      onSelected: (_) {
                        cubit.updateConfig(
                          currentConfig.copyWith(
                            latitude: city.lat,
                            longitude: city.lng,
                            cityName: city.key,
                            calculationMethod: city.method,
                          ),
                        );
                        Navigator.of(sheetContext).pop();
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Divider(color: tokens.borderSubtle, height: 1),
                const SizedBox(height: 16),
                Text(
                  l10n.scheduleSelectMethodTitle,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...methods.map((method) {
                  final selected = currentConfig.calculationMethod == method;
                  return ListTile(
                    contentPadding: EdgeInsetsDirectional.zero,
                    title: Text(_localizedMethod(l10n, method)),
                    trailing: selected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: tokens.dawnAccent,
                          )
                        : null,
                    onTap: () {
                      cubit.updateConfig(
                        currentConfig.copyWith(calculationMethod: method),
                      );
                      Navigator.of(sheetContext).pop();
                    },
                  );
                }),
              ],
            );
          },
        ),
      );
    },
  );
}

class _LiquidGlassPainter extends CustomPainter {
  const _LiquidGlassPainter({
    required this.ringColor,
    required this.highlightColor,
  });

  final Color ringColor;
  final Color highlightColor;

  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25;
    final center = Offset(size.width * 0.82, size.height * 0.25);
    canvas.drawCircle(center, size.height * 0.26, ringPaint);
    canvas.drawCircle(center, size.height * 0.44, ringPaint);

    final glowPaint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.14, size.height * 0.14),
      size.height * 0.18,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LiquidGlassPainter oldDelegate) {
    return oldDelegate.ringColor != ringColor ||
        oldDelegate.highlightColor != highlightColor;
  }
}

class _DesertDunesPainter extends CustomPainter {
  const _DesertDunesPainter({
    required this.duneColor,
    required this.crestColor,
  });

  final Color duneColor;
  final Color crestColor;

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Paint()
      ..color = duneColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final path1 = Path()
      ..moveTo(0, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.44,
        size.width * 0.72,
        size.height * 0.58,
      )
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height * 0.65,
        size.width,
        size.height * 0.52,
      );
    canvas.drawPath(path1, p1);

    final p2 = Paint()
      ..color = crestColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    final path2 = Path()
      ..moveTo(0, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.54,
        size.width,
        size.height * 0.68,
      );
    canvas.drawPath(path2, p2);
  }

  @override
  bool shouldRepaint(covariant _DesertDunesPainter oldDelegate) {
    return oldDelegate.duneColor != duneColor ||
        oldDelegate.crestColor != crestColor;
  }
}

class _NordicHorizonPainter extends CustomPainter {
  const _NordicHorizonPainter({
    required this.lineColor,
    required this.accentColor,
  });

  final Color lineColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = lineColor
      ..strokeWidth = 1.2;
    canvas.drawLine(
      Offset(0, size.height * 0.58),
      Offset(size.width, size.height * 0.58),
      p,
    );

    final dot = Paint()
      ..color = accentColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.84, size.height * 0.58), 3.5, dot);
  }

  @override
  bool shouldRepaint(covariant _NordicHorizonPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.accentColor != accentColor;
  }
}

class _VelvetOrbitPainter extends CustomPainter {
  const _VelvetOrbitPainter({
    required this.orbitColor,
    required this.starColor,
  });

  final Color orbitColor;
  final Color starColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = orbitColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.78, size.height * 0.32),
        width: size.width * 0.55,
        height: size.height * 0.42,
      ),
      paint,
    );

    final starPaint = Paint()
      ..color = starColor.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.16),
      3,
      starPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _VelvetOrbitPainter oldDelegate) {
    return oldDelegate.orbitColor != orbitColor ||
        oldDelegate.starColor != starColor;
  }
}
