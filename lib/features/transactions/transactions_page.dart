import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/implicit_animated_list.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../data/models/account.dart';
import '../../data/models/category.dart';
import '../../data/models/transaction.dart';
import '../settings/providers/settings_providers.dart';
import 'providers/transactions_providers.dart';
import 'utils/transaction_grouping.dart';
import 'widgets/transaction_list_widgets.dart';

final class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(transactionsListProvider);
    final accounts = ref.watch(transactionAccountsProvider);
    final categories = ref.watch(transactionCategoriesProvider);

    final error = txs.error ?? accounts.error ?? categories.error;
    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
          actions: <Widget>[
            PressableScaleDecorator.forButton(
              onPressed: () => context.push(Routes.transactionsAdd),
              child: IconButton(
                tooltip: 'Add transaction',
                onPressed: () => context.push(Routes.transactionsAdd),
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: EmptyState(
          title: 'Couldn\'t load transactions',
          body: error.toString(),
        ),
      );
    }

    final isLoading =
        txs.isLoading || accounts.isLoading || categories.isLoading;
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
          actions: <Widget>[
            PressableScaleDecorator.forButton(
              onPressed: () => context.push(Routes.transactionsAdd),
              child: IconButton(
                tooltip: 'Add transaction',
                onPressed: () => context.push(Routes.transactionsAdd),
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: const _TransactionsLoading(),
      );
    }

    final txList = txs.value ?? const <FinanceTransaction>[];
    if (txList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
          actions: <Widget>[
            PressableScaleDecorator.forButton(
              onPressed: () => context.push(Routes.transactionsAdd),
              child: IconButton(
                tooltip: 'Add transaction',
                onPressed: () => context.push(Routes.transactionsAdd),
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: const EmptyState(
          title: 'No transactions yet',
          body: 'Transactions will appear here once you add them.',
        ),
      );
    }

    final accountMap = <String, Account>{
      for (final a in (accounts.value ?? const <Account>[])) a.id: a,
    };
    final categoryMap = <String, Category>{
      for (final c in (categories.value ?? const <Category>[])) c.id: c,
    };

    final settings = ref.watch(appSettingsProvider);
    final groups = groupTransactionsByDate(txList, settings: settings);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: <Widget>[
          PressableScaleDecorator.forButton(
            onPressed: () => context.push(Routes.transactionsAdd),
            child: IconButton(
              tooltip: 'Add transaction',
              onPressed: () => context.push(Routes.transactionsAdd),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: ImplicitAnimatedList<TransactionDateGroup>(
        items: groups,
        itemKey: (g) => g.label,
        padding: AppSpacing.pagePadding,
        itemBuilder: (context, group, animation) {
          final isLast = identical(group, groups.last);
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.s24),
            child: TransactionGroupCard(
              label: group.label,
              items: group.items,
              accountsById: accountMap,
              categoriesById: categoryMap,
              onTapBuilder: (tx) =>
                  () => context.push(Routes.transactionEdit(tx.id)),
            ),
          );
        },
      ),
    );
  }
}

final class _TransactionsLoading extends StatelessWidget {
  const _TransactionsLoading();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: AppSpacing.pagePadding,
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 16,
                          width: 160,
                          color: cs.surfaceContainerHighest,
                        ),
                        const SizedBox(height: AppSpacing.s8),
                        Container(
                          height: 12,
                          width: 110,
                          color: cs.surfaceContainerHighest,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 18,
                        width: 84,
                        color: cs.surfaceContainerHighest,
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      Container(
                        height: 12,
                        width: 42,
                        color: cs.surfaceContainerHighest,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
