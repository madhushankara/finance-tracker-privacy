import 'package:flutter/material.dart';

import '../../../core/animations/motion.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/semantic_amount_text.dart';
import '../../../data/models/account.dart';
import '../../../data/models/category.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/transaction.dart';
import '../../categories/widgets/category_icon.dart';

typedef TransactionTapBuilder = VoidCallback? Function(FinanceTransaction tx);

final class TransactionGroupCard extends StatelessWidget {
  const TransactionGroupCard({
    super.key,
    required this.label,
    required this.items,
    required this.accountsById,
    required this.categoriesById,
    this.onTapBuilder,
  });

  final String label;
  final List<FinanceTransaction> items;
  final Map<String, Account> accountsById;
  final Map<String, Category> categoriesById;
  final TransactionTapBuilder? onTapBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.s8),
        Card(
          child: AnimatedSize(
            duration: Motion.duration(context, MotionDurations.fast),
            curve: MotionCurves.standard,
            child: Column(
              children: <Widget>[
                for (var i = 0; i < items.length; i++) ...<Widget>[
                  TransactionRow(
                    tx: items[i],
                    account: accountsById[items[i].accountId],
                    category: items[i].categoryId == null
                        ? null
                        : categoriesById[items[i].categoryId!],
                    onTap: onTapBuilder?.call(items[i]),
                  ),
                  if (i != items.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final class TransactionRow extends StatelessWidget {
  const TransactionRow({
    super.key,
    required this.tx,
    required this.account,
    required this.category,
    this.onTap,
  });

  final FinanceTransaction tx;
  final Account? account;
  final Category? category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isScheduled = tx.status == TransactionStatus.scheduled;
    final isRecurring = tx.recurrenceType != null;

    final title = (tx.title?.trim().isNotEmpty ?? false)
        ? tx.title!.trim()
        : (category?.name.trim().isNotEmpty ?? false)
        ? category!.name
        : 'Transaction';

    final accountName = account?.name;

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s8,
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 48,
                height: 48,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.surfaceContainerHighest,
                  ),
                  child: Center(
                    child: CategoryIcon(
                      iconKey: category?.iconKey,
                      colorHex: category?.colorHex,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isScheduled) ...<Widget>[
                          const SizedBox(width: AppSpacing.s8),
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: cs.onSurfaceVariant,
                          ),
                        ],
                        if (isRecurring) ...<Widget>[
                          const SizedBox(width: AppSpacing.s8),
                          Icon(
                            Icons.repeat,
                            size: 16,
                            color: cs.onSurfaceVariant,
                          ),
                        ],
                      ],
                    ),
                    if (accountName != null &&
                        accountName.trim().isNotEmpty) ...<Widget>[
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        (isScheduled || isRecurring)
                            ? '$accountName • ${[if (isScheduled) 'Scheduled', if (isRecurring) 'Recurring'].join(' • ')}'
                            : accountName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SemanticAmountText(
                    type: tx.type,
                    amount: tx.amount,
                    includeCurrencyCode: false,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    tx.amount.currencyCode,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
