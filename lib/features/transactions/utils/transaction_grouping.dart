import '../../../core/formatting/transaction_date_group_label.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/models/transaction.dart';

final class TransactionDateGroup {
  const TransactionDateGroup({required this.label, required this.items});

  final String label;
  final List<FinanceTransaction> items;
}

List<TransactionDateGroup> groupTransactionsByDate(
  List<FinanceTransaction> transactions, {
  AppSettings? settings,
  DateTime? now,
  String? locale,
}) {
  if (transactions.isEmpty) return const <TransactionDateGroup>[];

  final groups = <TransactionDateGroup>[];

  String? currentLabel;
  List<FinanceTransaction>? bucket;

  for (final tx in transactions) {
    final label = transactionDateGroupLabel(
      tx.occurredAt,
      settings: settings,
      now: now,
      locale: locale,
    );

    if (currentLabel != label) {
      if (bucket != null && currentLabel != null) {
        groups.add(TransactionDateGroup(label: currentLabel, items: bucket));
      }
      currentLabel = label;
      bucket = <FinanceTransaction>[];
    }

    bucket!.add(tx);
  }

  if (bucket != null && currentLabel != null) {
    groups.add(TransactionDateGroup(label: currentLabel, items: bucket));
  }

  return groups;
}
