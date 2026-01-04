import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/account.dart';
import '../../data/models/category.dart';
import '../../data/models/transaction.dart';
import '../add/providers/add_flow_prefill_providers.dart';
import '../transactions/providers/transactions_providers.dart';
import '../transactions/widgets/transaction_list_widgets.dart';

final class CalendarDayTransactionsPage extends ConsumerWidget {
  const CalendarDayTransactionsPage({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(transactionsListProvider);
    final accounts = ref.watch(transactionAccountsProvider);
    final categories = ref.watch(transactionCategoriesProvider);

    final error = txs.error ?? accounts.error ?? categories.error;
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(_titleFor(date))),
        body: Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Couldn\'t load day view',
            body: error.toString(),
          ),
        ),
      );
    }

    final isLoading =
        txs.isLoading || accounts.isLoading || categories.isLoading;
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(_titleFor(date))),
        body: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final normalized = DateUtils.dateOnly(date);
    final txList =
        (txs.value ?? const <FinanceTransaction>[])
            .where((t) => DateUtils.isSameDay(t.occurredAt, normalized))
            .toList(growable: false)
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    final accountMap = <String, Account>{
      for (final a in (accounts.value ?? const <Account>[])) a.id: a,
    };
    final categoryMap = <String, Category>{
      for (final c in (categories.value ?? const <Category>[])) c.id: c,
    };

    void addForThisDay() {
      ref.read(addTransactionPrefillDateProvider.notifier).state = normalized;
      context.push(Routes.addMethodSelector);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleFor(date)),
        actions: <Widget>[
          IconButton(
            tooltip: 'Add transaction',
            onPressed: addForThisDay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: txList.isEmpty
          ? const Padding(
              padding: AppSpacing.pagePadding,
              child: EmptyState(
                title: 'No transactions',
                body: 'No transactions on this day.',
              ),
            )
          : ListView.separated(
              padding: AppSpacing.pagePadding,
              itemCount: txList.length,
              separatorBuilder: (_, index) =>
                  const SizedBox(height: AppSpacing.s8),
              itemBuilder: (context, index) {
                final tx = txList[index];
                return Card(
                  child: TransactionRow(
                    tx: tx,
                    account: accountMap[tx.accountId],
                    category: tx.categoryId == null
                        ? null
                        : categoryMap[tx.categoryId!],
                    onTap: () => context.push(Routes.transactionEdit(tx.id)),
                  ),
                );
              },
            ),
    );
  }

  static String _titleFor(DateTime date) {
    return DateFormat('d MMM yyyy').format(DateUtils.dateOnly(date));
  }
}
