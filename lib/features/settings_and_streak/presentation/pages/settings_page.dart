import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/appearance_sheet.dart';
import '../../../../core/widgets/barcode_scanner_input.dart';
import '../../../onboarding/domain/entities/onboarding_state_entity.dart';
import '../../../prayer_schedule/domain/entities/fajr_alarm_config.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/settings_extended_cards.dart';
import '../widgets/settings_sheets.dart';

/// Settings, Local-Only KPIs, Vacation Mode, Emergency Quota, and Dry-Run screen.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.barcodeScannerBuilder});

  final BarcodeScannerBuilder? barcodeScannerBuilder;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedVacationDays = 3;
  FajrAlarmConfig? _alarmConfig;
  OnboardingStateEntity? _onboardingState;
  PermissionsGateStatus? _permissionsStatus;
  bool _isRequestingPermissions = false;

  @override
  void initState() {
    super.initState();
    _loadSupplementalSettings();
  }

  Future<void> _loadSupplementalSettings() async {
    final cubit = context.read<SettingsCubit>();
    final config = await cubit.loadAlarmConfig();
    final onboarding = await cubit.loadOnboardingState();
    final perms = await cubit.checkPermissions();
    if (!mounted) return;
    setState(() {
      _alarmConfig = config;
      _onboardingState = onboarding;
      _permissionsStatus = perms;
    });
  }

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
        } else if (state.dryRunJustScheduled) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.settingsDryRunScheduled)),
          );
          context.read<SettingsCubit>().clearNotifications();
        } else if (state.dryRunCancelled) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.settingsDryRunCancelled)),
          );
          context.read<SettingsCubit>().clearNotifications();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.settingsTitle)),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 840),
                      child: ListView(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          18,
                          12,
                          18,
                          28,
                        ),
                        children: [
                          if (state.isWithinLockWindow) ...[
                            _LockWindowBanner(
                              message: l10n.settingsLockWindowNotice,
                            ),
                            const SizedBox(height: 14),
                          ],
                          _KpisCard(state: state, l10n: l10n),
                          const SizedBox(height: 14),
                          _AppearanceCard(state: state, l10n: l10n),
                          const SizedBox(height: 14),
                          _LanguageCard(state: state, l10n: l10n),
                          const SizedBox(height: 14),
                          _VacationModeCard(
                            state: state,
                            l10n: l10n,
                            selectedDays: _selectedVacationDays,
                            onDaysChanged: (days) =>
                                setState(() => _selectedVacationDays = days),
                          ),
                          const SizedBox(height: 14),
                          _EmergencyQuotaCard(state: state, l10n: l10n),
                          const SizedBox(height: 14),
                          _DryRunCard(state: state, l10n: l10n),
                          const SizedBox(height: 14),
                          LocationAndAlarmCard(
                            l10n: l10n,
                            config: _alarmConfig,
                            isLocked: state.isWithinLockWindow,
                            onEditLocationMethod: () =>
                                _openLocationMethodSheet(context),
                            onConfigChanged: (updated) =>
                                _handleAlarmConfigChange(context, updated),
                          ),
                          const SizedBox(height: 14),
                          BathroomBarcodeCard(
                            l10n: l10n,
                            barcode:
                                state.settings.bathroomBarcode ??
                                _onboardingState?.registeredBarcode,
                            isLocked: state.isWithinLockWindow,
                            onOpenSheet: () => _openBarcodeSheet(
                              context,
                              state.settings.bathroomBarcode ??
                                  _onboardingState?.registeredBarcode,
                            ),
                          ),
                          const SizedBox(height: 14),
                          GeminiApiKeyCard(
                            l10n: l10n,
                            onboardingState: _onboardingState,
                            isLocked: state.isWithinLockWindow,
                            onOpenSheet: () => _openApiKeySheet(context),
                          ),
                          const SizedBox(height: 14),
                          PermissionsStatusCard(
                            l10n: l10n,
                            status: _permissionsStatus,
                            isRequesting: _isRequestingPermissions,
                            onRequestPermissions: _requestPermissions,
                            onRefreshPermissions: _refreshPermissions,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future<void> _handleAlarmConfigChange(
    BuildContext context,
    FajrAlarmConfig updated,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();
    final ok = await cubit.updateAlarmConfig(updated);
    if (!mounted || !ok) return;
    setState(() => _alarmConfig = updated);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsAlarmAndLocationSavedMessage)),
    );
  }

  Future<void> _openLocationMethodSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();
    final initial =
        _alarmConfig ??
        const FajrAlarmConfig(
          latitude: 30.0444,
          longitude: 31.2357,
          cityName: 'Cairo',
        );
    final saved = await showLocationMethodSheet(
      context,
      initialConfig: initial,
      onSaveConfig: cubit.updateAlarmConfig,
    );
    if (!mounted || saved == null) return;
    setState(() => _alarmConfig = saved);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.settingsAlarmAndLocationSavedMessage)),
    );
  }

  Future<void> _openBarcodeSheet(
    BuildContext context,
    String? currentBarcode,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();
    final result = await showBathroomBarcodeSheet(
      context,
      initialBarcode: currentBarcode,
      scannerBuilder: widget.barcodeScannerBuilder,
      onSaveBarcode: cubit.updateBathroomBarcode,
    );
    if (!mounted || result == null) return;
    final onboarding = await cubit.loadOnboardingState();
    if (!mounted) return;
    setState(() => _onboardingState = onboarding);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.cleared
              ? l10n.settingsBarcodeClearedMessage
              : l10n.settingsBarcodeSavedMessage,
        ),
      ),
    );
  }

  Future<void> _openApiKeySheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();
    final saved = await showGeminiKeySheet(
      context,
      initialConsentAccepted: _onboardingState?.privacyConsentAccepted ?? false,
      onSaveApiKey: (apiKey, consent) =>
          cubit.updateGeminiApiKey(apiKey: apiKey, consentAccepted: consent),
    );
    if (!mounted || saved != true) return;
    final onboarding = await cubit.loadOnboardingState();
    if (!mounted) return;
    setState(() => _onboardingState = onboarding);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.onboardingKeyValidated)));
  }

  Future<void> _requestPermissions() async {
    if (_isRequestingPermissions) return;
    setState(() => _isRequestingPermissions = true);
    final perms = await context.read<SettingsCubit>().requestPermissions();
    if (!mounted) return;
    setState(() {
      _permissionsStatus = perms ?? _permissionsStatus;
      _isRequestingPermissions = false;
    });
  }

  Future<void> _refreshPermissions() async {
    if (_isRequestingPermissions) return;
    setState(() => _isRequestingPermissions = true);
    final perms = await context.read<SettingsCubit>().checkPermissions();
    if (!mounted) return;
    setState(() {
      _permissionsStatus = perms ?? _permissionsStatus;
      _isRequestingPermissions = false;
    });
  }

  String _localizeFailure(AppLocalizations l10n, Failure failure) {
    return switch (failure) {
      LockWindowFailure() => l10n.settingsErrorLockWindow,
      QuotaExceededFailure() => l10n.settingsErrorQuotaExceeded,
      ValidationFailure() => l10n.settingsErrorValidation,
      ApiFailure() => l10n.onboardingApiKeyInvalidError,
      _ => l10n.commonErrorGeneric,
    };
  }
}

