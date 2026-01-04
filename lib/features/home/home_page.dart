import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/animations/motion.dart';
import '../../core/formatting/date_format.dart';
import '../../core/formatting/money_format.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/semantic_amount_text.dart';
import '../../data/models/account.dart';
import '../../data/models/enums.dart';
import '../../data/models/money.dart';
import '../../data/models/transaction.dart';
import '../auth/providers/auth_providers.dart';
import '../settings/providers/settings_providers.dart';
import '../accounts/providers/accounts_providers.dart';
import 'providers/home_providers.dart';
import 'utils/greeting_utils.dart';
import 'widgets/home_mini_visuals.dart';

final class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

final class _HomePageState extends ConsumerState<HomePage> {
  DateTime? _lastBirthdayDialogForDay;

  static const List<String> _sectionIds = <String>[
    'banner',
    'accounts',
    'budgets',
    'goals',
    'income_expenses',
    'net_worth',
    'overdue_upcoming',
    'loans',
    'long_term_loans',
    'spending_graph',
    'pie_chart',
    'heat_map',
    'transactions',
  ];

  static List<String> _parseOrder(String csv) {
    final fromCsv = csv
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    final seen = <String>{};
    final ordered = <String>[];
    for (final id in fromCsv) {
      if (!_sectionIds.contains(id)) continue;
      if (seen.add(id)) ordered.add(id);
    }
    for (final id in _sectionIds) {
      if (seen.add(id)) ordered.add(id);
    }
    return ordered;
  }

  void _openChat(BuildContext context) => context.push(Routes.aiChat);

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    final settings = ref.watch(appSettingsProvider);

    final showUsername = settings.homeShowUsername;
    final showBanner = settings.homeShowBanner;
    final showAccounts = settings.homeShowAccounts;
    final showBudgets = settings.homeShowBudgets;
    final showGoals = settings.homeShowGoals;
    final showIncomeAndExpenses = settings.homeShowIncomeAndExpenses;
    final showNetWorth = settings.homeShowNetWorth;
    final showOverdueAndUpcoming = settings.homeShowOverdueAndUpcoming;
    final showLoans = settings.homeShowLoans;
    final showLongTermLoans = settings.homeShowLongTermLoans;
    final showSpendingGraph = settings.homeShowSpendingGraph;
    final showPieChart = settings.homeShowPieChart;
    final showHeatMap = settings.homeShowHeatMap;
    final showTransactions = settings.homeShowTransactionsList;

    final accounts = showAccounts
        ? ref.watch(homeAccountsProvider)
        : const AsyncData<List<Account>>(<Account>[]);
    final recent = showTransactions
        ? ref.watch(homeRecentTransactionsProvider)
        : const AsyncData<List<FinanceTransaction>>(<FinanceTransaction>[]);

    _maybeShowBirthdayDialog(
      context,
      authDisplayName: auth.displayName,
      birthday: auth.birthday,
      lastCelebrated: settings.lastBirthdayCelebratedAt,
    );

    final List<_HomeCard> cards;
    if (showBanner) {
      final dismissed = settings.homeFeatureCardsDismissedCsv
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet();

      cards = _homeCards
          .where((c) => !dismissed.contains(c.id))
          .toList(growable: false);
    } else {
      cards = const <_HomeCard>[];
    }

