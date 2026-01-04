import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatting/money_format.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/implicit_animated_list.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/goal.dart';
import 'providers/goals_controller.dart';
import 'providers/goals_providers.dart';
import 'widgets/goal_meta.dart';

final class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

final class _GoalsPageState extends ConsumerState<GoalsPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _goalColor(ColorScheme cs, String colorKey) {
    return switch (colorKey) {
      'secondary' => cs.secondary,
      'tertiary' => cs.tertiary,
      'error' => cs.error,
      _ => cs.primary,
    };
  }

  double _progressFraction(Goal goal) {
    final target = goal.target.amountMinor;
    if (target <= 0) return 0;
    final saved = goal.saved?.amountMinor ?? 0;
    final frac = saved / target;
    if (frac.isNaN || frac.isInfinite) return 0;
    return frac.clamp(0, 1).toDouble();
  }

  Future<void> _confirmAndDelete(Goal goal) async {
    final isSubmitting = ref.read(goalsControllerProvider).isLoading;
    if (isSubmitting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete goal?'),
          content: Text('Delete "${goal.name}"? This can\'t be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(goalsControllerProvider.notifier)
          .deleteGoal(goalId: goal.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalsListProvider);
    final query = _searchController.text.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      floatingActionButton: PressableScaleDecorator(
        pressedScale: 0.97,
        child: FloatingActionButton(
          onPressed: () => context.push(Routes.goalsAdd),
          child: const Icon(Icons.add),
        ),
      ),
      body: goalsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) =>
            EmptyState(title: 'Can\'t load goals', body: error.toString()),
        data: (items) {
          final visible = items
              .where((g) => !g.archived)
              .toList(growable: false);
          final filtered = query.isEmpty
              ? visible
              : visible
                    .where((g) => g.name.toLowerCase().contains(query))
                    .toList(growable: false);

          if (visible.isEmpty) {
            return const EmptyState(
              title: 'No goals yet',
              body: 'No goals yet. Add one to start tracking.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.s16),
            children: <Widget>[
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search goals…',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.s16),
              if (filtered.isEmpty)
                const EmptyState(
                  title: 'No matching goals',
                  body: 'Try a different search term.',
                  padding: EdgeInsets.zero,
                )
              else
                ImplicitAnimatedList<Goal>(
                  items: filtered,
                  itemKey: (g) => g.id,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, goal, animation) {
                    final isLast = identical(goal, filtered.last);
                    final meta = GoalMeta.parse(goal.note);
                    final cs = Theme.of(context).colorScheme;
                    final color = _goalColor(cs, meta.colorKey);
                    final fraction = _progressFraction(goal);
                    final savedText = formatMoney(
                      goal.saved ?? goal.target.copyWith(amountMinor: 0),
                    );
                    final targetText = formatMoney(goal.target);

                    final kindText = meta.kind == GoalKind.expense
                        ? 'Expense goal'
                        : 'Savings goal';
                    final deadlineText = goal.targetDate == null
                        ? null
                        : MaterialLocalizations.of(
                            context,
                          ).formatMediumDate(goal.targetDate!);

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isLast ? 0 : AppSpacing.s16,
                      ),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.s16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.s8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          goal.name,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: AppSpacing.s4),
                                        Text(
                                          deadlineText == null
                                              ? kindText
                                              : '$kindText • $deadlineText',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Edit',
                                    onPressed: () =>
                                        context.push(Routes.goalEdit(goal.id)),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    tooltip: 'Delete',
                                    onPressed: () => _confirmAndDelete(goal),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.s16),
                              LinearProgressIndicator(
                                value: fraction,
                                color: color,
                                backgroundColor: cs.surfaceContainerHighest,
                              ),
                              const SizedBox(height: AppSpacing.s8),
                              Text(
                                '$savedText saved • $targetText target',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: cs.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
