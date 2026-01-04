import 'package:meta/meta.dart';

enum FirstDayOfWeek { monday, sunday }

enum AppDateFormat {
  /// User/locale friendly (e.g. "Fri, 3 Jan").
  localeBased,

  /// ISO 8601 date-only (e.g. "2026-01-03").
  iso,
}

enum DecimalSeparator { dot, comma }

enum AppThemeMode { system, light, dark }

enum AppAccentColor {
  /// Default (preserves current look).
  blue,
  purple,
  green,
  orange,
  red,
  teal,
}

@immutable
final class AppSettings {
  const AppSettings({
    required this.primaryCurrencyCode,
    required this.firstDayOfWeek,
    required this.dateFormat,
    required this.useGrouping,
    required this.decimalSeparator,
    required this.themeMode,
    required this.accentColor,
    required this.useMaterialYouColors,
    required this.showExpenseInRed,
    required this.onboardingCompleted,
    required this.authUserId,
    required this.authUsername,
    required this.authDisplayName,
    required this.authBirthday,
    required this.authIsDemo,
    required this.demoDataSeeded,
    required this.homeFeatureCardsDismissedCsv,
    required this.lastBirthdayCelebratedAt,

    // Phase 7: Homepage customization.
    required this.homeSectionOrderCsv,
    required this.homeShowUsername,
    required this.homeShowBanner,
    required this.homeShowAccounts,
    required this.homeShowBudgets,
    required this.homeShowGoals,
    required this.homeShowIncomeAndExpenses,
    required this.homeShowNetWorth,
    required this.homeShowOverdueAndUpcoming,
    required this.homeShowLoans,
    required this.homeShowLongTermLoans,
    required this.homeShowSpendingGraph,
    required this.homeShowPieChart,
    required this.homeShowHeatMap,
    required this.homeShowTransactionsList,

    // Phase 7: Notifications.
    required this.transactionReminderEnabled,
    required this.transactionReminderTimeMinutes,
    required this.upcomingTransactionsEnabled,

    // Phase 7: Security.
    required this.requireBiometricOnLaunch,

    // Phase 7: Language.
    required this.languageCode,

    // Phase 9: Scheduled overview (preferences only).
    required this.autoProcessScheduledOnAppOpen,
    required this.autoProcessRecurringOnAppOpen,

    // Navigation.
    required this.swipeBetweenTabsEnabled,
  });

  /// Used for cross-currency totals, analytics, and recurring execution semantics.
  /// Defaults to a safe, non-disruptive value (not currently used to rewrite stored data).
  final String primaryCurrencyCode;

  final FirstDayOfWeek firstDayOfWeek;

  final AppDateFormat dateFormat;

  /// Whether formatted numbers should use digit grouping.
  final bool useGrouping;

  final DecimalSeparator decimalSeparator;

  /// App-wide theme mode.
  ///
  /// Default is system to follow device theme.
  final AppThemeMode themeMode;

  /// App-wide accent color.
  ///
  /// Ignored when [useMaterialYouColors] is enabled and supported.
  final AppAccentColor accentColor;

  /// When true and supported, use Material You dynamic colors.
  ///
  /// Default is false.
  final bool useMaterialYouColors;

  /// When true, expense (debit) amounts are highlighted in red.
  ///
  /// Default is true to preserve existing semantics.
  final bool showExpenseInRed;

  /// Whether the onboarding walkthrough has been completed or skipped.
  ///
  /// When false, the app may show a short, skippable onboarding flow.
  final bool onboardingCompleted;

  /// Local-only "auth" state.
  ///
  /// This app currently has no real backend auth; these fields exist only to
  /// drive UI and demo flows.
  final String? authUserId;

  /// Login username (for demo/local auth).
  final String? authUsername;

  /// Display name shown in the UI.
  final String? authDisplayName;

  /// Optional birthday date (date-only semantics in UI).
  final DateTime? authBirthday;

  /// True when the user is logged in via the demo credentials.
  final bool authIsDemo;

  /// One-time demo data seeding guard.
  final bool demoDataSeeded;

  /// CSV of dismissed home preview card ids.
  ///
  /// Kept as a simple string for forward compatibility.
  final String homeFeatureCardsDismissedCsv;

  /// The last time we celebrated the user's birthday in-app.
  ///
  /// Used to ensure "once per day" behavior.
  final DateTime? lastBirthdayCelebratedAt;

