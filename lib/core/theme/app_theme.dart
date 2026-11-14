import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Selectable visual design presets for Fajr-Alarm.
enum AppDesignStyle {
  horizon('horizon'),
  sanctuary('sanctuary'),
  editorial('editorial'),
  liquid('liquid'),
  desert('desert'),
  nordic('nordic'),
  velvet('velvet');

  const AppDesignStyle(this.storageKey);

  final String storageKey;

  static AppDesignStyle fromKey(String key) {
    return switch (key) {
      'sanctuary' => AppDesignStyle.sanctuary,
      'editorial' => AppDesignStyle.editorial,
      'liquid' => AppDesignStyle.liquid,
      'desert' => AppDesignStyle.desert,
      'nordic' => AppDesignStyle.nordic,
      'velvet' => AppDesignStyle.velvet,
      _ => AppDesignStyle.horizon,
    };
  }
}

/// Semantic 60-30-10 low-saturation design tokens supporting Light & Dark modes.
@immutable
class FajrDesignTokens extends ThemeExtension<FajrDesignTokens> {
  const FajrDesignTokens({
    required this.style,
    required this.canvas,
    required this.surface,
    required this.surfaceElevated,
    required this.borderSubtle,
    required this.dawnAccent,
    required this.dawnGlow,
    required this.emeraldSignal,
    this.clayError = const Color(0xFFB86B6B),
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.radiusCard,
    required this.radiusControl,
    required this.borderWidth,
  });

  final AppDesignStyle style;
  final Color canvas;
  final Color surface;
  final Color surfaceElevated;
  final Color borderSubtle;
  final Color dawnAccent;
  final Color dawnGlow;
  final Color emeraldSignal;
  final Color clayError;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final double radiusCard;
  final double radiusControl;
  final double borderWidth;

  static FajrDesignTokens of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<FajrDesignTokens>() ??
        AppTheme.tokensFor(AppDesignStyle.horizon, theme.brightness);
  }

  @override
  FajrDesignTokens copyWith({
    AppDesignStyle? style,
    Color? canvas,
    Color? surface,
    Color? surfaceElevated,
    Color? borderSubtle,
    Color? dawnAccent,
    Color? dawnGlow,
    Color? emeraldSignal,
    Color? clayError,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    double? radiusCard,
    double? radiusControl,
    double? borderWidth,
  }) {
    return FajrDesignTokens(
      style: style ?? this.style,
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      dawnAccent: dawnAccent ?? this.dawnAccent,
      dawnGlow: dawnGlow ?? this.dawnGlow,
      emeraldSignal: emeraldSignal ?? this.emeraldSignal,
      clayError: clayError ?? this.clayError,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      radiusCard: radiusCard ?? this.radiusCard,
      radiusControl: radiusControl ?? this.radiusControl,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  FajrDesignTokens lerp(ThemeExtension<FajrDesignTokens>? other, double t) {
    if (other is! FajrDesignTokens) return this;
    return FajrDesignTokens(
      style: t < 0.5 ? style : other.style,
      canvas: Color.lerp(canvas, other.canvas, t) ?? canvas,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      surfaceElevated:
          Color.lerp(surfaceElevated, other.surfaceElevated, t) ??
          surfaceElevated,
      borderSubtle:
          Color.lerp(borderSubtle, other.borderSubtle, t) ?? borderSubtle,
      dawnAccent: Color.lerp(dawnAccent, other.dawnAccent, t) ?? dawnAccent,
      dawnGlow: Color.lerp(dawnGlow, other.dawnGlow, t) ?? dawnGlow,
      emeraldSignal:
          Color.lerp(emeraldSignal, other.emeraldSignal, t) ?? emeraldSignal,
      clayError: Color.lerp(clayError, other.clayError, t) ?? clayError,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      radiusCard: lerpDouble(radiusCard, other.radiusCard, t) ?? radiusCard,
      radiusControl:
          lerpDouble(radiusControl, other.radiusControl, t) ?? radiusControl,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t) ?? borderWidth,
    );
  }
}

