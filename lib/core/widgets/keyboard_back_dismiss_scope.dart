import 'package:flutter/material.dart';

/// Ensures Android back closes the keyboard before popping the route.
///
/// When a TextField is focused, the first back press will unfocus it (hiding the
/// keyboard) and consume the back event. A subsequent back press behaves
/// normally.
final class KeyboardBackDismissScope extends StatelessWidget {
  const KeyboardBackDismissScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: FocusManager.instance,
      builder: (context, _) {
        final focused = FocusManager.instance.primaryFocus;
        final keyboardOpen = focused != null && focused.hasFocus;

        return PopScope(
          canPop: !keyboardOpen,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (!keyboardOpen) return;
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: child,
        );
      },
    );
  }
}
