import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';

final class MoreHubPage extends StatelessWidget {
  const MoreHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_HubAction> actions = <_HubAction>[
      const _HubAction(
        label: 'User Hub',
        icon: Icons.person_outline,
        route: Routes.userHub,
      ),
      const _HubAction(
        label: 'Accounts',
        icon: Icons.account_balance_wallet_outlined,
        route: Routes.accounts,
      ),
      const _HubAction(
        label: 'Categories',
        icon: Icons.category_outlined,
        route: Routes.categories,
      ),
      const _HubAction(
        label: 'Goals',
        icon: Icons.flag_outlined,
        route: Routes.goals,
      ),
      const _HubAction(
        label: 'Loans',
        icon: Icons.request_quote_outlined,
        route: Routes.loans,
      ),
      const _HubAction(
        label: 'Budgets',
        icon: Icons.pie_chart_outline,
        route: Routes.budgets,
      ),
      const _HubAction(
        label: 'Analytics',
        icon: Icons.insights_outlined,
        route: Routes.analytics,
      ),
      const _HubAction(
        label: 'Calendar',
        icon: Icons.calendar_month_outlined,
        route: Routes.calendar,
      ),
      const _HubAction(
        label: 'Subscriptions',
        icon: Icons.autorenew,
        route: Routes.subscriptions,
      ),
      const _HubAction(
        label: 'Scheduled',
        icon: Icons.schedule_outlined,
        route: Routes.scheduled,
      ),
      const _HubAction(
        label: 'Settings',
        icon: Icons.settings_outlined,
        route: Routes.settings,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.s16,
            mainAxisSpacing: AppSpacing.s16,
            childAspectRatio: 1.25,
          ),
          itemCount: actions.length,
          itemBuilder: (BuildContext context, int index) {
            final _HubAction action = actions[index];
            return _ActionTile(
              label: action.label,
              icon: action.icon,
              onTap: () => context.push(action.route),
            );
          },
        ),
      ),
    );
  }
}

@immutable
final class _HubAction {
  const _HubAction({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

final class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

    return Material(
      color: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outline.withValues(alpha: 0.55)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, size: 22, color: cs.onSurface.withValues(alpha: 0.9)),
              const Spacer(),
              Text(label, style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.s4),
              Container(
                height: 3,
                width: 24,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
