import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/id_generator.dart';
import '../../../data/models/category.dart';
import '../../../data/models/enums.dart';
import '../../../data/providers/repository_providers.dart';

final categoriesControllerProvider = AsyncNotifierProvider.autoDispose<CategoriesController, void>(
  CategoriesController.new,
);

final class CategoriesController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createCategory({
    required String name,
    required CategoryType type,
    String? parentId,
    String? iconKey,
    int? colorHex,
  }) async {
    state = const AsyncLoading();
    try {
      final now = DateTime.now();
      final id = IdGenerator.newId();

      final category = Category(
        id: id,
        name: name,
        type: type,
        parentId: parentId,
        iconKey: iconKey,
        colorHex: colorHex,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(categoryRepositoryProvider).upsert(category);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> updateCategory({
    required Category existing,
    required String name,
    String? iconKey,
    int? colorHex,
  }) async {
    state = const AsyncLoading();
    try {
      final updated = existing.copyWith(
        name: name,
        iconKey: iconKey,
        colorHex: colorHex,
        updatedAt: DateTime.now(),
      );
      await ref.read(categoryRepositoryProvider).upsert(updated);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> deleteCategory({required Category category}) async {
    state = const AsyncLoading();
    try {
      final children = await ref.read(categoryRepositoryProvider).countChildren(category.id);
      if (children > 0) {
        throw StateError('Delete blocked: this category has $children subcategories.');
      }
      await ref.read(categoryRepositoryProvider).deleteById(category.id);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