  // =====================
  // Phase 7: Homepage customization
  // =====================

  /// CSV list of home section ids in display order.
  ///
  /// Kept as a string for forward compatibility.
  final String homeSectionOrderCsv;

  final bool homeShowUsername;
  final bool homeShowBanner;
  final bool homeShowAccounts;
  final bool homeShowBudgets;
  final bool homeShowGoals;
  final bool homeShowIncomeAndExpenses;
  final bool homeShowNetWorth;
  final bool homeShowOverdueAndUpcoming;
  final bool homeShowLoans;
  final bool homeShowLongTermLoans;
  final bool homeShowSpendingGraph;
  final bool homeShowPieChart;
  final bool homeShowHeatMap;
  final bool homeShowTransactionsList;

  // =====================
  // Phase 7: Notifications
  // =====================

  /// UI-only for now. No background jobs are scheduled yet.
  final bool transactionReminderEnabled;

  /// Minutes since midnight local time.
  final int transactionReminderTimeMinutes;

  /// UI-only for now.
  final bool upcomingTransactionsEnabled;

  // =====================
  // Phase 7: Security
  // =====================

  /// Persisted preference only.
  final bool requireBiometricOnLaunch;

  // =====================
  // Phase 7: Language
  // =====================

  /// Persisted selection only; translations are under development.
  final String languageCode;

  // =====================
  // Phase 9: Scheduled overview (preferences only)
  // =====================

  /// Persisted preference only. Does not change app behavior yet.
  final bool autoProcessScheduledOnAppOpen;

  /// Persisted preference only. Does not change app behavior yet.
  final bool autoProcessRecurringOnAppOpen;

  // =====================
  // Navigation
  // =====================

  /// Allow swiping left/right to switch between main tabs.
  ///
  /// Default is false.
  final bool swipeBetweenTabsEnabled;

  static const AppSettings defaults = AppSettings(
    primaryCurrencyCode: 'INR',
    firstDayOfWeek: FirstDayOfWeek.monday,
    dateFormat: AppDateFormat.localeBased,
    useGrouping: true,
    decimalSeparator: DecimalSeparator.dot,
    themeMode: AppThemeMode.system,
    accentColor: AppAccentColor.blue,
    useMaterialYouColors: false,
    showExpenseInRed: true,
    onboardingCompleted: false,
    authUserId: null,
    authUsername: null,
    authDisplayName: null,
    authBirthday: null,
    authIsDemo: false,
    demoDataSeeded: false,
    homeFeatureCardsDismissedCsv: '',
    lastBirthdayCelebratedAt: null,

    // Phase 7 defaults (preserve current Home layout).
    homeShowUsername: true,
    homeShowBanner: true,
    homeShowAccounts: true,
    homeShowBudgets: false,
    homeShowGoals: false,
    homeShowIncomeAndExpenses: false,
    homeShowNetWorth: false,
    homeShowOverdueAndUpcoming: false,
    homeShowLoans: false,
    homeShowLongTermLoans: false,
    homeShowSpendingGraph: false,
    homeShowPieChart: false,
    homeShowHeatMap: false,
    homeShowTransactionsList: true,

    homeSectionOrderCsv:
        'banner,accounts,budgets,goals,income_expenses,net_worth,overdue_upcoming,loans,long_term_loans,spending_graph,pie_chart,heat_map,transactions',

    transactionReminderEnabled: false,
    transactionReminderTimeMinutes: 1200,
    upcomingTransactionsEnabled: false,
    requireBiometricOnLaunch: false,

    languageCode: 'en',

    autoProcessScheduledOnAppOpen: false,
    autoProcessRecurringOnAppOpen: false,

    swipeBetweenTabsEnabled: false,
  );

  static const Object _unset = Object();

