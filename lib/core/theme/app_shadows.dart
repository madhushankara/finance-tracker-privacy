import 'package:flutter/material.dart';

abstract final class AppShadows {
  /// Soft, blurred shadows. Tint with background, never pure black.
  static List<BoxShadow> soft({required Color surface, double elevation = 6}) {
    final Color shadow = Color.alphaBlend(
      surface.withValues(alpha: 0.70),
      const Color(0xFF000000),
    ).withValues(alpha: 0.22);

    return <BoxShadow>[
      BoxShadow(
        color: shadow,
        blurRadius: elevation * 2,
        spreadRadius: 0,
        offset: Offset(0, elevation / 2),
      ),
    ];
  }
}
