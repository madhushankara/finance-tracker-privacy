import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animations/motion.dart';

final class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    required this.onPressed,
    this.enabled = true,
    this.pressedScale = 0.98,
    this.haptic = true,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool enabled;
  final double pressedScale;
  final bool haptic;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

/// Adds a subtle scale-down on press without owning the tap gesture.
///
/// Use this to wrap existing Flutter buttons (e.g. `FilledButton`, `IconButton`,
/// `FloatingActionButton`) so their semantics, ripples and focus behavior remain
/// intact.
final class PressableScaleDecorator extends StatefulWidget {
  const PressableScaleDecorator({
    super.key,
    required this.child,
    this.enabled = true,
    this.pressedScale = 0.97,
  });

  /// Convenience constructor for wrapping a button.
  ///
  /// Ensures disabled buttons do not animate by auto-deriving `enabled` from
  /// `onPressed`.
  factory PressableScaleDecorator.forButton({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    double pressedScale = 0.97,
  }) {
    return PressableScaleDecorator(
      key: key,
      enabled: onPressed != null,
      pressedScale: pressedScale,
      child: child,
    );
  }

  final Widget child;
  final bool enabled;
  final double pressedScale;

  @override
  State<PressableScaleDecorator> createState() =>
      _PressableScaleDecoratorState();
}

final class _PressableScaleDecoratorState
    extends State<PressableScaleDecorator> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    if (Motion.reduceMotion(context)) return widget.child;

    final enabled = widget.enabled;
    const pressDuration = Duration(milliseconds: 110);

    return Listener(
      onPointerDown: enabled ? (_) => _setPressed(true) : null,
      onPointerUp: enabled ? (_) => _setPressed(false) : null,
      onPointerCancel: enabled ? (_) => _setPressed(false) : null,
      child: TweenAnimationBuilder<double>(
        duration: _pressed ? pressDuration : Duration.zero,
        curve: Curves.easeOut,
        tween: Tween<double>(
          begin: 1,
          end: (!enabled || !_pressed) ? 1 : widget.pressedScale,
        ),
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: widget.child,
      ),
    );
  }
}

final class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled && widget.onPressed != null;
    final duration = Motion.duration(context, MotionDurations.xFast);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTap: enabled
          ? () {
              if (widget.haptic) {
                HapticFeedback.lightImpact();
              }
              widget.onPressed?.call();
            }
          : null,
      child: AnimatedScale(
        duration: duration,
        curve: MotionCurves.standard,
        scale: (!enabled || !_pressed) ? 1 : widget.pressedScale,
        child: AnimatedOpacity(
          duration: duration,
          curve: MotionCurves.standard,
          opacity: enabled ? 1 : 0.55,
          child: widget.child,
        ),
      ),
    );
  }
}
