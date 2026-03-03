import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../animations/motion.dart';
import '../../features/analytics/analytics_page.dart';
import '../../features/accounts/accounts_list_page.dart';
import '../../features/accounts/add_account_page.dart';
import '../../features/accounts/edit_account_page.dart';
import '../../features/budgets/add_budget_page.dart';
import '../../features/budgets/budget_detail_page.dart';
import '../../features/budgets/budgets_page.dart';
import '../../features/categories/add_category_page.dart';
import '../../features/categories/categories_list_page.dart';
import '../../features/categories/edit_category_page.dart';
import '../../features/export/export_data_page.dart';
import '../../features/goals/add_goal_page.dart';
import '../../features/goals/edit_goal_page.dart';
import '../../features/goals/goals_page.dart';
import '../../features/home/home_page.dart';
import '../../features/home/pages/heatmap_detail_page.dart';
import '../../features/home/pages/pie_chart_detail_page.dart';
import '../../features/home/pages/spending_graph_detail_page.dart';
import '../../features/add/add_method_selector_page.dart';
import '../../features/add/pages/add_via_photo_page.dart';
import '../../features/add/pages/import_bank_statement_page.dart';
import '../../features/add/pages/under_development_page.dart';
import '../../features/ai_chat/ai_chat_page.dart';
import '../../features/loans/add_loan_page.dart';
import '../../features/loans/edit_loan_page.dart';
import '../../features/loans/loans_page.dart';
import '../../features/more/calendar_page.dart';
import '../../features/more/calendar_day_transactions_page.dart';
import '../../features/more/more_hub_page.dart';
import '../../features/more/scheduled_overview_page.dart';
import '../../features/more/subscriptions_page.dart';
import '../../features/onboarding/onboarding_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/settings/edit_homepage_page.dart';
import '../../features/settings/notifications_settings_page.dart';
import '../../features/settings/security_settings_page.dart';
import '../../features/settings/language_settings_page.dart';
import '../../features/settings/backups_page.dart';
import '../../features/tools/bill_splitter_page.dart';
import '../../features/transactions/add_transaction_page.dart';
import '../../features/transactions/edit_transaction_page.dart';
import '../../features/transactions/transactions_page.dart';
import '../../features/auth/login_page.dart';
import '../../features/auth/signup_page.dart';
import '../../features/user_hub/user_account_page.dart';
import '../../features/user_hub/user_data_page.dart';
import '../../features/user_hub/user_hub_page.dart';
import '../theme/app_spacing.dart';
import '../widgets/empty_state.dart';
import '../widgets/keyboard_back_dismiss_scope.dart';
import '../widgets/non_shell_system_nav_padding.dart';
import '../widgets/pressable_scale.dart';
import '../../features/settings/providers/settings_providers.dart';
import 'routes.dart';

final class AppRouter {
  const AppRouter({this.isOnboardingCompleted});

  /// Returns true when onboarding has been completed or skipped.
  ///
  /// Injected to keep router isolated from storage and business logic.
  final Future<bool> Function()? isOnboardingCompleted;

