import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

final class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.body,
    this.primaryAction,
    this.padding,
  });

  final String title;
  final String body;
  final Widget? primaryAction;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Padding(
      padding: padding ?? AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: AppSpacing.s24),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.s8),
          Text(
            body,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: cs.onSurface.withValues(alpha: 0.82)),
          ),
          if (primaryAction != null) ...<Widget>[
            const SizedBox(height: AppSpacing.s16),
            primaryAction!,
          ],
        ],
      ),
    );
  }
}
