import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/goal.dart';
import '../../../data/providers/repository_providers.dart';

final goalsListProvider = StreamProvider.autoDispose<List<Goal>>((ref) {
  return ref.watch(goalRepositoryProvider).watchAll();
});

final goalByIdProvider = FutureProvider.autoDispose.family<Goal?, String>((
  ref,
  id,
) {
  return ref.watch(goalRepositoryProvider).getById(id);
});
