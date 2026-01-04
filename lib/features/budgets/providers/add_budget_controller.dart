import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/models/budget.dart';
import '../../../data/models/money.dart';
import '../../../data/providers/repository_providers.dart';

final addBudgetControllerProvider = AsyncNotifierProvider.autoDispose<AddBudgetController, void>(
  AddBudgetController.new,
);

final class AddBudgetController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  Future<void> createBudget({
    required String name,
    required Money amount,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> categoryIds,
  }) async {
    state = const AsyncLoading();
    try {
      final trimmedName = name.trim();
      if (trimmedName.isEmpty) {
        throw const FormatException('Budget name is required');
      }
      if (amount.amountMinor <= 0) {
        throw const FormatException('Budget amount must be > 0');
      }
      final cats = categoryIds.map((c) => c.trim()).where((c) => c.isNotEmpty).toSet().toList();
      if (cats.isEmpty) {
        throw const FormatException('Select at least one expense category');
      }

      final start = _dateOnly(startDate);
      final end = _dateOnly(endDate);
      if (end.isBefore(start)) {
        throw const FormatException('End date must be on or after start date');
      }

      final now = DateTime.now();
      final budget = Budget(
        id: 'bud_${IdGenerator.newId()}',
        name: trimmedName,
        amount: amount,
        startDate: start,
        endDate: end,
        categoryIds: cats,
        archived: false,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(budgetRepositoryProvider).upsert(budget);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
