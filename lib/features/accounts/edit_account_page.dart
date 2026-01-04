import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import 'providers/accounts_controller.dart';
import 'providers/accounts_providers.dart';
import 'widgets/account_form.dart';

final class EditAccountPage extends ConsumerWidget {
  const EditAccountPage({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountByIdProvider(accountId));
    final isSubmitting = ref.watch(accountsControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit account')),
      body: account.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Couldn\'t load account',
            body: error.toString(),
          ),
        ),
        data: (acc) {
          if (acc == null) {
            return const Padding(
              padding: AppSpacing.pagePadding,
              child: EmptyState(
                title: 'Account not found',
                body: 'This account may have been deleted.',
              ),
            );
          }

          return Padding(
            padding: AppSpacing.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AccountForm(
                  initialName: acc.name,
                  initialType: acc.type,
                  initialCurrencyCode: acc.currencyCode,
                  initialBalanceText: '',
                  allowCurrencyEdit: false,
                  showBalanceField: false,
                  isSubmitting: isSubmitting,
                  onSubmit: (values) async {
                    try {
                      await ref.read(accountsControllerProvider.notifier).updateAccount(
                            existing: acc,
                            name: values.name,
                            type: values.type,
                          );
                      if (context.mounted) context.pop();
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.s16),
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete account?'),
                                  content: Text('Delete "${acc.name}"? This can\'t be undone.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmed != true) return;

                            try {
                              await ref
                                  .read(accountsControllerProvider.notifier)
                                  .deleteAccount(accountId: acc.id);
                              if (!context.mounted) return;
                              context.pop();
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete account'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
