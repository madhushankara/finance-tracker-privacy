import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../data/models/enums.dart';
import 'providers/accounts_controller.dart';
import 'widgets/account_form.dart';

final class AddAccountPage extends ConsumerWidget {
  const AddAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSubmitting = ref.watch(accountsControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Add account')),
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: AccountForm(
          initialName: '',
          initialType: AccountType.bank,
          initialCurrencyCode: 'INR',
          initialBalanceText: '0',
          allowCurrencyEdit: true,
          showBalanceField: true,
          isSubmitting: isSubmitting,
          onSubmit: (values) async {
            try {
              await ref.read(accountsControllerProvider.notifier).createAccount(
                    name: values.name,
                    type: values.type,
                    currencyCode: values.currencyCode,
                    openingBalance: values.openingBalance!,
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
      ),
    );
  }
}
