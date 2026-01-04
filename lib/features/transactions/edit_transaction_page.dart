import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/enums.dart';
import 'providers/edit_transaction_controller.dart';
import 'providers/transactions_providers.dart';
import 'widgets/transaction_form.dart';

final class EditTransactionPage extends ConsumerWidget {
  const EditTransactionPage({super.key, required this.transactionId});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionByIdProvider(transactionId));
    final accountsAsync = ref.watch(transactionAccountsProvider);
    final categoriesAsync = ref.watch(transactionCategoriesProvider);
    final updateState = ref.watch(editTransactionControllerProvider);

    final error = txAsync.error ?? accountsAsync.error ?? categoriesAsync.error;
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit transaction')),
        body: Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Couldn\'t load transaction',
            body: error.toString(),
          ),
        ),
      );
    }

    if (txAsync.isLoading || accountsAsync.isLoading || categoriesAsync.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit transaction')),
        body: const Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final tx = txAsync.value;
    if (tx == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit transaction')),
        body: const Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Transaction not found',
            body: 'This transaction may have been deleted.',
          ),
        ),
      );
    }

    final accounts = accountsAsync.value ?? const [];
    final categories = categoriesAsync.value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit transaction'),
        actions: <Widget>[
          TextButton(
            onPressed: updateState.isLoading
                ? null
                : () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Delete transaction?'),
                          content: const Text('This action is irreversible. The transaction will be permanently deleted.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(dialogContext).pop(false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.error,
                                foregroundColor: Theme.of(context).colorScheme.onError,
                              ),
                              onPressed: () => Navigator.of(dialogContext).pop(true),
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed != true) return;

                    try {
                      await ref
                          .read(editTransactionControllerProvider.notifier)
                          .deleteTransaction(transactionId: tx.id);
                      if (!context.mounted) return;
                      context.pop();
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
      body: TransactionForm(
        key: ValueKey<String>('edit-${tx.id}'),
        accounts: accounts,
        categories: categories,
        isSubmitting: updateState.isLoading,
        saveEnabled: true,
        typeImmutable: true,
        fixedCurrencyCode: tx.currencyCode,
        fixedScale: tx.amount.scale,
        initialType: tx.type,
        initialOccurredAt: tx.occurredAt,
        initialScheduleForLater: tx.status == TransactionStatus.scheduled,
        initialRepeat: tx.recurrenceType != null,
        initialRecurrenceType: tx.recurrenceType,
        initialRecurrenceInterval: tx.recurrenceInterval,
        initialRecurrenceEndAt: tx.recurrenceEndAt,
        initialAccountId: tx.accountId,
        initialToAccountId: tx.toAccountId,
        initialCategoryId: tx.categoryId,
        initialAmount: tx.amount,
        initialTitle: tx.title,
        onSubmit: (result) async {
          try {
            await ref.read(editTransactionControllerProvider.notifier).updateTransaction(
                  transactionId: tx.id,
                  type: result.type,
                  accountId: result.accountId,
                  toAccountId: result.toAccountId,
                  categoryId: result.categoryId,
                  amount: result.amount,
                  occurredAt: result.occurredAt,
                  scheduleForLater: result.scheduleForLater,
                  recurrenceType: result.recurrenceType,
                  recurrenceInterval: result.recurrenceInterval,
                  recurrenceEndAt: result.recurrenceEndAt,
                  title: result.title,
                );
            if (!context.mounted) return;
            context.pop();
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
      ),
    );
  }
}
