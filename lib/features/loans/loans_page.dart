import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/formatting/money_format.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/pressable_scale.dart';
import '../../data/models/loan.dart';
import '../../data/models/money.dart';
import 'providers/loans_controller.dart';
import 'providers/loans_providers.dart';

enum _LoanPartyFilter { all, lent, borrowed }

final class LoansPage extends ConsumerStatefulWidget {
  const LoansPage({super.key});

  @override
  ConsumerState<LoansPage> createState() => _LoansPageState();
}

final class _LoansPageState extends ConsumerState<LoansPage> {
  _LoanPartyFilter _filter = _LoanPartyFilter.all;
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Money _sumPrincipal(List<Loan> loans) {
    if (loans.isEmpty) {
      return const Money(currencyCode: 'INR', amountMinor: 0, scale: 2);
    }

    // Best effort: assume consistent currency/scale in this list.
    final first = loans.first.principal;
    var totalMinor = 0;
    for (final l in loans) {
      totalMinor += l.principal.amountMinor;
    }

    return Money(
      currencyCode: first.currencyCode,
      amountMinor: totalMinor,
      scale: first.scale,
    );
  }

  Future<void> _confirmAndDelete(Loan loan) async {
    final isSubmitting = ref.read(loansControllerProvider).isLoading;
    if (isSubmitting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete loan?'),
          content: Text('Delete "${loan.name}"? This can\'t be undone.'),
          actions: <Widget>[
            PressableScaleDecorator.forButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
            ),
            PressableScaleDecorator.forButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(loansControllerProvider.notifier)
          .deleteLoan(loanId: loan.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  String _termLabel(Loan loan) {
    final isLongTerm = (loan.termMonths != null && loan.termMonths! > 0);
    return isLongTerm ? 'Long-term loan' : 'One-time loan';
  }

  @override
  Widget build(BuildContext context) {
    final loansAsync = ref.watch(loansListProvider);
    final query = _searchController.text.trim().toLowerCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Loans')),
      floatingActionButton: PressableScaleDecorator(
        child: FloatingActionButton(
          onPressed: () => context.push(Routes.loansAdd),
          child: const Icon(Icons.add),
        ),
      ),
      body: loansAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (error, _) =>
            EmptyState(title: 'Can\'t load loans', body: error.toString()),
        data: (items) {
          final visible = items
              .where((l) => !l.archived)
              .toList(growable: false);

          if (visible.isEmpty) {
            return const EmptyState(
              title: 'No loans yet',
              body: 'No loans yet. Add one to start tracking.',
            );
          }

          final total = _sumPrincipal(visible);
          final totalText = formatMoney(total);
          final countText = visible.length.toString();

          // Filtering by Lent/Borrowed is not supported by the current domain model.
          // Keep the UI but guide users via the standard "under development" message.
          final filteredBySearch = query.isEmpty
              ? visible
              : visible
                    .where((l) {
                      final name = l.name.toLowerCase();
                      final note = (l.note ?? '').toLowerCase();
                      final lender = (l.lender ?? '').toLowerCase();
                      return name.contains(query) ||
                          note.contains(query) ||
                          lender.contains(query);
                    })
                    .toList(growable: false);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.s16),
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Total loan amount',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        totalText,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        'Total number of loan transactions: $countText',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SegmentedButton<_LoanPartyFilter>(
                      segments: const <ButtonSegment<_LoanPartyFilter>>[
                        ButtonSegment(
                          value: _LoanPartyFilter.all,
                          label: Text('All'),
                        ),
                        ButtonSegment(
                          value: _LoanPartyFilter.lent,
                          label: Text('Lent'),
                        ),
                        ButtonSegment(
                          value: _LoanPartyFilter.borrowed,
                          label: Text('Borrowed'),
                        ),
                      ],
                      selected: <_LoanPartyFilter>{_filter},
                      onSelectionChanged: (selection) {
                        final next = selection.first;
                        if (next == _LoanPartyFilter.all) {
                          setState(() => _filter = next);
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('This feature is under development.'),
                          ),
                        );
                        setState(() => _filter = _LoanPartyFilter.all);
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  IconButton(
                    tooltip: _isSearching ? 'Close search' : 'Search',
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchController.clear();
                        }
                      });
                    },
                    icon: Icon(_isSearching ? Icons.close : Icons.search),
                  ),
                ],
              ),
              if (_isSearching) ...<Widget>[
                const SizedBox(height: AppSpacing.s16),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search loans…',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ],
              const SizedBox(height: AppSpacing.s16),
              if (filteredBySearch.isEmpty)
                const EmptyState(
                  title: 'No matching loans',
                  body: 'Try a different search term.',
                  padding: EdgeInsets.zero,
                )
              else
                ...filteredBySearch.map((loan) {
                  final amountText = formatMoney(loan.principal);
                  final subtitleParts = <String>[_termLabel(loan)];
                  if ((loan.note ?? '').trim().isNotEmpty) {
                    subtitleParts.add(loan.note!.trim());
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.s16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.s16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    loan.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: AppSpacing.s4),
                                  Text(
                                    subtitleParts.join(' • '),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  amountText,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: AppSpacing.s8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    IconButton(
                                      tooltip: 'Edit',
                                      onPressed: () => context.push(
                                        Routes.loanEdit(loan.id),
                                      ),
                                      icon: const Icon(Icons.edit_outlined),
                                    ),
                                    IconButton(
                                      tooltip: 'Delete',
                                      onPressed: () => _confirmAndDelete(loan),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}