/// Application Material 3 themes following strict low-saturation 60-30-10 ratios.
abstract final class AppTheme {
  static FajrDesignTokens tokensFor(
    AppDesignStyle style,
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;
    return switch (style) {
      // Quiet Dawn (Dark) / Quiet Limestone (Light) — approved Stitch v2 default
      AppDesignStyle.horizon =>
        isDark
            ? const FajrDesignTokens(
                style: AppDesignStyle.horizon,
                canvas: Color(0xFF12151B),
                surface: Color(0xFF1B2029),
                surfaceElevated: Color(0xFF222834),
                borderSubtle: Color(0xFF2B3240),
                dawnAccent: Color(0xFFC8A97E),
                dawnGlow: Color(0x16C8A97E),
                emeraldSignal: Color(0xFF6E9F86),
                clayError: Color(0xFFB86B6B),
                textPrimary: Color(0xFFECEFF4),
                textSecondary: Color(0xFF9AA3B2),
                textMuted: Color(0xFF6E7787),
                radiusCard: 20,
                radiusControl: 14,
                borderWidth: 1,
              )
            : const FajrDesignTokens(
                style: AppDesignStyle.horizon,
                canvas: Color(0xFFF5F3EF),
                surface: Color(0xFFFAF9F6),
                surfaceElevated: Color(0xFFEAE6DF),
                borderSubtle: Color(0xFFDDD8CE),
                dawnAccent: Color(0xFF8C6D46),
                dawnGlow: Color(0x128C6D46),
                emeraldSignal: Color(0xFF4B7A63),
                clayError: Color(0xFF9E5252),
                textPrimary: Color(0xFF1E232B),
                textSecondary: Color(0xFF5A6270),
                textMuted: Color(0xFF7D8593),
                radiusCard: 20,
                radiusControl: 14,
                borderWidth: 1,
              ),
      AppDesignStyle.sanctuary =>
        isDark
            ? const FajrDesignTokens(
                style: AppDesignStyle.sanctuary,
                canvas: Color(0xFF0E1613),
                surface: Color(0xFF16221E),
                surfaceElevated: Color(0xFF1D2B26),
                borderSubtle: Color(0xFF283B34),
                dawnAccent: Color(0xFF6FA38B),
                dawnGlow: Color(0x146FA38B),
                emeraldSignal: Color(0xFFB99E6B),
                clayError: Color(0xFFB86B6B),
                textPrimary: Color(0xFFE8EFEA),
                textSecondary: Color(0xFF99ADA3),
                textMuted: Color(0xFF6A8075),
                radiusCard: 22,
                radiusControl: 14,
                borderWidth: 1,
              )
            : const FajrDesignTokens(
                style: AppDesignStyle.sanctuary,
                canvas: Color(0xFFF2F5F3),
                surface: Color(0xFFFAFCFA),
                surfaceElevated: Color(0xFFE5ECE8),
                borderSubtle: Color(0xFFD5E0DA),
                dawnAccent: Color(0xFF477660),
                dawnGlow: Color(0x12477660),
                emeraldSignal: Color(0xFF947A4B),
                clayError: Color(0xFF9E5252),
                textPrimary: Color(0xFF1B2922),
                textSecondary: Color(0xFF52665C),
                textMuted: Color(0xFF75897F),
                radiusCard: 22,
                radiusControl: 14,
                borderWidth: 1,
              ),
      AppDesignStyle.editorial =>
        isDark
            ? const FajrDesignTokens(
                style: AppDesignStyle.editorial,
                canvas: Color(0xFF121212),
                surface: Color(0xFF1B1B1B),
                surfaceElevated: Color(0xFF242424),
                borderSubtle: Color(0xFF323232),
                dawnAccent: Color(0xFFB86957),
                dawnGlow: Color(0x00000000),
                emeraldSignal: Color(0xFF699878),
                clayError: Color(0xFFB86B6B),
                textPrimary: Color(0xFFF2F2F0),
                textSecondary: Color(0xFFA0A09C),
                textMuted: Color(0xFF72726E),
                radiusCard: 12,
                radiusControl: 8,
                borderWidth: 1.2,
              )
            : const FajrDesignTokens(
                style: AppDesignStyle.editorial,
                canvas: Color(0xFFF4F3EF),
                surface: Color(0xFFFAF9F6),
                surfaceElevated: Color(0xFFE9E7E1),
                borderSubtle: Color(0xFFD8D5CC),
                dawnAccent: Color(0xFF995040),
                dawnGlow: Color(0x00000000),
                emeraldSignal: Color(0xFF497659),
                clayError: Color(0xFF9E5252),
                textPrimary: Color(0xFF1A1A19),
                textSecondary: Color(0xFF565653),
                textMuted: Color(0xFF7A7A76),
                radiusCard: 12,
                radiusControl: 8,
                borderWidth: 1.2,
              ),
      AppDesignStyle.liquid =>
        isDark
            ? const FajrDesignTokens(
                style: AppDesignStyle.liquid,
                canvas: Color(0xFF0E151D),
                surface: Color(0xE017222F),
                surfaceElevated: Color(0xFF1F2D3D),
                borderSubtle: Color(0xFF2D3F52),
                dawnAccent: Color(0xFF6F9BB3),
                dawnGlow: Color(0x166F9BB3),
                emeraldSignal: Color(0xFF68A29A),
                clayError: Color(0xFFB86B6B),
                textPrimary: Color(0xFFEAF1F6),
                textSecondary: Color(0xFF99AAB8),
                textMuted: Color(0xFF6E8090),
                radiusCard: 24,
                radiusControl: 16,
                borderWidth: 1,
              )
            : const FajrDesignTokens(
                style: AppDesignStyle.liquid,
                canvas: Color(0xFFF1F5F8),
                surface: Color(0xFFF8FBFD),
                surfaceElevated: Color(0xFFE3EBF2),
                borderSubtle: Color(0xFFD4E0EA),
                dawnAccent: Color(0xFF49738B),
                dawnGlow: Color(0x1249738B),
                emeraldSignal: Color(0xFF437B73),
                clayError: Color(0xFF9E5252),
                textPrimary: Color(0xFF1B2631),
                textSecondary: Color(0xFF546575),
                textMuted: Color(0xFF788896),
                radiusCard: 24,
                radiusControl: 16,
                borderWidth: 1,
              ),
      AppDesignStyle.desert =>
        isDark
            ? const FajrDesignTokens(
                style: AppDesignStyle.desert,
                canvas: Color(0xFF171310),
                surface: Color(0xFF221C18),
                surfaceElevated: Color(0xFF2C241E),
                borderSubtle: Color(0xFF3A3029),
                dawnAccent: Color(0xFFBE8870),
                dawnGlow: Color(0x14BE8870),
                emeraldSignal: Color(0xFF8FA074),
                clayError: Color(0xFFB86B6B),
                textPrimary: Color(0xFFF4EDE6),
                textSecondary: Color(0xFFB2A396),
                textMuted: Color(0xFF827367),
                radiusCard: 20,
                radiusControl: 14,
                borderWidth: 1,
              )
            : const FajrDesignTokens(
                style: AppDesignStyle.desert,
                canvas: Color(0xFFF7F3ED),
                surface: Color(0xFFFCF9F4),
                surfaceElevated: Color(0xFFECE4D9),
                borderSubtle: Color(0xFFDED3C5),
                dawnAccent: Color(0xFF99634C),
                dawnGlow: Color(0x1299634C),
                emeraldSignal: Color(0xFF61754A),
                clayError: Color(0xFF9E5252),
                textPrimary: Color(0xFF2A211B),
                textSecondary: Color(0xFF6B5B50),
                textMuted: Color(0xFF8C7B6E),
                radiusCard: 20,
                radiusControl: 14,
                borderWidth: 1,
              ),
      AppDesignStyle.nordic =>
        isDark
            ? const FajrDesignTokens(
                style: AppDesignStyle.nordic,
                canvas: Color(0xFF11151B),
                surface: Color(0xFF191F27),
                surfaceElevated: Color(0xFF222934),
                borderSubtle: Color(0xFF2E3744),
                dawnAccent: Color(0xFF7A94B8),
                dawnGlow: Color(0x147A94B8),
                emeraldSignal: Color(0xFF6CA08A),
                clayError: Color(0xFFB86B6B),
                textPrimary: Color(0xFFECEFF4),
                textSecondary: Color(0xFF9AA4B2),
                textMuted: Color(0xFF6D7785),
                radiusCard: 18,
                radiusControl: 12,
                borderWidth: 1,
              )
            : const FajrDesignTokens(
                style: AppDesignStyle.nordic,
                canvas: Color(0xFFF3F5F8),
                surface: Color(0xFFFAFBFC),
                surfaceElevated: Color(0xFFE7ECF2),
                borderSubtle: Color(0xFFD7DEE8),
                dawnAccent: Color(0xFF4E6B91),
                dawnGlow: Color(0x124E6B91),
                emeraldSignal: Color(0xFF497864),
                clayError: Color(0xFF9E5252),
                textPrimary: Color(0xFF1D242E),
                textSecondary: Color(0xFF566170),
                textMuted: Color(0xFF788291),
                radiusCard: 18,
                radiusControl: 12,
                borderWidth: 1,
              ),
      AppDesignStyle.velvet =>
        isDark
            ? const FajrDesignTokens(
                style: AppDesignStyle.velvet,
                canvas: Color(0xFF16121A),
                surface: Color(0xFF201B26),
                surfaceElevated: Color(0xFF2A2332),
                borderSubtle: Color(0xFF393044),
                dawnAccent: Color(0xFFAE859B),
                dawnGlow: Color(0x14AE859B),
                emeraldSignal: Color(0xFFB89B72),
                clayError: Color(0xFFB86B6B),
                textPrimary: Color(0xFFF2ECF5),
                textSecondary: Color(0xFFA99DB2),
                textMuted: Color(0xFF7B6F85),
                radiusCard: 22,
                radiusControl: 14,
                borderWidth: 1,
              )
            : const FajrDesignTokens(
                style: AppDesignStyle.velvet,
                canvas: Color(0xFFF6F3F7),
                surface: Color(0xFFFBF9FC),
                surfaceElevated: Color(0xFFECE5EE),
                borderSubtle: Color(0xFFDCD3DF),
                dawnAccent: Color(0xFF845970),
                dawnGlow: Color(0x12845970),
                emeraldSignal: Color(0xFF8D7249),
                clayError: Color(0xFF9E5252),
                textPrimary: Color(0xFF281F2D),
                textSecondary: Color(0xFF66576E),
                textMuted: Color(0xFF897991),
                radiusCard: 22,
                radiusControl: 14,
                borderWidth: 1,
              ),
    };
  }

