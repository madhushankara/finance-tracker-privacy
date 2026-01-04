import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/loan.dart';
import '../../../data/providers/repository_providers.dart';

final loansListProvider = StreamProvider.autoDispose<List<Loan>>((ref) {
  return ref.watch(loanRepositoryProvider).watchAll();
});

final loanByIdProvider = FutureProvider.autoDispose.family<Loan?, String>((
  ref,
  id,
) {
  return ref.watch(loanRepositoryProvider).getById(id);
});
