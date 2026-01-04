import 'package:drift/drift.dart';

import '../datasources/drift/app_database.dart';
import '../models/budget.dart';
import '../models/enums.dart';
import '../models/money.dart';

final class BudgetMapper {
  const BudgetMapper();

  List<String> _parseCategoryIds(String csv, String fallback) {
    final raw = csv.trim();
    if (raw.isEmpty) return <String>[fallback];
    final parts = raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(growable: false);
    return parts.isEmpty ? <String>[fallback] : parts;
  }

  String _toCsv(List<String> ids) {
    return ids.map((s) => s.trim()).where((s) => s.isNotEmpty).toSet().join(',');
  }

  DateTime _monthStart(DateTime dt) => DateTime(dt.year, dt.month, 1);

  DateTime _monthEnd(DateTime dt) => DateTime(dt.year, dt.month + 1, 0);

  Budget fromRow(BudgetRow row) {
    final now = DateTime.now();
    final start = row.startDate ?? _monthStart(now);
    final end = row.endDate ?? _monthEnd(now);

    return Budget(
      id: row.id,
      name: row.name,
      amount: Money(
        currencyCode: row.currencyCode,
        amountMinor: row.amountMinor,
        scale: row.amountScale,
      ),
      startDate: start,
      endDate: end,
      categoryIds: _parseCategoryIds(row.categoryIdsCsv, row.categoryId),
      archived: row.archived,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  BudgetsTableCompanion toCompanion(Budget budget) {
    return BudgetsTableCompanion(
      id: Value(budget.id),
      name: Value(budget.name),
      type: const Value(BudgetType.timeBound),
      currencyCode: Value(budget.amount.currencyCode),
      amountMinor: Value(budget.amount.amountMinor),
      amountScale: Value(budget.amount.scale),
      categoryId: Value(budget.categoryIds.first),
      categoryIdsCsv: Value(_toCsv(budget.categoryIds)),
      startDate: Value(budget.startDate),
      endDate: Value(budget.endDate),
      archived: Value(budget.archived),
      createdAt: Value(budget.createdAt),
      updatedAt: Value(budget.updatedAt),
    );
  }
}