  static TextStyle tabular(TextStyle? base) {
    return (base ?? const TextStyle()).copyWith(
      fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
    );
  }

  static ThemeData light([AppDesignStyle style = AppDesignStyle.horizon]) {
    final tokens = tokensFor(style, Brightness.light);
    final colorScheme = ColorScheme.light(
      primary: tokens.dawnAccent,
      onPrimary: Colors.white,
      primaryContainer: tokens.surfaceElevated,
      onPrimaryContainer: tokens.textPrimary,
      secondary: tokens.emeraldSignal,
      onSecondary: Colors.white,
      secondaryContainer: tokens.surfaceElevated,
      onSecondaryContainer: tokens.textPrimary,
      tertiary: tokens.emeraldSignal,
      tertiaryContainer: tokens.surfaceElevated,
      onTertiaryContainer: tokens.textPrimary,
      error: tokens.clayError,
      onError: Colors.white,
      errorContainer: tokens.clayError.withValues(alpha: 0.14),
      onErrorContainer: tokens.textPrimary,
      surface: tokens.surface,
      onSurface: tokens.textPrimary,
      onSurfaceVariant: tokens.textSecondary,
      surfaceContainerLow: tokens.surface,
      surfaceContainerHigh: tokens.surfaceElevated,
      surfaceContainerHighest: tokens.surfaceElevated,
      outline: tokens.borderSubtle,
      outlineVariant: tokens.borderSubtle,
    );
    return _buildTheme(colorScheme: colorScheme, tokens: tokens);
  }

