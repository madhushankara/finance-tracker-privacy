import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/formatting/money_format.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/implicit_animated_list.dart';
import '../../core/widgets/empty_state.dart';
import 'providers/budgets_providers.dart';

final class BudgetsPage extends ConsumerWidget {
  const BudgetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetProgressListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: <Widget>[
          PressableScaleDecorator(
            pressedScale: 0.97,
            child: IconButton(
              tooltip: 'Add budget',
              onPressed: () => context.push(Routes.budgetsAdd),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: budgets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            EmptyState(title: 'Can\'t load budgets', body: e.toString()),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              title: 'No budgets configured',
              body:
                  'Create budgets by selecting one or more expense categories.',
            );
          }

          return ImplicitAnimatedList(
            items: items,
            itemKey: (item) => item.budget.id,
            padding: const EdgeInsets.all(AppSpacing.s16),
            itemBuilder: (context, item, animation) {
              final b = item.budget;
              final range =
                  '${DateFormat('d MMM').format(b.startDate)} – ${DateFormat('d MMM').format(b.endDate)}';
              final spent = formatMoney(item.spent);
              final total = formatMoney(b.amount);

              final cs = Theme.of(context).colorScheme;
              final statusColor = item.isExceeded
                  ? cs.error
                  : item.isNearLimit
                  ? cs.tertiary
                  : cs.onSurfaceVariant;

              final cardColor = item.isExceeded || item.isNearLimit
                  ? Color.alphaBlend(
                      statusColor.withValues(alpha: 0.10),
                      cs.surface,
                    )
                  : null;

              final isLast = identical(item, items.last);
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.s8),
                child: Card(
                  color: cardColor,
                  child: InkWell(
                    onTap: () => context.push(Routes.budgetDetail(b.id)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            b.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.s4),
                          Text(
                            range,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: AppSpacing.s16),
                          LinearProgressIndicator(
                            value: item.progressFraction,
                            color: statusColor,
                            backgroundColor: cs.surfaceContainerHighest,
                          ),
                          const SizedBox(height: AppSpacing.s8),
                          Text(
                            '$spent spent • $total total',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: statusColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
