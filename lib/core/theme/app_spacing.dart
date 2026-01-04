import 'package:flutter/widgets.dart';

/// Spacing scale: 4 / 8 / 16 / 24 (strict).
abstract final class AppSpacing {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s16 = 16;
  static const double s24 = 24;

  static const EdgeInsets pagePadding = EdgeInsets.all(s16);
}
