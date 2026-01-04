import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/app_settings.dart';
import '../../../data/providers/repository_providers.dart';

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, void>(SettingsController.new);

final class SettingsController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial work.
  }

  Future<void> updateFromCurrent(
    AppSettings Function(AppSettings) update,
  ) async {
    final current = await ref.read(appSettingsRepositoryProvider).get();
    return updateSettings(update(current));
  }

  Future<void> updateSettings(AppSettings settings) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(appSettingsRepositoryProvider).upsert(settings);
    });
  }

  Future<void> updateFirstDayOfWeek(FirstDayOfWeek value) async {
    final current = await ref.read(appSettingsRepositoryProvider).get();
    return updateSettings(current.copyWith(firstDayOfWeek: value));
  }

  Future<void> updateDateFormat(AppDateFormat value) async {
    final current = await ref.read(appSettingsRepositoryProvider).get();
    return updateSettings(current.copyWith(dateFormat: value));
  }

  Future<void> updatePrimaryCurrencyCode(String value) async {
    final code = value.trim().toUpperCase();
    if (code.isEmpty) return;
    final current = await ref.read(appSettingsRepositoryProvider).get();
    return updateSettings(current.copyWith(primaryCurrencyCode: code));
  }

  Future<void> updateShowExpenseInRed(bool value) async {
    final current = await ref.read(appSettingsRepositoryProvider).get();
    return updateSettings(current.copyWith(showExpenseInRed: value));
  }

  Future<void> updateThemeMode(AppThemeMode value) async {
    final current = await ref.read(appSettingsRepositoryProvider).get();
    return updateSettings(current.copyWith(themeMode: value));
  }

  Future<void> updateAccentColor(AppAccentColor value) async {
    final current = await ref.read(appSettingsRepositoryProvider).get();
    return updateSettings(current.copyWith(accentColor: value));
  }

  Future<void> updateUseMaterialYouColors(bool value) async {
    final current = await ref.read(appSettingsRepositoryProvider).get();
    return updateSettings(current.copyWith(useMaterialYouColors: value));
  }

  Future<void> updateSwipeBetweenTabsEnabled(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(swipeBetweenTabsEnabled: value),
    );
  }

  Future<void> updateHomeSectionOrderCsv(String value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeSectionOrderCsv: value),
    );
  }

  Future<void> updateHomeShowUsername(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowUsername: value),
    );
  }

  Future<void> updateHomeShowBanner(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowBanner: value),
    );
  }

  Future<void> updateHomeShowAccounts(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowAccounts: value),
    );
  }

  Future<void> updateHomeShowBudgets(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowBudgets: value),
    );
  }

  Future<void> updateHomeShowGoals(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowGoals: value),
    );
  }

  Future<void> updateHomeShowIncomeAndExpenses(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowIncomeAndExpenses: value),
    );
  }

  Future<void> updateHomeShowNetWorth(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowNetWorth: value),
    );
  }

  Future<void> updateHomeShowOverdueAndUpcoming(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowOverdueAndUpcoming: value),
    );
  }

  Future<void> updateHomeShowLoans(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowLoans: value),
    );
  }

  Future<void> updateHomeShowLongTermLoans(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowLongTermLoans: value),
    );
  }

  Future<void> updateHomeShowSpendingGraph(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowSpendingGraph: value),
    );
  }

  Future<void> updateHomeShowPieChart(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowPieChart: value),
    );
  }

  Future<void> updateHomeShowHeatMap(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowHeatMap: value),
    );
  }

  Future<void> updateHomeShowTransactionsList(bool value) async {
    return updateFromCurrent(
      (current) => current.copyWith(homeShowTransactionsList: value),
    );
  }
}
