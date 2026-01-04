import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/formatting/money_format.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/account.dart';
import '../../data/models/category.dart';
import '../../features/transactions/utils/transaction_grouping.dart';
import '../../features/transactions/widgets/transaction_list_widgets.dart';
import '../settings/providers/settings_providers.dart';
import 'providers/budgets_providers.dart';

final class BudgetDetailPage extends ConsumerWidget {
  const BudgetDetailPage({super.key, required this.budgetId});

  final String budgetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetAsync = ref.watch(budgetWithProgressProvider(budgetId));
    final accountsAsync = ref.watch(budgetAccountsProvider);
    final categoriesAsync = ref.watch(budgetCategoriesProvider);

    final error = budgetAsync.error ?? accountsAsync.error ?? categoriesAsync.error;
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Budget')),
        body: EmptyState(
          title: 'Couldn\'t load budget',
          body: error.toString(),
        ),
      );
    }

    final isLoading = budgetAsync.isLoading || accountsAsync.isLoading || categoriesAsync.isLoading;
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final item = budgetAsync.value;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Budget')),
        body: const EmptyState(
          title: 'Budget not found',
          body: 'This budget no longer exists.',
        ),
      );
    }

    final budget = item.budget;
    final cs = Theme.of(context).colorScheme;

    final accountMap = <String, Account>{
      for (final a in (accountsAsync.value ?? const <Account>[])) a.id: a,
    };
    final categoryMap = <String, Category>{
      for (final c in (categoriesAsync.value ?? const <Category>[])) c.id: c,
    };

    final range = '${DateFormat('d MMM yyyy').format(budget.startDate)} – ${DateFormat('d MMM yyyy').format(budget.endDate)}';
    final total = formatMoney(budget.amount);
    final spent = formatMoney(item.spent);
    final remaining = formatMoney(item.remaining);

    final includedCategoryNames = budget.categoryIds
        .map((id) => categoryMap[id]?.name)
        .whereType<String>()
        .where((name) => name.trim().isNotEmpty)
        .toList(growable: false);

    final contributing = item.status.contributingTransactions;
    final settings = ref.watch(appSettingsProvider);
    final groups = groupTransactionsByDate(contributing, settings: settings);

    return Scaffold(
      appBar: AppBar(title: Text(budget.name)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(budget.name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.s4),
                  Text(range, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.s16),
                  Text('Total: $total', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    'Spent: $spent',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: item.isExceeded
                              ? cs.error
                              : item.isNearLimit
                                  ? cs.tertiary
                                  : cs.onSurface,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text('Remaining: $remaining', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.s16),
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    includedCategoryNames.isEmpty
                        ? 'No categories'
                        : includedCategoryNames.join(', '),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: cs.onSurface.withValues(alpha: 0.8)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text('Transactions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.s8),
          if (contributing.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.s8),
              child: EmptyState(
                title: 'No contributing transactions',
                body: 'Transactions in this budget window will show here.',
                padding: EdgeInsets.zero,
              ),
            )
          else
            ...List<Widget>.generate(groups.length, (index) {
              final group = groups[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == groups.length - 1 ? 0 : AppSpacing.s24,
                ),
                child: TransactionGroupCard(
                  label: group.label,
                  items: group.items,
                  accountsById: accountMap,
                  categoriesById: categoryMap,
                  onTapBuilder: (_) => null,
                ),
              );
            }),
        ],
      ),
    );
  }
}
