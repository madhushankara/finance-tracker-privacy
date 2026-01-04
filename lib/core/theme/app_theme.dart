import 'package:flutter/material.dart';

import 'app_text_theme.dart';

@immutable
final class AppTheme {
  const AppTheme();

  static const Color defaultBlueAccent = Color(0xFF7DD3FC);

  ColorScheme _applySurfaceOverrides(
    ColorScheme base, {
    required Brightness brightness,
    required Color surface,
    required Color surface2,
    required Color outline,
    required Color onSurface,
  }) {
    return base.copyWith(
      brightness: brightness,
      surface: surface,
      surfaceContainerHighest: surface2,
      outline: outline,
      onSurface: onSurface,
      // Preserve app semantics.
      error: const Color(0xFFE2574C),
      tertiary: const Color(0xFFF1B447),
    );
  }

  ThemeData light({required Color accent, ColorScheme? dynamicScheme}) {
    // Keep light theme simple and Material-3 friendly.
    final ColorScheme seed =
        (dynamicScheme ??
                ColorScheme.fromSeed(
                  seedColor: accent,
                  brightness: Brightness.light,
                ))
            .copyWith(
              error: const Color(0xFFE2574C),
              tertiary: const Color(0xFFF1B447),
            );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: seed,
      textTheme: AppTextTheme.textTheme(seed.onSurface),
      dividerColor: seed.outline.withValues(alpha: 0.8),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextTheme.textTheme(seed.onSurface).titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: seed.primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: seed.onSurface.withValues(alpha: 0.9),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: seed.outline.withValues(alpha: 0.55)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: seed.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: seed.outline.withValues(alpha: 0.8)),
        ),
      ),
    );
  }

  ThemeData dark({required Color accent, ColorScheme? dynamicScheme}) {
    // Dark mode is primary. Use dark gray instead of black.
    const Color bg = Color(0xFF101214);
    const Color surface = Color(0xFF15181B);
    const Color surface2 = Color(0xFF1A1F23);
    const Color outline = Color(0xFF2A3036);
    const Color onBg = Color(0xFFE9EEF2);
    const Color onSurface = Color(0xFFE9EEF2);

    final ColorScheme base =
        dynamicScheme ??
        const ColorScheme(
          brightness: Brightness.dark,
          primary: defaultBlueAccent,
          onPrimary: Color(0xFF0B1220),
          secondary: Color(0xFF94A3B8),
          onSecondary: Color(0xFF0B1220),
          tertiary: Color(0xFFF1B447),
          onTertiary: Color(0xFF1F1400),
          error: Color(0xFFE2574C),
          onError: Color(0xFF2A0B08),
          surface: surface,
          onSurface: onSurface,
          outline: outline,
        ).copyWith(primary: accent);

    final ColorScheme scheme = _applySurfaceOverrides(
      base,
      brightness: Brightness.dark,
      surface: surface,
      surface2: surface2,
      outline: outline,
      onSurface: onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      textTheme: AppTextTheme.textTheme(scheme.onSurface),
      dividerColor: scheme.outline.withValues(alpha: 0.8),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: onBg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextTheme.textTheme(scheme.onSurface).titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: scheme.onSurface.withValues(alpha: 0.9),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.55)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.8)),
        ),
      ),
    );
  }
}
