abstract final class Routes {
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String aiChat = '/ai-chat';

  // Add flows (UI-only).
  static const String addPhoto = '/add/photo';
  static const String addBankStatement = '/add/bank-statement';
  static const String underDevelopment = '/under-development';

  // Home detail pages.
  static const String homeSpendingGraph = '/home/spending-graph';
  static const String homePieChart = '/home/pie-chart';
  static const String homeHeatMap = '/home/heat-map';
  static const String transactions = '/transactions';
  static const String transactionsAdd = '/transactions/add';
  static const String transactionsEdit = '/transactions/:transactionId/edit';
  static const String budgets = '/budgets';
  static const String budgetsAdd = '/budgets/add';
  static const String budgetsDetail = '/budgets/:budgetId';
  static const String more = '/more';

  // Phase 9: More pages.
  static const String calendar = '/more/calendar';
  static const String calendarDay = '/calendar/day';
  static const String subscriptions = '/more/subscriptions';
  static const String scheduled = '/more/scheduled';

  // PHASE 2: Add method selector (opened from the center + button)
  static const String addMethodSelector = '/add';

  static String transactionEdit(String transactionId) =>
      '/transactions/$transactionId/edit';

  static String budgetDetail(String budgetId) => '/budgets/$budgetId';

  static const String accounts = '/accounts';
  static const String accountsAdd = '/accounts/add';
  static const String accountsEdit = '/accounts/:accountId/edit';

  static String accountEdit(String accountId) => '/accounts/$accountId/edit';

  static const String categories = '/categories';
  static const String categoriesAdd = '/categories/add';
  static const String categoriesEdit = '/categories/:categoryId/edit';

  static String categoryEdit(String categoryId) =>
      '/categories/$categoryId/edit';

  static const String goals = '/goals';
  static const String goalsAdd = '/goals/add';
  static const String goalsEdit = '/goals/:goalId/edit';
  static const String loans = '/loans';
  static const String loansAdd = '/loans/add';
  static const String loansEdit = '/loans/:loanId/edit';
  static const String analytics = '/analytics';
  static const String settings = '/settings';
  static const String exportData = '/export';

  // Phase 7: Settings control center.
  static const String editHomepage = '/settings/homepage';
  static const String notifications = '/settings/notifications';
  static const String security = '/settings/security';
  static const String language = '/settings/language';
  static const String backups = '/settings/backups';

  // Phase 7: Tools.
  static const String billSplitter = '/tools/bill-splitter';

  // Phase 6: Local-only auth + user hub.
  static const String login = '/login';
  static const String signup = '/signup';
  static const String userHub = '/user';
  static const String userData = '/user/data';
  static const String userAccount = '/user/account';

  static String goalEdit(String goalId) => '/goals/$goalId/edit';

  static String loanEdit(String loanId) => '/loans/$loanId/edit';
}