  static ThemeData dark([AppDesignStyle style = AppDesignStyle.horizon]) {
    final tokens = tokensFor(style, Brightness.dark);
    final colorScheme = ColorScheme.dark(
      primary: tokens.dawnAccent,
      onPrimary: tokens.canvas,
      primaryContainer: tokens.surfaceElevated,
      onPrimaryContainer: tokens.textPrimary,
      secondary: tokens.emeraldSignal,
      onSecondary: tokens.canvas,
      secondaryContainer: tokens.surfaceElevated,
      onSecondaryContainer: tokens.textPrimary,
      tertiary: tokens.emeraldSignal,
      tertiaryContainer: tokens.surfaceElevated,
      onTertiaryContainer: tokens.textPrimary,
      error: tokens.clayError,
      onError: tokens.canvas,
      errorContainer: tokens.clayError.withValues(alpha: 0.16),
      onErrorContainer: tokens.textPrimary,
      surface: tokens.surface,
      onSurface: tokens.textPrimary,
      onSurfaceVariant: tokens.textSecondary,
      surfaceContainerLow: tokens.surface,
      surfaceContainerHigh: tokens.surfaceElevated,
      surfaceContainerHighest: tokens.surfaceElevated,
      outline: tokens.borderSubtle,
      outlineVariant: tokens.borderSubtle,
    );
    return _buildTheme(colorScheme: colorScheme, tokens: tokens);
  }

