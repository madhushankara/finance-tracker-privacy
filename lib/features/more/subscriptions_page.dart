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
import '../settings/providers/settings_providers.dart';
import '../transactions/providers/edit_transaction_controller.dart';
import '../transactions/providers/transactions_providers.dart';

enum _SubscriptionsSort { nextDue, amountDesc, nameAsc }

final class SubscriptionsPage extends ConsumerStatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  ConsumerState<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

final class _SubscriptionsPageState extends ConsumerState<SubscriptionsPage> {
  RecurrenceType? _filterType;
  _SubscriptionsSort _sort = _SubscriptionsSort.nextDue;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final txAsync = ref.watch(transactionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
        actions: <Widget>[
          PopupMenuButton<RecurrenceType?>(
            tooltip: 'Filter',
            icon: const Icon(Icons.filter_list_outlined),
            onSelected: (value) => setState(() => _filterType = value),
            itemBuilder: (context) => <PopupMenuEntry<RecurrenceType?>>[
              const PopupMenuItem(value: null, child: Text('All')),
              const PopupMenuItem(
                value: RecurrenceType.monthly,
                child: Text('Monthly'),
              ),
              const PopupMenuItem(
                value: RecurrenceType.weekly,
                child: Text('Weekly'),
              ),
              const PopupMenuItem(
                value: RecurrenceType.yearly,
                child: Text('Yearly'),
              ),
              const PopupMenuItem(
                value: RecurrenceType.daily,
                child: Text('Daily'),
              ),
            ],
          ),
          PopupMenuButton<_SubscriptionsSort>(
            tooltip: 'Sort',
            icon: const Icon(Icons.sort),
            onSelected: (value) => setState(() => _sort = value),
            itemBuilder: (context) =>
                const <PopupMenuEntry<_SubscriptionsSort>>[
                  PopupMenuItem(
                    value: _SubscriptionsSort.nextDue,
                    child: Text('Next due'),
                  ),
                  PopupMenuItem(
                    value: _SubscriptionsSort.amountDesc,
                    child: Text('Amount (high to low)'),
                  ),
                  PopupMenuItem(
                    value: _SubscriptionsSort.nameAsc,
                    child: Text('Name (A–Z)'),
                  ),
                ],
          ),
          PressableScaleDecorator.forButton(
            onPressed: () => context.push(Routes.addMethodSelector),
            child: IconButton(
              tooltip: 'Add',
              onPressed: () => context.push(Routes.addMethodSelector),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: txAsync.when(
        data: (txs) {
          final templates = txs
              .where(
                (t) =>
                    t.type == TransactionType.expense &&
                    t.recurrenceType != null,
              )
              .where(
                (t) => _filterType == null || t.recurrenceType == _filterType,
              )
              .toList(growable: false);

          final now = DateTime.now();
          final today = DateUtils.dateOnly(now);

          templates.sort((a, b) {
            switch (_sort) {
              case _SubscriptionsSort.nextDue:
                final ad = _nextDueDate(today: today, template: a);
                final bd = _nextDueDate(today: today, template: b);
                final cmp = ad.compareTo(bd);
                if (cmp != 0) return cmp;
                return _titleFor(a).compareTo(_titleFor(b));
              case _SubscriptionsSort.amountDesc:
                final cmp = b.amount.amountMinor.compareTo(
                  a.amount.amountMinor,
                );
                if (cmp != 0) return cmp;
                return _titleFor(a).compareTo(_titleFor(b));
              case _SubscriptionsSort.nameAsc:
                return _titleFor(a).compareTo(_titleFor(b));
            }
          });

          final monthlyTemplates = templates.where(
            (t) =>
                t.recurrenceType == RecurrenceType.monthly &&
                t.recurrenceInterval == 1,
          );
          final monthlySum = _sumSameCurrency(
            monthlyTemplates.map((t) => t.amount),
          );

          final hasNonMonthly = templates.any(
            (t) =>
                t.recurrenceType != RecurrenceType.monthly ||
                t.recurrenceInterval != 1,
          );

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
                      Text('Subscriptions: ${templates.length}'),
                      const SizedBox(height: AppSpacing.s8),
                      if (monthlySum != null)
                        Text(
                          'Estimated monthly total: ${formatMoney(monthlySum, settings: settings)}',
                        )
                      else
                        const Text('Estimated monthly total: —'),
                      if (hasNonMonthly) ...<Widget>[
                        const SizedBox(height: AppSpacing.s8),
                        Text(
                          'This feature is under development.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              if (templates.isEmpty)
                const EmptyState(
                  title: 'No subscriptions yet',
                  body:
                      'Create a recurring expense to track subscriptions here.',
                )
              else
                ImplicitAnimatedList<FinanceTransaction>(
                  items: templates,
                  itemKey: (t) => t.id,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, t, animation) {
                    final isLast = identical(t, templates.last);
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isLast ? 0 : AppSpacing.s8,
                      ),
                      child: _SubscriptionTile(
                        settings: settings,
                        transaction: t,
                        nextDue: _nextDueDate(today: today, template: t),
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
              title: 'Couldn\'t load subscriptions',
              body: e.toString(),
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

  static String _titleFor(FinanceTransaction tx) {
    final raw = (tx.title ?? '').trim();
    return raw.isEmpty ? 'Untitled subscription' : raw;
  }

  static Money? _sumSameCurrency(Iterable<Money> items) {
    Money? sum;
    for (final m in items) {
      if (sum == null) {
        sum = Money(
          currencyCode: m.currencyCode,
          amountMinor: m.amountMinor,
          scale: m.scale,
        );
        continue;
      }
      if (sum.currencyCode != m.currencyCode || sum.scale != m.scale) {
        return null;
      }
      sum = sum.copyWith(amountMinor: sum.amountMinor + m.amountMinor);
    }
    return sum;
  }

  static DateTime _nextDueDate({
    required DateTime today,
    required FinanceTransaction template,
  }) {
    final type = template.recurrenceType;
    if (type == null) return DateUtils.dateOnly(template.occurredAt);

    final start = DateUtils.dateOnly(template.occurredAt);
    final interval = template.recurrenceInterval < 1
        ? 1
        : template.recurrenceInterval;

    DateTime next;
    final last = template.lastExecutedAt == null
        ? null
        : DateUtils.dateOnly(template.lastExecutedAt!);
    if (last == null) {
      next = start;
    } else {
      next = _nextOccurrenceDate(
        type: type,
        start: start,
        current: last,
        interval: interval,
      );
    }

    var guard = 0;
    while (next.isBefore(today) && guard < 500) {
      next = _nextOccurrenceDate(
        type: type,
        start: start,
        current: next,
        interval: interval,
      );
      guard++;
    }

    return next;
  }

  static DateTime _nextOccurrenceDate({
    required RecurrenceType type,
    required DateTime start,
    required DateTime current,
    required int interval,
  }) {
    final safe = interval < 1 ? 1 : interval;
    switch (type) {
      case RecurrenceType.daily:
        return current.add(Duration(days: safe));
      case RecurrenceType.weekly:
        return current.add(Duration(days: 7 * safe));
      case RecurrenceType.monthly:
        final monthsDiff =
            (current.year - start.year) * 12 + (current.month - start.month);
        return _dateForMonthOffset(
          start: start,
          monthOffset: monthsDiff + safe,
        );
      case RecurrenceType.yearly:
        final yearsDiff = current.year - start.year;
        return _dateForYearOffset(start: start, yearOffset: yearsDiff + safe);
    }
  }

  static DateTime _dateForMonthOffset({
    required DateTime start,
    required int monthOffset,
  }) {
    final startMonthIndex = start.year * 12 + (start.month - 1);
    final targetMonthIndex = startMonthIndex + monthOffset;
    final year = targetMonthIndex ~/ 12;
    final month = (targetMonthIndex % 12) + 1;

    final lastDay = DateTime(year, month + 1, 0).day;
    final day = start.day > lastDay ? lastDay : start.day;
    return DateTime(year, month, day);
  }

  static DateTime _dateForYearOffset({
    required DateTime start,
    required int yearOffset,
  }) {
    final year = start.year + yearOffset;
    final month = start.month;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = start.day > lastDay ? lastDay : start.day;
    return DateTime(year, month, day);
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
        title: const Text('Delete subscription?'),
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

final class _SubscriptionTile extends StatelessWidget {
  const _SubscriptionTile({
    required this.settings,
    required this.transaction,
    required this.nextDue,
    required this.onEdit,
    required this.onDelete,
  });

  final AppSettings settings;
  final FinanceTransaction transaction;
  final DateTime nextDue;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final title = (transaction.title ?? '').trim().isEmpty
        ? 'Untitled subscription'
        : (transaction.title ?? '').trim();

    final recurrenceLabel = switch (transaction.recurrenceType!) {
      RecurrenceType.daily => 'Daily',
      RecurrenceType.weekly => 'Weekly',
      RecurrenceType.monthly => 'Monthly',
      RecurrenceType.yearly => 'Yearly',
    };

    final nextDueLabel = MaterialLocalizations.of(
      context,
    ).formatCompactDate(nextDue);

    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('$recurrenceLabel • Next: $nextDueLabel'),
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
