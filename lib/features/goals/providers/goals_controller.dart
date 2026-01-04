import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/models/goal.dart';
import '../../../data/models/money.dart';
import '../../../data/providers/repository_providers.dart';

final goalsControllerProvider =
    AsyncNotifierProvider.autoDispose<GoalsController, void>(
      GoalsController.new,
    );

final class GoalsController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createGoal({
    required String name,
    required Money target,
    required DateTime? targetDate,
    required String? note,
  }) async {
    state = const AsyncLoading();
    try {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        throw const FormatException('Name is required');
      }
      if (target.amountMinor <= 0) {
        throw const FormatException('Amount must be > 0');
      }

      final now = DateTime.now();
      final goal = Goal(
        id: IdGenerator.newId(),
        name: trimmed,
        target: target,
        currencyCode: target.currencyCode,
        saved: null,
        targetDate: targetDate,
        note: note,
        archived: false,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(goalRepositoryProvider).upsert(goal);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateGoal({
    required Goal existing,
    required String name,
    required Money target,
    required DateTime? targetDate,
    required String? note,
  }) async {
    state = const AsyncLoading();
    try {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        throw const FormatException('Name is required');
      }
      if (target.amountMinor <= 0) {
        throw const FormatException('Amount must be > 0');
      }

      final updated = existing.copyWith(
        name: trimmed,
        target: target,
        currencyCode: target.currencyCode,
        targetDate: targetDate,
        note: note,
        updatedAt: DateTime.now(),
      );

      await ref.read(goalRepositoryProvider).upsert(updated);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> deleteGoal({required String goalId}) async {
    state = const AsyncLoading();
    try {
      await ref.read(goalRepositoryProvider).deleteById(goalId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
