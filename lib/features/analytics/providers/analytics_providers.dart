import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formatting/money_format.dart' as money_fmt;
import '../../../data/models/app_settings.dart';
import '../../../data/models/category.dart';
import '../../../data/models/money.dart';
import '../../../data/models/transaction.dart';
import '../../settings/providers/settings_providers.dart';
import '../../transactions/providers/transactions_providers.dart';
import '../services/analytics_calculator.dart';

final analyticsCalculatorProvider = Provider<AnalyticsCalculator>((ref) {
  return const AnalyticsCalculator();
});

final analyticsRangePresetProvider = StateProvider<AnalyticsRangePreset>((ref) {
  return AnalyticsRangePreset.thisMonth;
});

final analyticsCustomRangeProvider = StateProvider<AnalyticsDateRange?>((ref) {
  return null;
});

final class AnalyticsViewModel {
  const AnalyticsViewModel({
    required this.range,
    required this.summary,
    required this.categoryNameById,
  });

  final AnalyticsDateRange range;
  final AnalyticsSummary summary;
  final Map<String, String> categoryNameById;

  String formatMoneyText(Money money, {AppSettings? settings}) {
    return money_fmt.formatMoney(
      money,
      includeCurrencyCode: true,
      settings: settings,
    );
  }
}

final analyticsViewModelProvider = Provider.autoDispose<AsyncValue<AnalyticsViewModel>>((ref) {
  final txAsync = ref.watch(transactionsListProvider);
  final catsAsync = ref.watch(transactionCategoriesProvider);
  final settings = ref.watch(appSettingsProvider);

  if (txAsync.isLoading || catsAsync.isLoading) {
    return const AsyncLoading();
  }
  final txErr = txAsync.error;
  if (txErr != null) {
    return AsyncError(txErr, txAsync.stackTrace ?? StackTrace.current);
  }
  final catErr = catsAsync.error;
  if (catErr != null) {
    return AsyncError(catErr, catsAsync.stackTrace ?? StackTrace.current);
  }

  final transactions = txAsync.value ?? const <FinanceTransaction>[];
  final categories = catsAsync.value ?? const <Category>[];

  final preset = ref.watch(analyticsRangePresetProvider);
  final custom = ref.watch(analyticsCustomRangeProvider);

  final calculator = ref.watch(analyticsCalculatorProvider);
  final now = DateTime.now();

  final AnalyticsDateRange range = switch (preset) {
    AnalyticsRangePreset.custom => (custom ?? calculator.presetRange(preset: AnalyticsRangePreset.thisMonth, now: now)),
    _ => calculator.presetRange(preset: preset, now: now),
  };

  // For now, analytics are computed in the primary currency only.
  final currency = settings.primaryCurrencyCode;

  int scale = 2;
  for (final tx in transactions) {
    if (tx.amount.currencyCode == currency) {
      scale = tx.amount.scale;
      break;
    }
  }

  final summary = calculator.compute(
    transactions: transactions,
    range: range,
    currencyCode: currency,
    scale: scale,
  );

  final categoryNameById = <String, String>{
    for (final c in categories) c.id: c.name,
  };

  return AsyncData(
    AnalyticsViewModel(
      range: range,
      summary: summary,
      categoryNameById: categoryNameById,
    ),
  );
});
