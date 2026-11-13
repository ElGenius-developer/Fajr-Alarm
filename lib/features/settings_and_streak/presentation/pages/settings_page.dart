import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

/// Settings, Local-Only KPIs, Vacation Mode, Emergency Quota, and Dry-Run screen.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedVacationDays = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        final messenger = ScaffoldMessenger.of(context);
        if (state.failure != null) {
          messenger.showSnackBar(
            SnackBar(content: Text(_localizeFailure(l10n, state.failure!))),
          );
          context.read<SettingsCubit>().clearNotifications();
        } else if (state.dryRunScheduledAt != null) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.settingsDryRunScheduled)),
          );
          context.read<SettingsCubit>().clearNotifications();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.settingsTitle)),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsetsDirectional.all(16),
                  children: [
                    if (state.isWithinLockWindow) ...[
                      _LockWindowBanner(message: l10n.settingsLockWindowNotice),
                      const SizedBox(height: 12),
                    ],
                    _KpisCard(state: state, l10n: l10n),
                    const SizedBox(height: 12),
                    _LanguageCard(state: state, l10n: l10n),
                    const SizedBox(height: 12),
                    _VacationModeCard(
                      state: state,
                      l10n: l10n,
                      selectedDays: _selectedVacationDays,
                      onDaysChanged: (days) =>
                          setState(() => _selectedVacationDays = days),
                    ),
                    const SizedBox(height: 12),
                    _EmergencyQuotaCard(state: state, l10n: l10n),
                    const SizedBox(height: 12),
                    _DryRunCard(state: state, l10n: l10n),
                  ],
                ),
        );
      },
    );
  }

  String _localizeFailure(AppLocalizations l10n, Failure failure) {
    return switch (failure) {
      LockWindowFailure() => l10n.settingsErrorLockWindow,
      QuotaExceededFailure() => l10n.settingsErrorQuotaExceeded,
      ValidationFailure() => l10n.settingsErrorValidation,
      _ => l10n.commonErrorGeneric,
    };
  }
}

class _LockWindowBanner extends StatelessWidget {
  const _LockWindowBanner({required this.message});

  final String message;

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
              message,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpisCard extends StatelessWidget {
  const _KpisCard({required this.state, required this.l10n});

  final SettingsState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final stats = state.streakStats;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.settingsKpisTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (stats.isFrozen)
                  Chip(
                    avatar: const Icon(Icons.ac_unit, size: 16),
                    label: Text(l10n.settingsStreakFrozenBadge),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _KpiTile(
                    label: l10n.settingsCurrentStreak,
                    value: l10n.settingsStreakDays(stats.currentStreak),
                  ),
                ),
                Expanded(
                  child: _KpiTile(
                    label: l10n.settingsLongestStreak,
                    value: l10n.settingsStreakDays(stats.longestStreak),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _KpiTile(
                    label: l10n.settingsCompletionRate,
                    value: '${stats.completionRate.toStringAsFixed(0)}%',
                  ),
                ),
                Expanded(
                  child: _KpiTile(
                    label: l10n.settingsAvgTimeToWake,
                    value: l10n.settingsMinutesValue(
                      stats.averageTimeToWakeMinutes.toStringAsFixed(1),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleLarge),
      ],
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.state, required this.l10n});

  final SettingsState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsLanguageTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'ar',
                    label: Text(l10n.settingsLanguageArabic),
                  ),
                  ButtonSegment(
                    value: 'en',
                    label: Text(l10n.settingsLanguageEnglish),
                  ),
                ],
                selected: {state.settings.locale},
                onSelectionChanged: (selection) {
                  if (selection.isNotEmpty) {
                    context.read<SettingsCubit>().switchLocale(selection.first);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VacationModeCard extends StatelessWidget {
  const _VacationModeCard({
    required this.state,
    required this.l10n,
    required this.selectedDays,
    required this.onDaysChanged,
  });

  final SettingsState state;
  final AppLocalizations l10n;
  final int selectedDays;
  final ValueChanged<int> onDaysChanged;

  @override
  Widget build(BuildContext context) {
    final vacation = state.settings.vacationMode;
    final theme = Theme.of(context);
    final dateStr = vacation != null
        ? DateFormat.yMMMd(state.settings.locale).format(vacation.endDate)
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsVacationTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.settingsVacationSubtitle,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (dateStr != null)
              Text(
                l10n.settingsVacationActiveUntil(dateStr),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              )
            else ...[
              Row(
                children: [
                  Expanded(child: Text(l10n.settingsVacationDurationLabel)),
                  DropdownButton<int>(
                    value: selectedDays,
                    items: List.generate(
                      30,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text(l10n.settingsStreakDays(index + 1)),
                      ),
                    ),
                    onChanged: state.isWithinLockWindow
                        ? null
                        : (val) {
                            if (val != null) onDaysChanged(val);
                          },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: state.isWithinLockWindow
                    ? null
                    : () => context.read<SettingsCubit>().activateVacationMode(
                        selectedDays,
                      ),
                icon: const Icon(Icons.beach_access),
                label: Text(l10n.settingsVacationActivateButton),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmergencyQuotaCard extends StatelessWidget {
  const _EmergencyQuotaCard({required this.state, required this.l10n});

  final SettingsState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final settings = state.settings;
    final cubit = context.read<SettingsCubit>();
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsEmergencyQuotaTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.settingsEmergencyQuotaRemaining(
                      settings.remainingEmergencyQuota,
                      settings.monthlyEmergencyQuota,
                    ),
                  ),
                ),
                IconButton(
                  onPressed:
                      state.isWithinLockWindow ||
                          settings.monthlyEmergencyQuota <= 0
                      ? null
                      : () => cubit.updateMonthlyEmergencyQuota(
                          settings.monthlyEmergencyQuota - 1,
                        ),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('${settings.monthlyEmergencyQuota}'),
                IconButton(
                  onPressed: state.isWithinLockWindow
                      ? null
                      : () => cubit.updateMonthlyEmergencyQuota(
                          settings.monthlyEmergencyQuota + 1,
                        ),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DryRunCard extends StatelessWidget {
  const _DryRunCard({required this.state, required this.l10n});

  final SettingsState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsDryRunTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.settingsDryRunSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: state.isWithinLockWindow
                  ? null
                  : () => context.read<SettingsCubit>().triggerDryRunAlarm(),
              icon: const Icon(Icons.alarm_on),
              label: Text(l10n.settingsDryRunButton),
            ),
          ],
        ),
      ),
    );
  }
}
