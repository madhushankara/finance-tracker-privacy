import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Adds bottom breathing space for pages that do NOT show the bottom tab bar.
///
/// Uses a dynamic inset derived from system navigation metrics to prevent
/// content from being covered by the Android gesture bar / 3-button nav.
final class NonShellSystemNavPadding extends StatelessWidget {
  const NonShellSystemNavPadding({super.key, required this.child});

  final Widget child;

  static double bottomInsetOf(BuildContext context) {
    final mq = MediaQuery.of(context);

    // On some gesture-nav devices (e.g. Samsung One UI), viewPadding.bottom can
    // be 0 while systemGestureInsets.bottom is still non-zero.
    return math.max(mq.viewPadding.bottom, mq.systemGestureInsets.bottom);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = bottomInsetOf(context);
    if (bottom <= 0) return child;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: child,
    );
  }
}