  AppSettings copyWith({
    String? primaryCurrencyCode,
    FirstDayOfWeek? firstDayOfWeek,
    AppDateFormat? dateFormat,
    bool? useGrouping,
    DecimalSeparator? decimalSeparator,
    AppThemeMode? themeMode,
    AppAccentColor? accentColor,
    bool? useMaterialYouColors,
    bool? showExpenseInRed,
    bool? onboardingCompleted,
    Object? authUserId = _unset,
    Object? authUsername = _unset,
    Object? authDisplayName = _unset,
    Object? authBirthday = _unset,
    bool? authIsDemo,
    bool? demoDataSeeded,
    String? homeFeatureCardsDismissedCsv,
    DateTime? lastBirthdayCelebratedAt,

    String? homeSectionOrderCsv,

    bool? homeShowUsername,
    bool? homeShowBanner,
    bool? homeShowAccounts,
    bool? homeShowBudgets,
    bool? homeShowGoals,
    bool? homeShowIncomeAndExpenses,
    bool? homeShowNetWorth,
    bool? homeShowOverdueAndUpcoming,
    bool? homeShowLoans,
    bool? homeShowLongTermLoans,
    bool? homeShowSpendingGraph,
    bool? homeShowPieChart,
    bool? homeShowHeatMap,
    bool? homeShowTransactionsList,

    bool? transactionReminderEnabled,
    int? transactionReminderTimeMinutes,
    bool? upcomingTransactionsEnabled,

    bool? requireBiometricOnLaunch,

    String? languageCode,

    bool? autoProcessScheduledOnAppOpen,
    bool? autoProcessRecurringOnAppOpen,

    bool? swipeBetweenTabsEnabled,
  }) {
    return AppSettings(
      primaryCurrencyCode: primaryCurrencyCode ?? this.primaryCurrencyCode,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      dateFormat: dateFormat ?? this.dateFormat,
      useGrouping: useGrouping ?? this.useGrouping,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
      useMaterialYouColors: useMaterialYouColors ?? this.useMaterialYouColors,
      showExpenseInRed: showExpenseInRed ?? this.showExpenseInRed,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      authUserId: authUserId == _unset
          ? this.authUserId
          : authUserId as String?,
      authUsername: authUsername == _unset
          ? this.authUsername
          : authUsername as String?,
      authDisplayName: authDisplayName == _unset
          ? this.authDisplayName
          : authDisplayName as String?,
      authBirthday: authBirthday == _unset
          ? this.authBirthday
          : authBirthday as DateTime?,
      authIsDemo: authIsDemo ?? this.authIsDemo,
      demoDataSeeded: demoDataSeeded ?? this.demoDataSeeded,
      homeFeatureCardsDismissedCsv:
          homeFeatureCardsDismissedCsv ?? this.homeFeatureCardsDismissedCsv,
      lastBirthdayCelebratedAt:
          lastBirthdayCelebratedAt ?? this.lastBirthdayCelebratedAt,

      homeSectionOrderCsv: homeSectionOrderCsv ?? this.homeSectionOrderCsv,

      homeShowUsername: homeShowUsername ?? this.homeShowUsername,
      homeShowBanner: homeShowBanner ?? this.homeShowBanner,
      homeShowAccounts: homeShowAccounts ?? this.homeShowAccounts,
      homeShowBudgets: homeShowBudgets ?? this.homeShowBudgets,
      homeShowGoals: homeShowGoals ?? this.homeShowGoals,
      homeShowIncomeAndExpenses:
          homeShowIncomeAndExpenses ?? this.homeShowIncomeAndExpenses,
      homeShowNetWorth: homeShowNetWorth ?? this.homeShowNetWorth,
      homeShowOverdueAndUpcoming:
          homeShowOverdueAndUpcoming ?? this.homeShowOverdueAndUpcoming,
      homeShowLoans: homeShowLoans ?? this.homeShowLoans,
      homeShowLongTermLoans:
          homeShowLongTermLoans ?? this.homeShowLongTermLoans,
      homeShowSpendingGraph:
          homeShowSpendingGraph ?? this.homeShowSpendingGraph,
      homeShowPieChart: homeShowPieChart ?? this.homeShowPieChart,
      homeShowHeatMap: homeShowHeatMap ?? this.homeShowHeatMap,
      homeShowTransactionsList:
          homeShowTransactionsList ?? this.homeShowTransactionsList,

      transactionReminderEnabled:
          transactionReminderEnabled ?? this.transactionReminderEnabled,
      transactionReminderTimeMinutes:
          transactionReminderTimeMinutes ?? this.transactionReminderTimeMinutes,
      upcomingTransactionsEnabled:
          upcomingTransactionsEnabled ?? this.upcomingTransactionsEnabled,

      requireBiometricOnLaunch:
          requireBiometricOnLaunch ?? this.requireBiometricOnLaunch,

      languageCode: languageCode ?? this.languageCode,

      autoProcessScheduledOnAppOpen:
          autoProcessScheduledOnAppOpen ?? this.autoProcessScheduledOnAppOpen,
      autoProcessRecurringOnAppOpen:
          autoProcessRecurringOnAppOpen ?? this.autoProcessRecurringOnAppOpen,

      swipeBetweenTabsEnabled:
          swipeBetweenTabsEnabled ?? this.swipeBetweenTabsEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppSettings &&
        other.primaryCurrencyCode == primaryCurrencyCode &&
        other.firstDayOfWeek == firstDayOfWeek &&
        other.dateFormat == dateFormat &&
        other.useGrouping == useGrouping &&
        other.decimalSeparator == decimalSeparator &&
        other.themeMode == themeMode &&
        other.accentColor == accentColor &&
        other.useMaterialYouColors == useMaterialYouColors &&
        other.showExpenseInRed == showExpenseInRed &&
        other.onboardingCompleted == onboardingCompleted &&
        other.authUserId == authUserId &&
        other.authUsername == authUsername &&
        other.authDisplayName == authDisplayName &&
        other.authBirthday == authBirthday &&
        other.authIsDemo == authIsDemo &&
        other.demoDataSeeded == demoDataSeeded &&
        other.homeFeatureCardsDismissedCsv == homeFeatureCardsDismissedCsv &&
        other.lastBirthdayCelebratedAt == lastBirthdayCelebratedAt &&
        other.homeSectionOrderCsv == homeSectionOrderCsv &&
        other.homeShowUsername == homeShowUsername &&
        other.homeShowBanner == homeShowBanner &&
        other.homeShowAccounts == homeShowAccounts &&
        other.homeShowBudgets == homeShowBudgets &&
        other.homeShowGoals == homeShowGoals &&
        other.homeShowIncomeAndExpenses == homeShowIncomeAndExpenses &&
        other.homeShowNetWorth == homeShowNetWorth &&
        other.homeShowOverdueAndUpcoming == homeShowOverdueAndUpcoming &&
        other.homeShowLoans == homeShowLoans &&
        other.homeShowLongTermLoans == homeShowLongTermLoans &&
        other.homeShowSpendingGraph == homeShowSpendingGraph &&
        other.homeShowPieChart == homeShowPieChart &&
        other.homeShowHeatMap == homeShowHeatMap &&
        other.homeShowTransactionsList == homeShowTransactionsList &&
        other.transactionReminderEnabled == transactionReminderEnabled &&
        other.transactionReminderTimeMinutes ==
            transactionReminderTimeMinutes &&
        other.upcomingTransactionsEnabled == upcomingTransactionsEnabled &&
        other.requireBiometricOnLaunch == requireBiometricOnLaunch &&
        other.languageCode == languageCode &&
        other.autoProcessScheduledOnAppOpen == autoProcessScheduledOnAppOpen &&
        other.autoProcessRecurringOnAppOpen == autoProcessRecurringOnAppOpen &&
        other.swipeBetweenTabsEnabled == swipeBetweenTabsEnabled;
  }

  @override
  int get hashCode => Object.hashAll([
    primaryCurrencyCode,
    firstDayOfWeek,
    dateFormat,
    useGrouping,
    decimalSeparator,
    themeMode,
    accentColor,
    useMaterialYouColors,
    showExpenseInRed,
    onboardingCompleted,
    authUserId,
    authUsername,
    authDisplayName,
    authBirthday,
    authIsDemo,
    demoDataSeeded,
    homeFeatureCardsDismissedCsv,
    lastBirthdayCelebratedAt,
    homeSectionOrderCsv,
    homeShowUsername,
    homeShowBanner,
    homeShowAccounts,
    homeShowBudgets,
    homeShowGoals,
    homeShowIncomeAndExpenses,
    homeShowNetWorth,
    homeShowOverdueAndUpcoming,
    homeShowLoans,
    homeShowLongTermLoans,
    homeShowSpendingGraph,
    homeShowPieChart,
    homeShowHeatMap,
    homeShowTransactionsList,
    transactionReminderEnabled,
    transactionReminderTimeMinutes,
    upcomingTransactionsEnabled,
    requireBiometricOnLaunch,
    languageCode,
    autoProcessScheduledOnAppOpen,
    autoProcessRecurringOnAppOpen,
    swipeBetweenTabsEnabled,
  ]);
}
