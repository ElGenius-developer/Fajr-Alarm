import 'package:fajr_alarm/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme 60-30-10 Low-Saturation Design System', () {
    test('default horizon preset matches Stitch Quiet Dawn / Quiet Limestone tokens', () {
      final dark = AppTheme.tokensFor(AppDesignStyle.horizon, Brightness.dark);
      expect(dark.canvas, const Color(0xFF12151B));
      expect(dark.surface, const Color(0xFF1B2029));
      expect(dark.surfaceElevated, const Color(0xFF222834));
      expect(dark.borderSubtle, const Color(0xFF2B3240));
      expect(dark.dawnAccent, const Color(0xFFC8A97E));
      expect(dark.emeraldSignal, const Color(0xFF6E9F86));
      expect(dark.textPrimary, const Color(0xFFECEFF4));
      expect(dark.radiusCard, 20);
      expect(dark.radiusControl, 14);

      final light = AppTheme.tokensFor(
        AppDesignStyle.horizon,
        Brightness.light,
      );
      expect(light.canvas, const Color(0xFFF5F3EF));
      expect(light.surface, const Color(0xFFFAF9F6));
      expect(light.surfaceElevated, const Color(0xFFEAE6DF));
      expect(light.borderSubtle, const Color(0xFFDDD8CE));
      expect(light.dawnAccent, const Color(0xFF8C6D46));
      expect(light.emeraldSignal, const Color(0xFF4B7A63));
      expect(light.textPrimary, const Color(0xFF1E232B));
      expect(light.radiusCard, 20);
      expect(light.radiusControl, 14);
    });

    test('all design styles maintain restrained low-saturation accents', () {
      for (final style in AppDesignStyle.values) {
        for (final brightness in Brightness.values) {
          final tokens = AppTheme.tokensFor(style, brightness);
          final hslAccent = HSLColor.fromColor(tokens.dawnAccent);
          final hslSignal = HSLColor.fromColor(tokens.emeraldSignal);

          expect(
            hslAccent.saturation,
            lessThanOrEqualTo(0.55),
            reason:
                '$style ($brightness) dawnAccent saturation ${hslAccent.saturation} exceeds muted cap',
          );
          expect(
            hslSignal.saturation,
            lessThanOrEqualTo(0.55),
            reason:
                '$style ($brightness) emeraldSignal saturation ${hslSignal.saturation} exceeds muted cap',
          );
        }
      }
    });

    test(
      'ThemeData explicitly uses token primary, surface, and error colors',
      () {
        final darkTheme = AppTheme.dark();
        expect(darkTheme.scaffoldBackgroundColor, const Color(0xFF12151B));
        expect(darkTheme.colorScheme.primary, const Color(0xFFC8A97E));
        expect(darkTheme.colorScheme.onPrimary, const Color(0xFF12151B));
        expect(darkTheme.colorScheme.surface, const Color(0xFF1B2029));

        final lightTheme = AppTheme.light();
        expect(lightTheme.scaffoldBackgroundColor, const Color(0xFFF5F3EF));
        expect(lightTheme.colorScheme.primary, const Color(0xFF8C6D46));
        expect(lightTheme.colorScheme.onPrimary, Colors.white);
        expect(lightTheme.colorScheme.surface, const Color(0xFFFAF9F6));
      },
    );

    testWidgets('FajrDesignTokens.of falls back using Theme brightness', (
      tester,
    ) async {
      late FajrDesignTokens capturedLight;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Builder(
            builder: (context) {
              capturedLight = FajrDesignTokens.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(capturedLight.canvas, const Color(0xFFF5F3EF));
    });
  });
}
