import 'package:fajr_alarm/core/l10n/generated/app_localizations.dart';
import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/cubit/settings_cubit.dart';
import 'package:fajr_alarm/features/settings_and_streak/presentation/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Opens the live Appearance & Design selector modal sheet.
Future<void> showAppearanceSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => BlocProvider<SettingsCubit>.value(
      value: context.read<SettingsCubit>(),
      child: const _AppearanceSheetBody(),
    ),
  );
}

class _AppearanceSheetBody extends StatelessWidget {
  const _AppearanceSheetBody();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tokens = FajrDesignTokens.of(context);
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.78,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        builder: (_, scrollController) {
          return BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              final cubit = context.read<SettingsCubit>();
              final brightness = Theme.of(context).brightness;
              return ListView(
                controller: scrollController,
                padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 24),
                children: [
                  Text(
                    l10n.appearanceTitle,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.appearanceThemeModeLabel,
                    style: textTheme.labelLarge?.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'system',
                        icon: const Icon(
                          Icons.brightness_auto_rounded,
                          size: 18,
                        ),
                        label: Text(l10n.appearanceThemeSystem),
                      ),
                      ButtonSegment(
                        value: 'light',
                        icon: const Icon(Icons.light_mode_rounded, size: 18),
                        label: Text(l10n.appearanceThemeLight),
                      ),
                      ButtonSegment(
                        value: 'dark',
                        icon: const Icon(Icons.dark_mode_rounded, size: 18),
                        label: Text(l10n.appearanceThemeDark),
                      ),
                    ],
                    selected: {state.settings.themeMode},
                    onSelectionChanged: (selection) =>
                        cubit.switchThemeMode(selection.first),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.appearanceDesignLabel,
                    style: textTheme.labelLarge?.copyWith(
                      color: tokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _DesignStyleOption(
                    style: AppDesignStyle.horizon,
                    title: l10n.appearanceDesignHorizon,
                    subtitle: l10n.appearanceDesignHorizonDesc,
                    isSelected: state.settings.designStyle == 'horizon',
                    brightness: brightness,
                    onTap: () => cubit.switchDesignStyle('horizon'),
                  ),
                  const SizedBox(height: 10),
                  _DesignStyleOption(
                    style: AppDesignStyle.sanctuary,
                    title: l10n.appearanceDesignSanctuary,
                    subtitle: l10n.appearanceDesignSanctuaryDesc,
                    isSelected: state.settings.designStyle == 'sanctuary',
                    brightness: brightness,
                    onTap: () => cubit.switchDesignStyle('sanctuary'),
                  ),
                  const SizedBox(height: 10),
                  _DesignStyleOption(
                    style: AppDesignStyle.editorial,
                    title: l10n.appearanceDesignEditorial,
                    subtitle: l10n.appearanceDesignEditorialDesc,
                    isSelected: state.settings.designStyle == 'editorial',
                    brightness: brightness,
                    onTap: () => cubit.switchDesignStyle('editorial'),
                  ),
                  const SizedBox(height: 10),
                  _DesignStyleOption(
                    style: AppDesignStyle.liquid,
                    title: l10n.appearanceDesignLiquid,
                    subtitle: l10n.appearanceDesignLiquidDesc,
                    isSelected: state.settings.designStyle == 'liquid',
                    brightness: brightness,
                    onTap: () => cubit.switchDesignStyle('liquid'),
                  ),
                  const SizedBox(height: 10),
                  _DesignStyleOption(
                    style: AppDesignStyle.desert,
                    title: l10n.appearanceDesignDesert,
                    subtitle: l10n.appearanceDesignDesertDesc,
                    isSelected: state.settings.designStyle == 'desert',
                    brightness: brightness,
                    onTap: () => cubit.switchDesignStyle('desert'),
                  ),
                  const SizedBox(height: 10),
                  _DesignStyleOption(
                    style: AppDesignStyle.nordic,
                    title: l10n.appearanceDesignNordic,
                    subtitle: l10n.appearanceDesignNordicDesc,
                    isSelected: state.settings.designStyle == 'nordic',
                    brightness: brightness,
                    onTap: () => cubit.switchDesignStyle('nordic'),
                  ),
                  const SizedBox(height: 10),
                  _DesignStyleOption(
                    style: AppDesignStyle.velvet,
                    title: l10n.appearanceDesignVelvet,
                    subtitle: l10n.appearanceDesignVelvetDesc,
                    isSelected: state.settings.designStyle == 'velvet',
                    brightness: brightness,
                    onTap: () => cubit.switchDesignStyle('velvet'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _DesignStyleOption extends StatelessWidget {
  const _DesignStyleOption({
    required this.style,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.brightness,
    required this.onTap,
  });

  final AppDesignStyle style;
  final String title;
  final String subtitle;
  final bool isSelected;
  final Brightness brightness;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final preview = AppTheme.tokensFor(style, brightness);
    final activeTokens = FajrDesignTokens.of(context);
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(activeTokens.radiusControl),
      child: Container(
        padding: const EdgeInsetsDirectional.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? activeTokens.surfaceElevated
              : activeTokens.surface,
          borderRadius: BorderRadius.circular(activeTokens.radiusControl),
          border: Border.all(
            color: isSelected
                ? activeTokens.dawnAccent
                : activeTokens.borderSubtle,
            width: isSelected ? 1.5 : activeTokens.borderWidth,
          ),
        ),
        child: Row(
          children: [
            _PaletteSwatch(tokens: preview),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: activeTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: activeTokens.dawnAccent),
          ],
        ),
      ),
    );
  }
}

class _PaletteSwatch extends StatelessWidget {
  const _PaletteSwatch({required this.tokens});

  final FajrDesignTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: tokens.canvas,
        borderRadius: BorderRadius.circular(tokens.radiusControl),
        border: Border.all(color: tokens.borderSubtle),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: tokens.dawnAccent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: tokens.emeraldSignal,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
