import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import 'providers/settings_providers.dart';
import 'providers/settings_controller.dart';

final class EditHomepagePage extends ConsumerStatefulWidget {
  const EditHomepagePage({super.key});

  @override
  ConsumerState<EditHomepagePage> createState() => _EditHomepagePageState();
}

final class _EditHomepagePageState extends ConsumerState<EditHomepagePage> {
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

  List<String> _order = const <String>[];

  @override
  void initState() {
    super.initState();

    // Initialize quickly (may be defaults while the stream loads).
    _order = _parseOrder(ref.read(appSettingsProvider).homeSectionOrderCsv);

    // Only react to order changes, not the entire settings model.
    ref.listenManual(appSettingsProvider.select((s) => s.homeSectionOrderCsv), (
      prev,
      nextCsv,
    ) {
      final nextOrder = _parseOrder(nextCsv);
      if (!_listEquals(_order, nextOrder)) {
        setState(() => _order = nextOrder);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit homepage')),
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _UsernameToggleCard(),
            const SizedBox(height: AppSpacing.s16),
            Text(
              'Sections (drag to reorder)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s8),
            Expanded(
              child: ReorderableListView(
                buildDefaultDragHandles: false,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = _order.removeAt(oldIndex);
                    _order.insert(newIndex, item);
                  });
                  ref
                      .read(settingsControllerProvider.notifier)
                      .updateHomeSectionOrderCsv(_order.join(','));
                },
                children: <Widget>[
                  for (int i = 0; i < _order.length; i++)
                    _HomeSectionToggleTile(
                      key: ValueKey<String>('home_section_${_order[i]}'),
                      index: i,
                      id: _order[i],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static String _titleForId(String id) {
    return switch (id) {
      'banner' => 'Banner',
      'accounts' => 'Accounts',
      'budgets' => 'Budgets',
      'goals' => 'Goals',
      'income_expenses' => 'Income & Expenses',
      'net_worth' => 'Net Worth',
      'overdue_upcoming' => 'Overdue & Upcoming',
      'loans' => 'Loans',
      'long_term_loans' => 'Long-term loans',
      'spending_graph' => 'Spending Graph',
      'pie_chart' => 'Pie Chart',
      'heat_map' => 'Heat Map',
      'transactions' => 'Transactions List',
      _ => id,
    };
  }
}

final class _UsernameToggleCard extends ConsumerWidget {
  const _UsernameToggleCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(
      appSettingsProvider.select((s) => s.homeShowUsername),
    );

    return Card(
      child: SwitchListTile.adaptive(
        key: const ValueKey<String>('home_toggle_username'),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        title: const Text('Username'),
        value: value,
        onChanged: (v) {
          ref
              .read(settingsControllerProvider.notifier)
              .updateHomeShowUsername(v);
        },
      ),
    );
  }
}

final class _HomeSectionToggleTile extends ConsumerWidget {
  const _HomeSectionToggleTile({
    required this.index,
    required this.id,
    super.key,
  });

  final int index;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = _EditHomepagePageState._titleForId(id);
    final value = ref.watch(
      appSettingsProvider.select((s) {
        return switch (id) {
          'banner' => s.homeShowBanner,
          'accounts' => s.homeShowAccounts,
          'budgets' => s.homeShowBudgets,
          'goals' => s.homeShowGoals,
          'income_expenses' => s.homeShowIncomeAndExpenses,
          'net_worth' => s.homeShowNetWorth,
          'overdue_upcoming' => s.homeShowOverdueAndUpcoming,
          'loans' => s.homeShowLoans,
          'long_term_loans' => s.homeShowLongTermLoans,
          'spending_graph' => s.homeShowSpendingGraph,
          'pie_chart' => s.homeShowPieChart,
          'heat_map' => s.homeShowHeatMap,
          'transactions' => s.homeShowTransactionsList,
          _ => false,
        };
      }),
    );

    return Card(
      child: ListTile(
        key: ValueKey<String>('home_toggle_$id'),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        leading: ReorderableDelayedDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle),
        ),
        title: Text(title),
        trailing: Switch.adaptive(
          value: value,
          onChanged: (v) => _updateToggle(ref, id, v),
        ),
      ),
    );
  }

  static void _updateToggle(WidgetRef ref, String id, bool value) {
    final controller = ref.read(settingsControllerProvider.notifier);

    switch (id) {
      case 'banner':
        controller.updateHomeShowBanner(value);
      case 'accounts':
        controller.updateHomeShowAccounts(value);
      case 'budgets':
        controller.updateHomeShowBudgets(value);
      case 'goals':
        controller.updateHomeShowGoals(value);
      case 'income_expenses':
        controller.updateHomeShowIncomeAndExpenses(value);
      case 'net_worth':
        controller.updateHomeShowNetWorth(value);
      case 'overdue_upcoming':
        controller.updateHomeShowOverdueAndUpcoming(value);
      case 'loans':
        controller.updateHomeShowLoans(value);
      case 'long_term_loans':
        controller.updateHomeShowLongTermLoans(value);
      case 'spending_graph':
        controller.updateHomeShowSpendingGraph(value);
      case 'pie_chart':
        controller.updateHomeShowPieChart(value);
      case 'heat_map':
        controller.updateHomeShowHeatMap(value);
      case 'transactions':
        controller.updateHomeShowTransactionsList(value);
      default:
        break;
    }
  }
}
