import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatting/money_format.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/implicit_animated_list.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/enums.dart';
import '../../data/models/money.dart';
import '../../data/models/transaction.dart';
import '../settings/providers/settings_controller.dart';
import '../settings/providers/settings_providers.dart';
import '../transactions/providers/edit_transaction_controller.dart';
import '../transactions/providers/transactions_providers.dart';

enum _ScheduledFilter { all, overdueOnly, upcomingOnly }

final class ScheduledOverviewPage extends ConsumerStatefulWidget {
  const ScheduledOverviewPage({super.key});

  @override
  ConsumerState<ScheduledOverviewPage> createState() =>
      _ScheduledOverviewPageState();
}

final class _ScheduledOverviewPageState
    extends ConsumerState<ScheduledOverviewPage> {
  final TextEditingController _search = TextEditingController();
  _ScheduledFilter _filter = _ScheduledFilter.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final txAsync = ref.watch(transactionsListProvider);

    final today = DateUtils.dateOnly(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled'),
        actions: <Widget>[
          PopupMenuButton<_ScheduledFilter>(
            tooltip: 'Filter',
            icon: const Icon(Icons.filter_list_outlined),
            onSelected: (v) => setState(() => _filter = v),
            itemBuilder: (context) => const <PopupMenuEntry<_ScheduledFilter>>[
              PopupMenuItem(value: _ScheduledFilter.all, child: Text('All')),
              PopupMenuItem(
                value: _ScheduledFilter.upcomingOnly,
                child: Text('Upcoming'),
              ),
              PopupMenuItem(
                value: _ScheduledFilter.overdueOnly,
                child: Text('Overdue'),
              ),
            ],
          ),
        ],
      ),
      body: txAsync.when(
        data: (txs) {
          final scheduled = txs
              .where((t) => t.status == TransactionStatus.scheduled)
              .toList(growable: false);

          final overdue = scheduled
              .where((t) => DateUtils.dateOnly(t.occurredAt).isBefore(today))
              .toList(growable: false);

          final query = _search.text.trim().toLowerCase();

          Iterable<FinanceTransaction> visible = scheduled;
          if (_filter == _ScheduledFilter.overdueOnly) {
            visible = visible.where(
              (t) => DateUtils.dateOnly(t.occurredAt).isBefore(today),
            );
          } else if (_filter == _ScheduledFilter.upcomingOnly) {
            visible = visible.where(
              (t) => !DateUtils.dateOnly(t.occurredAt).isBefore(today),
            );
          }
          if (query.isNotEmpty) {
            visible = visible.where(
              (t) => (t.title ?? '').toLowerCase().contains(query),
            );
          }

          final visibleList = visible.toList(growable: false)
            ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

          final scheduledSum = _sumByCurrency(scheduled.map((t) => t.amount));

          return ListView(
            padding: AppSpacing.pagePadding,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      Text('Scheduled: ${scheduled.length}'),
                      const SizedBox(height: AppSpacing.s4),
                      Text('Overdue: ${overdue.length}'),
                      const SizedBox(height: AppSpacing.s16),
                      if (scheduledSum.isEmpty)
                        const Text('Total: —')
                      else ...<Widget>[
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: AppSpacing.s4),
                        for (final entry in scheduledSum.entries)
                          Text(formatMoney(entry.value, settings: settings)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  child: Text(
                    'Overdue scheduled transactions are automatically marked as paid when you open the app.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              TextField(
                controller: _search,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.s16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Automation',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Auto-process scheduled transactions on app open',
                        ),
                        subtitle: const Text(
                          'This feature is under development.',
                        ),
                        value: settings.autoProcessScheduledOnAppOpen,
                        onChanged: (v) {
                          ref
                              .read(settingsControllerProvider.notifier)
                              .updateSettings(
                                settings.copyWith(
                                  autoProcessScheduledOnAppOpen: v,
                                ),
                              );
                        },
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Auto-process recurring transactions on app open',
                        ),
                        subtitle: const Text(
                          'This feature is under development.',
                        ),
                        value: settings.autoProcessRecurringOnAppOpen,
                        onChanged: (v) {
                          ref
                              .read(settingsControllerProvider.notifier)
                              .updateSettings(
                                settings.copyWith(
                                  autoProcessRecurringOnAppOpen: v,
                                ),
                              );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              if (visibleList.isEmpty)
                const EmptyState(
                  title: 'No scheduled transactions',
                  body:
                      'Schedule a transaction for a future date to see it here.',
                )
              else
                ImplicitAnimatedList<FinanceTransaction>(
                  items: visibleList,
                  itemKey: (t) => t.id,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, t, animation) {
                    final isLast = identical(t, visibleList.last);
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isLast ? 0 : AppSpacing.s8,
                      ),
                      child: _ScheduledTile(
                        settings: settings,
                        transaction: t,
                        onEdit: () =>
                            context.push(Routes.transactionEdit(t.id)),
                        onDelete: () => _confirmDelete(context, ref, t),
                      ),
                    );
                  },
                ),
            ],
          );
        },
        error: (e, _) {
          return Padding(
            padding: AppSpacing.pagePadding,
            child: EmptyState(
              title: 'Couldn\'t load scheduled transactions',
              body: e.toString(),
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

  static Map<String, Money> _sumByCurrency(Iterable<Money> items) {
    final out = <String, Money>{};

    for (final m in items) {
      final existing = out[m.currencyCode];
      if (existing == null) {
        out[m.currencyCode] = Money(
          currencyCode: m.currencyCode,
          amountMinor: m.amountMinor,
          scale: m.scale,
        );
        continue;
      }
      if (existing.scale != m.scale) {
        // Fallback: ignore mismatched scale for now.
        continue;
      }
      out[m.currencyCode] = existing.copyWith(
        amountMinor: existing.amountMinor + m.amountMinor,
      );
    }

    return out;
  }

  static String _titleFor(FinanceTransaction tx) {
    final raw = (tx.title ?? '').trim();
    return raw.isEmpty ? 'Untitled transaction' : raw;
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    FinanceTransaction tx,
  ) async {
    final title = _titleFor(tx);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete scheduled transaction?'),
        content: Text('Delete "$title"? This cannot be undone.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          PressableScaleDecorator.forButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(editTransactionControllerProvider.notifier)
          .deleteTransaction(transactionId: tx.id);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}

final class _ScheduledTile extends StatelessWidget {
  const _ScheduledTile({
    required this.settings,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  final AppSettings settings;
  final FinanceTransaction transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final title = (transaction.title ?? '').trim().isEmpty
        ? 'Untitled transaction'
        : (transaction.title ?? '').trim();

    final whenLabel = MaterialLocalizations.of(
      context,
    ).formatFullDate(transaction.occurredAt);

    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(whenLabel),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              formatMoney(transaction.amount, settings: settings),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
              itemBuilder: (context) => const <PopupMenuEntry<String>>[
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
        onTap: onEdit,
      ),
    );
  }
}