class _LockWindowBanner extends StatelessWidget {
  const _LockWindowBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = FajrDesignTokens.of(context);
    return Container(
      padding: const EdgeInsetsDirectional.all(12),
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
              message,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: tokens.textPrimary),
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
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: FajrDesignTokens.of(context).surfaceElevated,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: FajrDesignTokens.of(context).emeraldSignal
                            .withValues(alpha: 0.45),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.ac_unit,
                          size: 14,
                          color: FajrDesignTokens.of(context).emeraldSignal,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.settingsStreakFrozenBadge,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: FajrDesignTokens.of(context).textPrimary,
                          ),
                        ),
                      ],
                    ),
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
    final tokens = FajrDesignTokens.of(context);
    return Container(
      margin: const EdgeInsetsDirectional.only(end: 8, bottom: 8),
      padding: const EdgeInsetsDirectional.all(14),
      decoration: BoxDecoration(
        color: tokens.surfaceElevated,
        borderRadius: BorderRadius.circular(tokens.radiusControl),
        border: Border.all(color: tokens.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: tokens.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTheme.tabular(
              theme.textTheme.titleLarge,
            ).copyWith(fontWeight: FontWeight.w600, color: tokens.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard({required this.state, required this.l10n});

  final SettingsState state;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final styleLabel = switch (state.settings.designStyle) {
      'sanctuary' => l10n.appearanceDesignSanctuary,
      'editorial' => l10n.appearanceDesignEditorial,
      'liquid' => l10n.appearanceDesignLiquid,
      'desert' => l10n.appearanceDesignDesert,
      'nordic' => l10n.appearanceDesignNordic,
      'velvet' => l10n.appearanceDesignVelvet,
      _ => l10n.appearanceDesignHorizon,
    };
    final modeLabel = switch (state.settings.themeMode) {
      'light' => l10n.appearanceThemeLight,
      'dark' => l10n.appearanceThemeDark,
      _ => l10n.appearanceThemeSystem,
    };

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: const Icon(Icons.palette_outlined),
        title: Text(l10n.appearanceTitle),
        subtitle: Text('$styleLabel · $modeLabel'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => showAppearanceSheet(context),
      ),
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
            if (dateStr != null) ...[
              Text(
                l10n.settingsVacationActiveUntil(dateStr),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                key: const Key('settings_deactivate_vacation_button'),
                onPressed: state.isWithinLockWindow
                    ? null
                    : () => context
                          .read<SettingsCubit>()
                          .deactivateVacationMode(),
                child: Text(l10n.settingsVacationDeactivateButton),
              ),
            ] else ...[
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
            if (state.dryRunScheduledAt != null) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                key: const Key('settings_cancel_dry_run_button'),
                onPressed: state.isWithinLockWindow
                    ? null
                    : () => context.read<SettingsCubit>().cancelDryRunAlarm(),
                icon: const Icon(Icons.alarm_off),
                label: Text(l10n.settingsDryRunCancelButton),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