    final slivers = <Widget>[
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s16,
          AppSpacing.s16,
          AppSpacing.s16,
          AppSpacing.s8,
        ),
        sliver: SliverToBoxAdapter(
          child: _Header(
            dateText: formatHomeDate(DateTime.now()),
            authDisplayName: showUsername ? auth.displayName : null,
            isLoggedIn: auth.isLoggedIn,
            showBirthdayBadge: _shouldShowBirthdayBadge(
              birthday: auth.birthday,
              lastCelebrated: settings.lastBirthdayCelebratedAt,
            ),
            onTapChat: () => _openChat(context),
          ),
        ),
      ),
    ];

    final order = _parseOrder(settings.homeSectionOrderCsv);
    for (final id in order) {
      switch (id) {
        case 'banner':
          if (showBanner && cards.isNotEmpty) {
            slivers.add(
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s16,
                  AppSpacing.s8,
                  AppSpacing.s16,
                  AppSpacing.s16,
                ),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 132,
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.92),
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s4,
                          ),
                          child: _PreviewCard(
                            card: card,
                            onClose: () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .dismissHomeCard(card.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Dismissed: ${card.title}'),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }

        case 'accounts':
          if (showAccounts) {
            slivers.add(
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s16,
                  AppSpacing.s8,
                  AppSpacing.s16,
                  AppSpacing.s8,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Accounts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            );
            slivers.add(
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                sliver: _AccountsSection(accounts: accounts),
              ),
            );
          }

        case 'budgets':
          if (showBudgets) {
            slivers.add(
              _HomeLinkSection(
                title: 'Budgets',
                subtitle: 'View and manage budgets',
                icon: Icons.account_balance_wallet_outlined,
                onTap: () => context.push(Routes.budgets),
              ),
            );
          }

        case 'goals':
          if (showGoals) {
            slivers.add(
              _HomeLinkSection(
                title: 'Goals',
                subtitle: 'Track savings goals',
                icon: Icons.flag_outlined,
                onTap: () => context.push(Routes.goals),
              ),
            );
          }

        case 'income_expenses':
          if (showIncomeAndExpenses) {
            slivers.add(
              _HomeLinkSection(
                title: 'Income & Expenses',
                subtitle: 'See your monthly totals',
                icon: Icons.trending_up_outlined,
                onTap: () => context.push(Routes.analytics),
              ),
            );
          }

        case 'net_worth':
          if (showNetWorth) {
            slivers.add(
              _HomeLinkSection(
                title: 'Net Worth',
                subtitle: 'View net worth summary',
                icon: Icons.insights_outlined,
                onTap: () => context.push(Routes.analytics),
              ),
            );
          }

        case 'overdue_upcoming':
          if (showOverdueAndUpcoming) {
            slivers.add(
              _HomeLinkSection(
                title: 'Overdue & Upcoming',
                subtitle: 'Review what is due soon',
                icon: Icons.event_outlined,
                onTap: () => context.push(Routes.transactions),
              ),
            );
          }

        case 'loans':
          if (showLoans) {
            slivers.add(
              _HomeLinkSection(
                title: 'Loans',
                subtitle: 'View and manage loans',
                icon: Icons.payments_outlined,
                onTap: () => context.push(Routes.loans),
              ),
            );
          }

        case 'long_term_loans':
          if (showLongTermLoans) {
            slivers.add(
              _HomeLinkSection(
                title: 'Long-term loans',
                subtitle: 'View long-term loan tracking',
                icon: Icons.timelapse_outlined,
                onTap: () => context.push(Routes.loans),
              ),
            );
          }

        case 'spending_graph':
          if (showSpendingGraph) {
            slivers.add(
              _HomeVisualSection(
                title: 'Spending graph',
                subtitle: 'See spending trends',
                onTap: () => context.push(Routes.homeSpendingGraph),
                preview: const HomeMiniSpendingGraph(),
              ),
            );
          }

        case 'pie_chart':
          if (showPieChart) {
            slivers.add(
              _HomeVisualSection(
                title: 'Pie chart',
                subtitle: 'Spending breakdown by category',
                onTap: () => context.push(Routes.homePieChart),
                preview: const HomeMiniPieChart(),
              ),
            );
          }

        case 'heat_map':
          if (showHeatMap) {
            slivers.add(
              _HomeVisualSection(
                title: 'Heat map',
                subtitle: 'Activity over time',
                onTap: () => context.push(Routes.homeHeatMap),
                preview: const HomeMiniHeatMap(),
              ),
            );
          }

        case 'transactions':
          if (showTransactions) {
            slivers.add(
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s16,
                  AppSpacing.s16,
                  AppSpacing.s16,
                  AppSpacing.s8,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Recent transactions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            );
            slivers.add(
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                sliver: _RecentTransactionsSection(recent: recent),
              ),
            );
          }

        default:
          break;
      }
    }

    slivers.add(
      const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s24)),
    );

    return Scaffold(
      body: SafeArea(child: CustomScrollView(slivers: slivers)),
    );
  }

  bool _shouldShowBirthdayBadge({
    required DateTime? birthday,
    required DateTime? lastCelebrated,
  }) {
    if (birthday == null) return false;
    final now = DateTime.now();
    final isToday = birthday.month == now.month && birthday.day == now.day;
    if (!isToday) return false;

    final today = DateUtils.dateOnly(now);
    final last = lastCelebrated == null
        ? null
        : DateUtils.dateOnly(lastCelebrated);
    return last == null || last != today;
  }

  void _maybeShowBirthdayDialog(
    BuildContext context, {
    required String? authDisplayName,
    required DateTime? birthday,
    required DateTime? lastCelebrated,
  }) {
    if (!_shouldShowBirthdayBadge(
      birthday: birthday,
      lastCelebrated: lastCelebrated,
    )) {
      return;
    }

    final today = DateUtils.dateOnly(DateTime.now());
    if (_lastBirthdayDialogForDay == today) return;
    _lastBirthdayDialogForDay = today;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final name = (authDisplayName?.trim().isNotEmpty ?? false)
          ? authDisplayName!.trim()
          : 'there';
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: <Widget>[
              const Icon(Icons.celebration_outlined),
              const SizedBox(width: AppSpacing.s8),
              Expanded(child: Text('Happy Birthday, $name!')),
            ],
          ),
          content: const _SimpleConfettiBox(),
          actions: <Widget>[
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Thanks!'),
            ),
          ],
        ),
      );

      await ref
          .read(authControllerProvider.notifier)
          .markBirthdayCelebratedNow();
    });
  }
}

