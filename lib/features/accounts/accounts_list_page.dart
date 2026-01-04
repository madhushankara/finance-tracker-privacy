import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/semantic_amount_text.dart';
import '../../data/models/account.dart';
import '../../data/models/money.dart';
import 'providers/accounts_providers.dart';
import 'widgets/account_type_icon.dart';

final class AccountsListPage extends ConsumerWidget {
  const AccountsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsListProvider);
    final balances = ref.watch(accountBalancesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Add account',
            onPressed: () => context.push(Routes.accountsAdd),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: accounts.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) => Padding(
          padding: AppSpacing.pagePadding,
          child: EmptyState(
            title: 'Couldn\'t load accounts',
            body: error.toString(),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const Padding(
              padding: AppSpacing.pagePadding,
              child: EmptyState(
                title: 'No accounts yet',
                body: 'Add an account to start tracking balances.',
              ),
            );
          }

          if (balances.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final balancesError = balances.error;
          if (balancesError != null) {
            return Padding(
              padding: AppSpacing.pagePadding,
              child: EmptyState(
                title: 'Couldn\'t load balances',
                body: balancesError.toString(),
              ),
            );
          }

          final Map<String, Money> balanceMap =
              balances.value ?? const <String, Money>{};

          return ListView.separated(
            padding: AppSpacing.pagePadding,
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.s16),
            itemBuilder: (context, index) {
              final account = items[index];
              return _AccountTile(
                account: account,
                balance: balanceMap[account.id] ?? account.openingBalance,
              );
            },
          );
        },
      ),
    );
  }
}

final class _AccountTile extends StatelessWidget {
  const _AccountTile({required this.account, required this.balance});

  final Account account;
  final Money balance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: () => context.push(Routes.accountEdit(account.id)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 48,
                width: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: Center(child: AccountTypeIcon(type: account.type)),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      account.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      account.currencyCode,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SemanticAmountText(
                    type: null,
                    amount: balance,
                    includeCurrencyCode: false,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(balance.currencyCode, style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
