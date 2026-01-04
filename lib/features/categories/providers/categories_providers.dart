import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/category.dart';
import '../../../data/models/enums.dart';
import '../../../data/providers/repository_providers.dart';

final categoriesListProvider = StreamProvider.autoDispose<List<Category>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAll();
});

final categoryByIdProvider = FutureProvider.autoDispose.family<Category?, String>((ref, id) {
  return ref.watch(categoryRepositoryProvider).getById(id);
});

final categoriesByTypeProvider = Provider.autoDispose.family<List<Category>, CategoryType>((ref, type) {
  final async = ref.watch(categoriesListProvider);
  return async.maybeWhen(
    data: (items) => items.where((c) => c.type == type).toList(growable: false),
    orElse: () => const <Category>[],
  );
});

final categoryChildrenCountProvider = Provider.autoDispose.family<int, String>((ref, parentId) {
  final async = ref.watch(categoriesListProvider);
  return async.maybeWhen(
    data: (items) => items.where((c) => c.parentId == parentId).length,
    orElse: () => 0,
  );
});
