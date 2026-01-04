import 'package:flutter/material.dart';

/// Theme-independent palettes for charts.
///
/// This file intentionally avoids reading from [ThemeData] so that charts have
/// consistent, high-contrast colors regardless of the active app theme.
final class ChartPalettes {
  ChartPalettes._();

  // --- Bar / Line ---

  static const Color income = Color(0xFF16A34A); // green
  static const Color expense = Color(0xFFDC2626); // red
  static const Color line = Color(0xFF2563EB); // blue

  // --- Categorical (pie/donut) ---

  // A high-contrast categorical palette (loosely based on common visualization
  // palettes). Keep the list stable to preserve color/key mapping over time.
  static const List<Color> categorical = <Color>[
    Color(0xFF1F77B4),
    Color(0xFFFF7F0E),
    Color(0xFF2CA02C),
    Color(0xFFD62728),
    Color(0xFF9467BD),
    Color(0xFF8C564B),
    Color(0xFFE377C2),
    Color(0xFF7F7F7F),
    Color(0xFFBCBD22),
    Color(0xFF17BECF),
    Color(0xFF0EA5E9),
    Color(0xFFF59E0B),
  ];

  static Color categoricalColorForKey(String key) {
    final idx = _fnv1a32(key) % categorical.length;
    return categorical[idx];
  }

  // --- Heatmap (GitHub-style) ---

  // GitHub contribution colors (light theme) for a familiar scale.
  static const List<Color> heatmapLevels = <Color>[
    Color(0xFFEBEDF0), // 0
    Color(0xFF9BE9A8),
    Color(0xFF40C463),
    Color(0xFF30A14E),
    Color(0xFF216E39), // max
  ];

  static Color heatmapColor({required int count, required int maxCount}) {
    if (count <= 0 || maxCount <= 0) return heatmapLevels.first;

    final t = (count / maxCount).clamp(0.0, 1.0);

    // Discrete levels: any positive activity shows at least level 1.
    final idx = (t * (heatmapLevels.length - 1)).ceil().clamp(
      1,
      heatmapLevels.length - 1,
    );
    return heatmapLevels[idx];
  }

  static int _fnv1a32(String input) {
    var hash = 0x811c9dc5;
    for (final unit in input.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash;
  }
}
