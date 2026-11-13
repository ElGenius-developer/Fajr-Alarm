import 'package:fajr_alarm/core/error/failures.dart';
import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
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
                  key: const Key('schedule_open_settings_button'),
                  icon: const Icon(Icons.settings),
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
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
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

    return ListView(
      padding: const EdgeInsetsDirectional.all(16),
      children: [
        if (isWithinLockWindow) ...[
          _LockWindowBanner(text: l10n.scheduleLockWindowActiveBanner),
          const SizedBox(height: 12),
        ],
        _NextAlarmCard(
          label: l10n.scheduleNextAlarmLabel,
          timeText: nextAlarmTime != null
              ? timeFormat.format(nextAlarmTime!)
              : l10n.scheduleAlarmDisabled,
          todayFajrLabel: l10n.scheduleTodayFajrLabel,
          todayFajrText: schedules.isNotEmpty
              ? timeFormat.format(schedules.first.fajrTime)
              : '--:--',
          sunriseLabel: l10n.scheduleSunriseLabel,
          sunriseText: schedules.isNotEmpty
              ? timeFormat.format(schedules.first.sunriseTime)
              : '--:--',
        ),
        const SizedBox(height: 16),
        _AlarmConfigCard(
          config: config,
          isLocked: isWithinLockWindow,
          onConfigChanged: cubit.updateConfig,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                l10n.schedule30DayTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton.icon(
              onPressed: isWithinLockWindow
                  ? null
                  : () => cubit.updateConfig(config),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.scheduleRecalculateButton),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (schedules.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: Text(l10n.scheduleEmptyState),
            ),
          )
        else
          ...schedules.map(
            (day) => Card(
              child: ListTile(
                title: Text(dateFormat.format(day.date)),
                subtitle: Text(
                  '${l10n.scheduleSunriseLabel}: ${timeFormat.format(day.sunriseTime)}',
                ),
                trailing: Text(
                  timeFormat.format(day.fajrTime),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LockWindowBanner extends StatelessWidget {
  const _LockWindowBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_clock, color: colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextAlarmCard extends StatelessWidget {
  const _NextAlarmCard({
    required this.label,
    required this.timeText,
    required this.todayFajrLabel,
    required this.todayFajrText,
    required this.sunriseLabel,
    required this.sunriseText,
  });

  final String label;
  final String timeText;
  final String todayFajrLabel;
  final String todayFajrText;
  final String sunriseLabel;
  final String sunriseText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(timeText, style: textTheme.displaySmall),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$todayFajrLabel: $todayFajrText'),
                Text('$sunriseLabel: $sunriseText'),
              ],
            ),
          ],
        ),
      ),
    );
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

    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsetsDirectional.zero,
              title: Text(l10n.scheduleEnableSwitchLabel),
              value: config.isEnabled,
              onChanged: isLocked
                  ? null
                  : (enabled) =>
                        onConfigChanged(config.copyWith(isEnabled: enabled)),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 12),
            if (config.mode == FajrAlarmMode.relativeToAdhan)
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
        ),
      ),
    );
  }
}
