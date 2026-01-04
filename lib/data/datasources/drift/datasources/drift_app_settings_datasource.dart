import 'package:drift/drift.dart';

import '../../../models/app_settings.dart';
import '../app_database.dart';

final class DriftAppSettingsDataSource {
  DriftAppSettingsDataSource(this._db);

  static const int _rowId = 1;

  final AppDatabase _db;

  Stream<AppSettings> watch() {
    return (_db.select(_db.appSettingsTable)
          ..where((t) => t.id.equals(_rowId))
          ..limit(1))
        .watchSingleOrNull()
        .map((row) => row == null ? AppSettings.defaults : _fromRow(row));
  }

  Future<AppSettings> get() async {
    final row =
        await (_db.select(_db.appSettingsTable)
              ..where((t) => t.id.equals(_rowId))
              ..limit(1))
            .getSingleOrNull();
    return row == null ? AppSettings.defaults : _fromRow(row);
  }

  Future<void> upsert(AppSettings settings) async {
    await _db
        .into(_db.appSettingsTable)
        .insertOnConflictUpdate(_toCompanion(settings));
  }

  AppSettings _fromRow(AppSettingsRow row) {
    return AppSettings(
      primaryCurrencyCode: row.primaryCurrencyCode,
      firstDayOfWeek: row.firstDayOfWeek,
      dateFormat: row.dateFormat,
      useGrouping: row.useGrouping,
      decimalSeparator: row.decimalSeparator,
      themeMode: row.themeMode,
      accentColor: row.accentColor,
      useMaterialYouColors: row.useMaterialYouColors,
      showExpenseInRed: row.showExpenseInRed,
      onboardingCompleted: row.onboardingCompleted,
      authUserId: row.authUserId,
      authUsername: row.authUsername,
      authDisplayName: row.authDisplayName,
      authBirthday: row.authBirthdayMillis == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row.authBirthdayMillis!),
      authIsDemo: row.authIsDemo,
      demoDataSeeded: row.demoDataSeeded,
      homeFeatureCardsDismissedCsv: row.homeFeatureCardsDismissedCsv,
      lastBirthdayCelebratedAt: row.lastBirthdayCelebratedAtMillis == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              row.lastBirthdayCelebratedAtMillis!,
            ),

      homeSectionOrderCsv: row.homeSectionOrderCsv,
      homeShowUsername: row.homeShowUsername,
      homeShowBanner: row.homeShowBanner,
      homeShowAccounts: row.homeShowAccounts,
      homeShowBudgets: row.homeShowBudgets,
      homeShowGoals: row.homeShowGoals,
      homeShowIncomeAndExpenses: row.homeShowIncomeAndExpenses,
      homeShowNetWorth: row.homeShowNetWorth,
      homeShowOverdueAndUpcoming: row.homeShowOverdueAndUpcoming,
      homeShowLoans: row.homeShowLoans,
      homeShowLongTermLoans: row.homeShowLongTermLoans,
      homeShowSpendingGraph: row.homeShowSpendingGraph,
      homeShowPieChart: row.homeShowPieChart,
      homeShowHeatMap: row.homeShowHeatMap,
      homeShowTransactionsList: row.homeShowTransactionsList,

      transactionReminderEnabled: row.transactionReminderEnabled,
      transactionReminderTimeMinutes: row.transactionReminderTimeMinutes,
      upcomingTransactionsEnabled: row.upcomingTransactionsEnabled,

      requireBiometricOnLaunch: row.requireBiometricOnLaunch,

      languageCode: row.languageCode,

      autoProcessScheduledOnAppOpen: row.autoProcessScheduledOnAppOpen,
      autoProcessRecurringOnAppOpen: row.autoProcessRecurringOnAppOpen,

      swipeBetweenTabsEnabled: row.swipeBetweenTabsEnabled,
    );
  }

  AppSettingsTableCompanion _toCompanion(AppSettings settings) {
    return AppSettingsTableCompanion.insert(
      id: Value(_rowId),
      primaryCurrencyCode: settings.primaryCurrencyCode,
      firstDayOfWeek: settings.firstDayOfWeek,
      dateFormat: settings.dateFormat,
      useGrouping: settings.useGrouping,
      decimalSeparator: settings.decimalSeparator,
      themeMode: Value(settings.themeMode),
      accentColor: Value(settings.accentColor),
      useMaterialYouColors: Value(settings.useMaterialYouColors),
      showExpenseInRed: Value(settings.showExpenseInRed),
      onboardingCompleted: Value(settings.onboardingCompleted),
      authUserId: Value(settings.authUserId),
      authUsername: Value(settings.authUsername),
      authDisplayName: Value(settings.authDisplayName),
      authBirthdayMillis: Value(settings.authBirthday?.millisecondsSinceEpoch),
      authIsDemo: Value(settings.authIsDemo),
      demoDataSeeded: Value(settings.demoDataSeeded),
      homeFeatureCardsDismissedCsv: Value(
        settings.homeFeatureCardsDismissedCsv,
      ),
      lastBirthdayCelebratedAtMillis: Value(
        settings.lastBirthdayCelebratedAt?.millisecondsSinceEpoch,
      ),

      homeSectionOrderCsv: Value(settings.homeSectionOrderCsv),
      homeShowUsername: Value(settings.homeShowUsername),
      homeShowBanner: Value(settings.homeShowBanner),
      homeShowAccounts: Value(settings.homeShowAccounts),
      homeShowBudgets: Value(settings.homeShowBudgets),
      homeShowGoals: Value(settings.homeShowGoals),
      homeShowIncomeAndExpenses: Value(settings.homeShowIncomeAndExpenses),
      homeShowNetWorth: Value(settings.homeShowNetWorth),
      homeShowOverdueAndUpcoming: Value(settings.homeShowOverdueAndUpcoming),
      homeShowLoans: Value(settings.homeShowLoans),
      homeShowLongTermLoans: Value(settings.homeShowLongTermLoans),
      homeShowSpendingGraph: Value(settings.homeShowSpendingGraph),
      homeShowPieChart: Value(settings.homeShowPieChart),
      homeShowHeatMap: Value(settings.homeShowHeatMap),
      homeShowTransactionsList: Value(settings.homeShowTransactionsList),

      transactionReminderEnabled: Value(settings.transactionReminderEnabled),
      transactionReminderTimeMinutes: Value(
        settings.transactionReminderTimeMinutes,
      ),
      upcomingTransactionsEnabled: Value(settings.upcomingTransactionsEnabled),

      requireBiometricOnLaunch: Value(settings.requireBiometricOnLaunch),

      languageCode: Value(settings.languageCode),

      autoProcessScheduledOnAppOpen: Value(
        settings.autoProcessScheduledOnAppOpen,
      ),
      autoProcessRecurringOnAppOpen: Value(
        settings.autoProcessRecurringOnAppOpen,
      ),

      swipeBetweenTabsEnabled: Value(settings.swipeBetweenTabsEnabled),
    );
  }
}
