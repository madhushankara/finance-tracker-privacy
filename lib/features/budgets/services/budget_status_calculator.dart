import '../../../data/models/budget.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/money.dart';
import '../../../data/models/transaction.dart';

final class BudgetStatus {
  const BudgetStatus({
    required this.spent,
    required this.remaining,
    required this.percentageUsed,
    required this.isNearLimit,
    required this.isExceeded,
    required this.contributingTransactions,
  });

  final Money spent;
  final Money remaining;

  /// Fraction of budget used.
  /// Example: 0.5 => 50%, 1.0 => 100%, 1.2 => 120%.
  final double percentageUsed;

  /// True when used >= 80%.
  final bool isNearLimit;

  /// True when used > 100%.
  final bool isExceeded;

  /// Transactions contributing to this budget (read-only).
  ///
  /// Excludes scheduled and recurring templates.
  final List<FinanceTransaction> contributingTransactions;
}

final class BudgetStatusCalculator {
  const BudgetStatusCalculator();

  BudgetStatus compute({
    required Budget budget,
    required List<FinanceTransaction> transactions,
  }) {
    final contributing = filterContributingTransactions(
      budget: budget,
      transactions: transactions,
    );

    final currencyCode = budget.amount.currencyCode;
    final scale = budget.amount.scale;

    var spentMinor = 0;
    for (final tx in contributing) {
      // contributing list already enforces matching currency/scale.
      spentMinor += tx.amount.amountMinor;
    }

    final spent = Money(currencyCode: currencyCode, amountMinor: spentMinor, scale: scale);
    final remaining = Money(
      currencyCode: currencyCode,
      amountMinor: budget.amount.amountMinor - spentMinor,
      scale: scale,
    );

    final totalMinor = budget.amount.amountMinor;
    final used = totalMinor <= 0 ? 0.0 : (spentMinor / totalMinor);

    final isNear = used >= 0.8;
    final isExceeded = used > 1.0;

    return BudgetStatus(
      spent: spent,
      remaining: remaining,
      percentageUsed: used.isNaN || used.isInfinite ? 0.0 : used,
      isNearLimit: isNear,
      isExceeded: isExceeded,
      contributingTransactions: contributing,
    );
  }

  List<FinanceTransaction> filterContributingTransactions({
    required Budget budget,
    required List<FinanceTransaction> transactions,
  }) {
    final start = _dateOnly(budget.startDate);
    final end = _dateOnly(budget.endDate);

    final currencyCode = budget.amount.currencyCode;
    final scale = budget.amount.scale;

    final out = <FinanceTransaction>[];
    for (final tx in transactions) {
      if (tx.type != TransactionType.expense) continue;
      if (tx.status == TransactionStatus.scheduled) continue;
      if (tx.recurrenceType != null) continue;

      final categoryId = tx.categoryId;
      if (categoryId == null) continue;
      if (!budget.categoryIds.contains(categoryId)) continue;

      final d = _dateOnly(tx.occurredAt);
      if (d.isBefore(start) || d.isAfter(end)) continue;

      if (tx.amount.currencyCode != currencyCode || tx.amount.scale != scale) {
        // Keep logic deterministic: ignore mismatched currencies/scales.
        continue;
      }

      out.add(tx);
    }

    // Sort newest first for display purposes.
    out.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return out;
  }

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