  static ThemeMode parseThemeMode(String mode) {
    return switch (mode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required FajrDesignTokens tokens,
  }) {
    final onPrimary = colorScheme.onPrimary;
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.canvas,
      extensions: <ThemeExtension<dynamic>>[tokens],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: tokens.canvas,
        foregroundColor: tokens.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: tokens.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: tokens.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusCard),
          side: BorderSide(
            color: tokens.borderSubtle,
            width: tokens.borderWidth,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: tokens.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: tokens.dawnAccent,
          foregroundColor: onPrimary,
          disabledBackgroundColor: tokens.surfaceElevated,
          disabledForegroundColor: tokens.textMuted,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radiusControl),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: tokens.dawnAccent,
          foregroundColor: onPrimary,
          disabledBackgroundColor: tokens.surfaceElevated,
          disabledForegroundColor: tokens.textMuted,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radiusControl),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          foregroundColor: tokens.textPrimary,
          backgroundColor: tokens.surfaceElevated,
          side: BorderSide(
            color: tokens.borderSubtle,
            width: tokens.borderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tokens.radiusControl),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: tokens.dawnAccent),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return onPrimary;
          return tokens.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return tokens.dawnAccent;
          return tokens.surfaceElevated;
        }),
        trackOutlineColor: WidgetStatePropertyAll<Color>(tokens.borderSubtle),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return tokens.dawnAccent;
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll<Color>(onPrimary),
        side: BorderSide(color: tokens.textSecondary, width: 1.5),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return tokens.dawnAccent.withValues(alpha: 0.18);
            }
            return tokens.surface;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return tokens.textPrimary;
            }
            return tokens.textSecondary;
          }),
          shape: WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tokens.radiusControl),
            ),
          ),
          side: WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: tokens.borderSubtle, width: tokens.borderWidth),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusControl),
          borderSide: BorderSide(color: tokens.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusControl),
          borderSide: BorderSide(color: tokens.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusControl),
          borderSide: BorderSide(color: tokens.dawnAccent, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: tokens.surfaceElevated,
        side: BorderSide(color: tokens.borderSubtle),
        labelStyle: TextStyle(color: tokens.textPrimary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: tokens.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(tokens.radiusCard),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: tokens.surfaceElevated,
        contentTextStyle: TextStyle(color: tokens.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusControl),
        ),
      ),
    );
  }
}