final class _HomeLinkSection extends StatelessWidget {
  const _HomeLinkSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s8,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.s8),
            Card(
              child: ListTile(
                leading: Icon(icon),
                title: Text(title),
                subtitle: Text(subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _HomeVisualSection extends StatelessWidget {
  const _HomeVisualSection({
    required this.title,
    required this.subtitle,
    required this.preview,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget preview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s8,
        AppSpacing.s16,
        AppSpacing.s8,
      ),
      sliver: SliverToBoxAdapter(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title, style: theme.textTheme.titleMedium),
                        const SizedBox(height: AppSpacing.s4),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  SizedBox(
                    width: 120,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: preview,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _Header extends StatefulWidget {
  const _Header({
    required this.dateText,
    required this.authDisplayName,
    required this.isLoggedIn,
    required this.showBirthdayBadge,
    required this.onTapChat,
  });

  final String dateText;
  final String? authDisplayName;
  final bool isLoggedIn;
  final bool showBirthdayBadge;
  final VoidCallback onTapChat;

  @override
  State<_Header> createState() => _HeaderState();
}

final class _HeaderState extends State<_Header> with WidgetsBindingObserver {
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() => _now = DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final name = (widget.authDisplayName?.trim().isNotEmpty ?? false)
        ? widget.authDisplayName!.trim()
        : null;

    final greeting = buildHomeGreeting(
      now: _now,
      username: widget.isLoggedIn ? name : null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () {
                  if (widget.isLoggedIn) {
                    context.push(Routes.userHub);
                  } else {
                    context.push(Routes.login);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AnimatedSwitcher(
                        duration: Motion.duration(
                          context,
                          MotionDurations.fast,
                        ),
                        switchInCurve: MotionCurves.entrance,
                        switchOutCurve: MotionCurves.standard,
                        transitionBuilder: (child, animation) {
                          return Motion.fadeSlide(
                            context: context,
                            animation: animation,
                            begin: const Offset(0, -0.02),
                            curve: MotionCurves.entrance,
                            child: child,
                          );
                        },
                        child: Text(
                          greeting,
                          key: ValueKey<String>(
                            'greeting_${widget.isLoggedIn ? 'in' : 'out'}_${name ?? ''}',
                          ),
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        widget.dateText,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            if (widget.isLoggedIn)
              Row(
                children: <Widget>[
                  IconButton(
                    tooltip: 'Finance assistant',
                    onPressed: widget.onTapChat,
                    icon: const Icon(Icons.smart_toy_outlined),
                  ),
                  IconButton(
                    tooltip: 'Notifications',
                    onPressed: () {
                      if (widget.showBirthdayBadge) {
                        // Birthday dialog is shown automatically; this is a fallback.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Birthday notification'),
                          ),
                        );
                        return;
                      }

                      context.push(Routes.notifications);
                    },
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        const Icon(Icons.notifications_none_outlined),
                        if (widget.showBirthdayBadge)
                          Positioned(
                            right: -1,
                            top: -1,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
            else
              FilledButton(
                onPressed: () => context.push(Routes.login),
                child: const Text('Log in'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s4),
      ],
    );
  }
}

@immutable
final class _HomeCard {
  const _HomeCard({
    required this.id,
    required this.title,
    required this.body,
    required this.cta,
    this.route,
  });

  final String id;
  final String title;
  final String body;
  final String cta;
  final String? route;
}

const List<_HomeCard> _homeCards = <_HomeCard>[
  _HomeCard(
    id: 'card_budget',
    title: 'Set your first budget',
    body: 'Create a budget to track spending targets.',
    cta: 'Create budget',
    route: Routes.budgetsAdd,
  ),
  _HomeCard(
    id: 'card_analytics',
    title: 'Explore analytics',
    body: 'See your spending breakdown for the month.',
    cta: 'Open analytics',
    route: Routes.analytics,
  ),
  _HomeCard(
    id: 'card_cloud',
    title: 'Cloud sync',
    body: 'Keep your data synced across devices. Under development.',
    cta: 'Learn more',
    route: Routes.userHub,
  ),
];

final class _PreviewCard extends StatefulWidget {
  const _PreviewCard({required this.card, required this.onClose});

  final _HomeCard card;
  final VoidCallback onClose;

  @override
  State<_PreviewCard> createState() => _PreviewCardState();
}

final class _PreviewCardState extends State<_PreviewCard> {
  bool _closing = false;

  Future<void> _dismiss() async {
    if (_closing) return;

    setState(() => _closing = true);

    final d = Motion.duration(context, MotionDurations.fast);
    if (d > Duration.zero) {
      await Future<void>.delayed(d);
    }
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final d = Motion.duration(context, MotionDurations.fast);

    return IgnorePointer(
      ignoring: _closing,
      child: AnimatedOpacity(
        opacity: _closing ? 0 : 1,
        duration: d,
        curve: MotionCurves.standard,
        child: AnimatedScale(
          scale: _closing ? 0.985 : 1,
          duration: d,
          curve: MotionCurves.emphasized,
          child: SizedBox(
            child: Material(
              color: cs.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: cs.outline.withValues(alpha: 0.45)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: InkWell(
                      onTap: widget.card.route == null
                          ? null
                          : () => context.push(widget.card.route!),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.s16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 28),
                              child: Text(
                                widget.card.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s4),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.card.body,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: cs.onSurface.withValues(
                                          alpha: 0.72,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.card.cta,
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(color: cs.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      tooltip: 'Dismiss',
                      onPressed: _dismiss,
                      icon: const Icon(Icons.close),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _SimpleConfettiBox extends StatelessWidget {
  const _SimpleConfettiBox();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: <Widget>[
          const Positioned.fill(child: _ConfettiPainterWidget()),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Wishing you a great year ahead!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

final class _ConfettiPainterWidget extends StatefulWidget {
  const _ConfettiPainterWidget();

  @override
  State<_ConfettiPainterWidget> createState() => _ConfettiPainterWidgetState();
}

final class _ConfettiPainterWidgetState extends State<_ConfettiPainterWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _ConfettiPainter(
            t: _controller.value,
            colorScheme: Theme.of(context).colorScheme,
          ),
        );
      },
    );
  }
}

final class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({required this.t, required this.colorScheme});

  final double t;
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final colors = <Color>[
      colorScheme.primary,
      colorScheme.tertiary,
      colorScheme.secondary,
      colorScheme.error,
    ];

    for (var i = 0; i < 18; i++) {
      final fx = (i * 0.83 + t) % 1.0;
      final fy = ((i * 0.37 + (1 - t)) % 1.0);
      final x = fx * size.width;
      final y = fy * size.height;
      paint.color = colors[i % colors.length].withValues(alpha: 0.22);
      canvas.drawCircle(Offset(x, y), 6 + (i % 3) * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.colorScheme != colorScheme;
  }
}

final class _AccountsSection extends StatelessWidget {
  const _AccountsSection({required this.accounts});

  final AsyncValue<List<Account>> accounts;

  @override
  Widget build(BuildContext context) {
    return accounts.when(
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.s16),
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
      error: (error, _) => SliverToBoxAdapter(
        child: EmptyState(
          title: 'Couldn\'t load accounts',
          body: error.toString(),
          padding: EdgeInsets.zero,
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const SliverToBoxAdapter(
            child: EmptyState(
              title: 'No accounts yet',
              body: 'Create an account to start tracking balances.',
              padding: EdgeInsets.zero,
            ),
          );
        }

        return SliverList.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.s8),
          itemBuilder: (context, index) => _AccountCard(account: items[index]),
        );
      },
    );
  }
}

final class _AccountCard extends ConsumerWidget {
  const _AccountCard({required this.account});

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final balances = ref.watch(accountBalancesProvider);

    final Money? balance = balances.value?[account.id];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(account.name, style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    _accountTypeLabel(account.type),
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              balance == null ? '—' : formatMoney(balance),
              style: textTheme.titleLarge,
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}

final class _RecentTransactionsSection extends StatelessWidget {
  const _RecentTransactionsSection({required this.recent});

  final AsyncValue<List<FinanceTransaction>> recent;

  @override
  Widget build(BuildContext context) {
    return recent.when(
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.s16),
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
      error: (error, _) => SliverToBoxAdapter(
        child: EmptyState(
          title: 'Couldn\'t load transactions',
          body: error.toString(),
          padding: EdgeInsets.zero,
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const SliverToBoxAdapter(
            child: EmptyState(
              title: 'No transactions yet',
              body: 'Transactions will appear here once you add them.',
              padding: EdgeInsets.zero,
            ),
          );
        }

        return SliverList.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) => _TransactionRow(tx: items[index]),
        );
      },
    );
  }
}

final class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx});

  final FinanceTransaction tx;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final title = (tx.title?.trim().isNotEmpty ?? false)
        ? tx.title!.trim()
        : (tx.merchant?.trim().isNotEmpty ?? false)
        ? tx.merchant!.trim()
        : 'Transaction';

    final subtitle = formatHomeDate(tx.occurredAt);
    final cs = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: textTheme.titleMedium),
      subtitle: Text(
        subtitle,
        style: textTheme.bodySmall?.copyWith(
          color: cs.onSurface.withValues(alpha: 0.72),
        ),
      ),
      trailing: SemanticAmountText(
        type: tx.type,
        amount: tx.amount,
        includeCurrencyCode: true,
        textAlign: TextAlign.end,
        style: textTheme.titleLarge,
      ),
    );
  }
}

String _accountTypeLabel(AccountType type) {
  return switch (type) {
    AccountType.cash => 'Cash',
    AccountType.bank => 'Bank',
    AccountType.credit => 'Credit',
    AccountType.crypto => 'Crypto',
  };
}
