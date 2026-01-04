import 'package:flutter/material.dart';

abstract final class MotionDurations {
  static const Duration xFast = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 300);
}

abstract final class MotionCurves {
  static const Curve emphasized = Curves.fastOutSlowIn;
  static const Curve standard = Curves.easeInOut;
  static const Curve entrance = Curves.easeOut;
}

abstract final class Motion {
  static bool reduceMotion(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    if (mq == null) return false;

    // `disableAnimations` is the most direct signal; `accessibleNavigation`
    // is a good fallback for older platforms/settings.
    return mq.disableAnimations || mq.accessibleNavigation;
  }

  static Duration duration(BuildContext context, Duration normal) {
    return reduceMotion(context) ? Duration.zero : normal;
  }

  static Widget fadeSlide({
    required BuildContext context,
    required Animation<double> animation,
    required Widget child,
    Offset begin = const Offset(0, 0.03),
    Curve curve = MotionCurves.entrance,
    Curve? reverseCurve,
  }) {
    if (reduceMotion(context)) return child;

    final curved = CurvedAnimation(
      parent: animation,
      curve: curve,
      reverseCurve: reverseCurve ?? curve,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(begin: begin, end: Offset.zero).animate(curved),
        child: child,
      ),
    );
  }

  static Widget fadeScale({
    required BuildContext context,
    required Animation<double> animation,
    required Widget child,
    double begin = 0.985,
    Curve curve = MotionCurves.emphasized,
    Curve? reverseCurve,
  }) {
    if (reduceMotion(context)) return child;

    final curved = CurvedAnimation(
      parent: animation,
      curve: curve,
      reverseCurve: reverseCurve ?? curve,
    );
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: begin, end: 1).animate(curved),
        child: child,
      ),
    );
  }
}
