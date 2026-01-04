import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ephemeral (in-memory) prefill values for the add flow.
///
/// Used by the Calendar page to pre-fill the date in the manual Add Transaction form.
final addTransactionPrefillDateProvider = StateProvider<DateTime?>(
  (ref) => null,
);
