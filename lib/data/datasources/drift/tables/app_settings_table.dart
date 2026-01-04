part of '../app_database.dart';

@DataClassName('AppSettingsRow')
class AppSettingsTable extends Table {
  // Single-row table.
  IntColumn get id => integer()();

  TextColumn get primaryCurrencyCode => text()();

  IntColumn get firstDayOfWeek => intEnum<FirstDayOfWeek>()();

  IntColumn get dateFormat => intEnum<AppDateFormat>()();

  BoolColumn get useGrouping => boolean()();

  IntColumn get decimalSeparator => intEnum<DecimalSeparator>()();

  /// Theme mode selection.
  IntColumn get themeMode =>
      intEnum<AppThemeMode>().withDefault(const Constant(0))();

  /// Accent color selection.
  IntColumn get accentColor =>
      intEnum<AppAccentColor>().withDefault(const Constant(0))();

  /// Material You dynamic colors toggle.
  BoolColumn get useMaterialYouColors =>
      boolean().withDefault(const Constant(false))();

  /// Whether expense (debit) amounts are highlighted in red.
  ///
  /// Default is true to preserve existing behavior.
  BoolColumn get showExpenseInRed =>
      boolean().withDefault(const Constant(true))();

  /// Persisted onboarding state.
  ///
  /// Default is false so fresh installs see onboarding.
  /// Existing installs are migrated to true in schema v6.
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();

  /// Local-only auth user id.
  TextColumn get authUserId => text().nullable()();

  /// Username used for demo/local auth.
  TextColumn get authUsername => text().nullable()();

  /// Display name shown in the UI.
  TextColumn get authDisplayName => text().nullable()();

  /// Birthday (stored as millisecondsSinceEpoch; date-only semantics in UI).
  IntColumn get authBirthdayMillis => integer().nullable()();

  /// True when the current session is a demo user.
  BoolColumn get authIsDemo => boolean().withDefault(const Constant(false))();

  /// One-time demo data seed guard.
  BoolColumn get demoDataSeeded =>
      boolean().withDefault(const Constant(false))();

  /// CSV of dismissed home preview card ids.
  TextColumn get homeFeatureCardsDismissedCsv =>
      text().withDefault(const Constant(''))();

  /// Last time we celebrated birthday in-app (millisecondsSinceEpoch).
  IntColumn get lastBirthdayCelebratedAtMillis => integer().nullable()();

  // =====================
  // Phase 7: Homepage customization
  // =====================

  /// CSV list of home section ids in display order.
  TextColumn get homeSectionOrderCsv => text().withDefault(
    const Constant(
      'banner,accounts,budgets,goals,income_expenses,net_worth,overdue_upcoming,loans,long_term_loans,spending_graph,pie_chart,heat_map,transactions',
    ),
  )();

  BoolColumn get homeShowUsername =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get homeShowBanner =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get homeShowAccounts =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get homeShowBudgets =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get homeShowGoals =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get homeShowIncomeAndExpenses =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get homeShowNetWorth =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get homeShowOverdueAndUpcoming =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get homeShowLoans =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get homeShowLongTermLoans =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get homeShowSpendingGraph =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get homeShowPieChart =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get homeShowHeatMap =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get homeShowTransactionsList =>
      boolean().withDefault(const Constant(true))();

  // =====================
  // Phase 7: Notifications
  // =====================

  BoolColumn get transactionReminderEnabled =>
      boolean().withDefault(const Constant(false))();

  /// Minutes since midnight local time.
  IntColumn get transactionReminderTimeMinutes =>
      integer().withDefault(const Constant(1200))();

  BoolColumn get upcomingTransactionsEnabled =>
      boolean().withDefault(const Constant(false))();

  // =====================
  // Phase 7: Security
  // =====================

  BoolColumn get requireBiometricOnLaunch =>
      boolean().withDefault(const Constant(false))();

  // =====================
  // Phase 7: Language
  // =====================

  TextColumn get languageCode => text().withDefault(const Constant('en'))();

  // =====================
  // Phase 9: Scheduled overview (preferences only)
  // =====================

  BoolColumn get autoProcessScheduledOnAppOpen =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get autoProcessRecurringOnAppOpen =>
      boolean().withDefault(const Constant(false))();

  // =====================
  // Navigation
  // =====================

  /// Allow swiping left/right to switch between main tabs.
  BoolColumn get swipeBetweenTabsEnabled =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => <Column>{id};
}