  GoRouter createRouter() {
    return GoRouter(
      initialLocation: Routes.home,
      redirect: (BuildContext context, GoRouterState state) async {
        final checker = isOnboardingCompleted;
        if (checker == null) return null;

        final path = state.uri.path;
        final isOnboarding = path == Routes.onboarding;
        if (isOnboarding) return null;

        final completed = await checker();
        if (!completed) return Routes.onboarding;

        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: Routes.onboarding,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const OnboardingPage()),
        ),
        GoRoute(
          path: Routes.login,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const LoginPage()),
        ),
        GoRoute(
          path: Routes.signup,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const SignupPage()),
        ),
        GoRoute(
          path: Routes.userHub,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const UserHubPage()),
        ),
        GoRoute(
          path: Routes.userData,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const UserDataPage()),
        ),
        GoRoute(
          path: Routes.userAccount,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const UserAccountPage()),
        ),
        StatefulShellRoute(
          pageBuilder:
              (
                BuildContext context,
                GoRouterState state,
                StatefulNavigationShell shell,
              ) {
                return _fadeSlidePage(
                  context,
                  state,
                  _AppShell(shell: shell),
                  applyNonShellSystemNavPadding: false,
                );
              },
          navigatorContainerBuilder:
              (
                BuildContext context,
                StatefulNavigationShell shell,
                List<Widget> children,
              ) {
                return _SwipeableTabContainer(shell: shell, children: children);
              },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: Routes.home,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: HomePage()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: Routes.transactions,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: TransactionsPage()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: Routes.analytics,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: AnalyticsPage()),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: Routes.more,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: MoreHubPage()),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: Routes.budgets,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const BudgetsPage()),
        ),
        GoRoute(
          path: Routes.addMethodSelector,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const AddMethodSelectorPage()),
        ),
        GoRoute(
          path: Routes.addPhoto,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const AddViaPhotoPage()),
        ),
        GoRoute(
          path: Routes.addBankStatement,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const ImportBankStatementPage()),
        ),
        GoRoute(
          path: Routes.underDevelopment,
          pageBuilder: (context, state) {
            final extra = state.extra;
            final args = extra is UnderDevelopmentArgs
                ? extra
                : const UnderDevelopmentArgs(
                    message: 'This feature is currently under development.',
                  );
            return _fadeSlidePage(
              context,
              state,
              UnderDevelopmentPage(args: args),
            );
          },
        ),
        GoRoute(
          path: Routes.aiChat,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const AiChatPage()),
        ),
        GoRoute(
          path: Routes.homeSpendingGraph,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const SpendingGraphDetailPage()),
        ),
        GoRoute(
          path: Routes.homePieChart,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const PieChartDetailPage()),
        ),
        GoRoute(
          path: Routes.homeHeatMap,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const HeatmapDetailPage()),
        ),
        GoRoute(
          path: Routes.calendar,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const CalendarPage()),
        ),
        GoRoute(
          path: Routes.calendarDay,
          pageBuilder: (context, state) {
            final dateStr = state.uri.queryParameters['date'];
            if (dateStr == null || dateStr.trim().isEmpty) {
              return _fadeSlidePage(
                context,
                state,
                const Scaffold(
                  body: Padding(
                    padding: AppSpacing.pagePadding,
                    child: EmptyState(
                      title: 'Can\'t open day view',
                      body: 'Missing date parameter.',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              );
            }

            final parsed = DateTime.tryParse(dateStr);
            if (parsed == null) {
              return _fadeSlidePage(
                context,
                state,
                Scaffold(
                  body: Padding(
                    padding: AppSpacing.pagePadding,
                    child: EmptyState(
                      title: 'Can\'t open day view',
                      body: 'Invalid date: $dateStr',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              );
            }

            return _fadeSlidePage(
              context,
              state,
              CalendarDayTransactionsPage(date: parsed),
            );
          },
        ),
        GoRoute(
          path: Routes.subscriptions,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const SubscriptionsPage()),
        ),
        GoRoute(
          path: Routes.scheduled,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const ScheduledOverviewPage()),
        ),
        GoRoute(
          path: Routes.settings,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const SettingsPage()),
        ),
        GoRoute(
          path: Routes.editHomepage,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const EditHomepagePage()),
        ),
        GoRoute(
          path: Routes.notifications,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const NotificationsSettingsPage()),
        ),
        GoRoute(
          path: Routes.security,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const SecuritySettingsPage()),
        ),
        GoRoute(
          path: Routes.language,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const LanguageSettingsPage()),
        ),
        GoRoute(
          path: Routes.backups,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const BackupsPage()),
        ),
        GoRoute(
          path: Routes.exportData,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const ExportDataPage()),
        ),
        GoRoute(
          path: Routes.billSplitter,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const BillSplitterPage()),
        ),
        GoRoute(
          path: Routes.accounts,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const AccountsListPage()),
        ),
        GoRoute(
          path: Routes.accountsAdd,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const AddAccountPage()),
        ),
        GoRoute(
          path: Routes.accountsEdit,
          pageBuilder: (context, state) {
            final accountId = state.pathParameters['accountId'];
            if (accountId == null || accountId.isEmpty) {
              return _fadeSlidePage(
                context,
                state,
                const Scaffold(
                  body: Padding(
                    padding: AppSpacing.pagePadding,
                    child: EmptyState(
                      title: 'Can\'t open account',
                      body: 'Missing accountId.',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              );
            }
            return _fadeSlidePage(
              context,
              state,
              EditAccountPage(accountId: accountId),
            );
          },
        ),
        GoRoute(
          path: Routes.categories,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const CategoriesListPage()),
        ),
        GoRoute(
          path: Routes.categoriesAdd,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const AddCategoryPage()),
        ),
        GoRoute(
          path: Routes.categoriesEdit,
          pageBuilder: (context, state) {
            final categoryId = state.pathParameters['categoryId'];
            if (categoryId == null || categoryId.isEmpty) {
              return _fadeSlidePage(
                context,
                state,
                const Scaffold(
                  body: Padding(
                    padding: AppSpacing.pagePadding,
                    child: EmptyState(
                      title: 'Can\'t open category',
                      body: 'Missing categoryId.',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              );
            }
            return _fadeSlidePage(
              context,
              state,
              EditCategoryPage(categoryId: categoryId),
            );
          },
        ),
        GoRoute(
          path: Routes.goals,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const GoalsPage()),
        ),
        GoRoute(
          path: Routes.goalsAdd,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const AddGoalPage()),
        ),
        GoRoute(
          path: Routes.goalsEdit,
          pageBuilder: (context, state) {
            final goalId = state.pathParameters['goalId'];
            if (goalId == null || goalId.isEmpty) {
              return _fadeSlidePage(
                context,
                state,
                const Scaffold(
                  body: Padding(
                    padding: AppSpacing.pagePadding,
                    child: EmptyState(
                      title: 'Can\'t open goal',
                      body: 'Missing goalId.',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              );
            }
            return _fadeSlidePage(context, state, EditGoalPage(goalId: goalId));
          },
        ),
        GoRoute(
          path: Routes.loans,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const LoansPage()),
        ),
        GoRoute(
          path: Routes.loansAdd,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const AddLoanPage()),
        ),
        GoRoute(
          path: Routes.loansEdit,
          pageBuilder: (context, state) {
            final loanId = state.pathParameters['loanId'];
            if (loanId == null || loanId.isEmpty) {
              return _fadeSlidePage(
                context,
                state,
                const Scaffold(
                  body: Padding(
                    padding: AppSpacing.pagePadding,
                    child: EmptyState(
                      title: 'Can\'t open loan',
                      body: 'Missing loanId.',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              );
            }
            return _fadeSlidePage(context, state, EditLoanPage(loanId: loanId));
          },
        ),
        GoRoute(
          path: Routes.transactionsAdd,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const AddTransactionPage()),
        ),
        GoRoute(
          path: Routes.transactionsEdit,
          pageBuilder: (context, state) {
            final transactionId = state.pathParameters['transactionId'];
            if (transactionId == null || transactionId.isEmpty) {
              return _fadeSlidePage(
                context,
                state,
                const Scaffold(
                  body: Padding(
                    padding: AppSpacing.pagePadding,
                    child: EmptyState(
                      title: 'Can\'t open transaction',
                      body: 'Missing transactionId.',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              );
            }
            return _fadeSlidePage(
              context,
              state,
              EditTransactionPage(transactionId: transactionId),
            );
          },
        ),
        GoRoute(
          path: Routes.budgetsAdd,
          pageBuilder: (context, state) =>
              _fadeSlidePage(context, state, const AddBudgetPage()),
        ),
        GoRoute(
          path: Routes.budgetsDetail,
          pageBuilder: (context, state) {
            final budgetId = state.pathParameters['budgetId'];
            if (budgetId == null || budgetId.isEmpty) {
              return _fadeSlidePage(
                context,
                state,
                const Scaffold(
                  body: Padding(
                    padding: AppSpacing.pagePadding,
                    child: EmptyState(
                      title: 'Can\'t open budget',
                      body: 'Missing budgetId.',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              );
            }
            return _fadeSlidePage(
              context,
              state,
              BudgetDetailPage(budgetId: budgetId),
            );
          },
        ),
      ],
    );
  }
}

CustomTransitionPage<void> _fadeSlidePage(
  BuildContext context,
  GoRouterState state,
  Widget child, {
  bool applyNonShellSystemNavPadding = true,
}) {
  final d = Motion.duration(context, MotionDurations.fast);

  final wrappedChild = applyNonShellSystemNavPadding
      ? NonShellSystemNavPadding(child: child)
      : child;

  final finalChild = KeyboardBackDismissScope(child: wrappedChild);

  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: finalChild,
    transitionDuration: d,
    reverseTransitionDuration: d,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return Motion.fadeSlide(
        context: context,
        animation: animation,
        begin: const Offset(0.06, 0),
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOutCubic,
        child: child,
      );
    },
  );
}

final class _AppShell extends StatefulWidget {
  const _AppShell({required this.shell});

  final StatefulNavigationShell shell;

  @override
  State<_AppShell> createState() => _AppShellState();
}

final class _AppShellState extends State<_AppShell> {
  DateTime? _lastBackPressedAt;
  Timer? _exitArmResetTimer;

  void _onTapBranch(int index) {
    widget.shell.goBranch(index);
    setState(() {});
  }

  bool _isExitArmed() {
    final last = _lastBackPressedAt;
    if (last == null) return false;
    return DateTime.now().difference(last) <= const Duration(seconds: 2);
  }

  void _armExit() {
    _exitArmResetTimer?.cancel();
    _lastBackPressedAt = DateTime.now();
    _exitArmResetTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _lastBackPressedAt = null;
      });
    });
  }

  @override
  void dispose() {
    _exitArmResetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final currentIndex = widget.shell.currentIndex;

    final routerCanPop = GoRouter.of(context).canPop();
    final exitArmed = _isExitArmed();

    return PopScope(
      // Layer 2 + 3:
      // - If the router can pop (non-shell pages / branch stacks), allow it.
      // - If we're at the shell root, require a second back press to exit.
      canPop: routerCanPop || exitArmed,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // If something can pop, don't interfere.
        if (routerCanPop) return;

        // Shell root: first back arms exit, second back is allowed via canPop.
        if (exitArmed) return;

        setState(_armExit);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Press again to exit app')),
        );
      },
      child: Scaffold(
        body: widget.shell,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: PressableScaleDecorator(
          pressedScale: 0.97,
          child: FloatingActionButton(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            onPressed: () =>
                GoRouter.of(context).push(Routes.addMethodSelector),
            child: const Icon(Icons.add),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: _onTapBranch,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz_outlined),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_outlined),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'More'),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
final class _IndexedStackTabContainer extends StatelessWidget {
  const _IndexedStackTabContainer({
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // Classic, gesture-free tab container.
    return IndexedStack(index: currentIndex, children: children);
  }
}

final class _SwipeableTabContainer extends ConsumerStatefulWidget {
  const _SwipeableTabContainer({required this.shell, required this.children});

  final StatefulNavigationShell shell;
  final List<Widget> children;

  @override
  ConsumerState<_SwipeableTabContainer> createState() =>
      _SwipeableTabContainerState();
}

final class _SwipeableTabContainerState
    extends ConsumerState<_SwipeableTabContainer> {
  late final PageController _controller;
  int _lastKnownIndex = 0;

  @override
  void initState() {
    super.initState();
    _lastKnownIndex = widget.shell.currentIndex;
    _controller = PageController(initialPage: _lastKnownIndex);
  }

  @override
  void didUpdateWidget(covariant _SwipeableTabContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final target = widget.shell.currentIndex;
    if (target == _lastKnownIndex) return;
    _lastKnownIndex = target;

    if (!_controller.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_controller.hasClients) return;
        _controller.jumpToPage(_lastKnownIndex);
      });
      return;
    }

    _controller.jumpToPage(target);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);
    final physics = settings.swipeBetweenTabsEnabled
        ? const PageScrollPhysics()
        : const NeverScrollableScrollPhysics();

    return PageView(
      controller: _controller,
      physics: physics,
      onPageChanged: (index) {
        _lastKnownIndex = index;
        widget.shell.goBranch(index);
      },
      children: widget.children,
    );
  }
}

final class PlaceholderFeaturePage extends StatelessWidget {
  const PlaceholderFeaturePage({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(padding: AppSpacing.pagePadding, child: Text(subtitle)),
    );
  }
}
