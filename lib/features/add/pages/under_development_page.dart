import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

final class UnderDevelopmentArgs {
  const UnderDevelopmentArgs({required this.message, this.subtext});

  final String message;
  final String? subtext;
}

final class UnderDevelopmentPage extends StatelessWidget {
  const UnderDevelopmentPage({super.key, required this.args});

  final UnderDevelopmentArgs args;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Feature under development')),
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: AppSpacing.s8),
            Icon(
              Icons.construction_outlined,
              size: 48,
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              args.message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (args.subtext != null) ...<Widget>[
              const SizedBox(height: AppSpacing.s8),
              Text(
                args.subtext!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
