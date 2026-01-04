import 'package:flutter/material.dart';

Future<void> showComingSoonDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Coming soon'),
        content: const Text('This feature is under development.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
