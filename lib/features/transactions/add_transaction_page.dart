import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/account.dart';
import '../../data/models/category.dart';
import '../../data/models/enums.dart';
import '../add/providers/add_flow_prefill_providers.dart';
import 'providers/transactions_controller.dart';
import 'providers/transactions_providers.dart';
import 'widgets/transaction_form.dart';

final class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

final class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  late final DateTime _initialOccurredAt;

  @override
  void initState() {
    super.initState();
    final prefill = ref.read(addTransactionPrefillDateProvider);
    _initialOccurredAt = prefill ?? DateTime.now();
    if (prefill != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(addTransactionPrefillDateProvider.notifier).state = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(transactionsControllerProvider).isLoading;

    final accountsAsync = ref.watch(transactionAccountsProvider);
    final categoriesAsync = ref.watch(transactionCategoriesProvider);

    final error = accountsAsync.error ?? categoriesAsync.error;
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add transaction')),
        body: Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Couldn\'t load form data',
            body: error.toString(),
          ),
        ),
      );
    }

    if (accountsAsync.isLoading || categoriesAsync.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add transaction')),
        body: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final accounts = accountsAsync.value ?? const <Account>[];
    final categories = categoriesAsync.value ?? const <Category>[];

    if (accounts.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add transaction')),
        body: const Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Add an account first',
            body:
                'Transactions need an account. Create an account, then come back here.',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add transaction')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s16,
              AppSpacing.s8,
              AppSpacing.s16,
              AppSpacing.s8,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Date: ${DateFormat('d MMM yyyy').format(DateUtils.dateOnly(_initialOccurredAt))}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          Expanded(
            child: TransactionForm(
              accounts: accounts,
              categories: categories,
              isSubmitting: isSubmitting,
              initialType: TransactionType.expense,
              initialOccurredAt: _initialOccurredAt,
              initialScheduleForLater: DateUtils.dateOnly(
                _initialOccurredAt,
              ).isAfter(DateUtils.dateOnly(DateTime.now())),
              onSubmit: (result) async {
                try {
                  await ref
                      .read(transactionsControllerProvider.notifier)
                      .createTransaction(
                        type: result.type,
                        accountId: result.accountId,
                        amount: result.amount,
                        occurredAt: result.occurredAt,
                        scheduleForLater: result.scheduleForLater,
                        recurrenceType: result.recurrenceType,
                        recurrenceInterval: result.recurrenceInterval,
                        recurrenceEndAt: result.recurrenceEndAt,
                        toAccountId: result.toAccountId,
                        categoryId: result.categoryId,
                        title: result.title,
                      );
                  if (!context.mounted) return;
                  context.pop();
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
