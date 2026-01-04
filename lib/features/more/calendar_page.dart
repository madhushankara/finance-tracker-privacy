import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/router/routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/models/app_settings.dart';
import '../settings/providers/settings_providers.dart';
import '../transactions/providers/transactions_providers.dart';

final class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

final class _CalendarPageState extends ConsumerState<CalendarPage> {
  static const int _initialPage = 1200;

  late final PageController _controller;
  int _page = _initialPage;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  DateTime _monthForPage(int page) {
    final now = DateTime.now();
    final base = DateTime(now.year, now.month);
    return _addMonths(base, page - _initialPage);
  }

  static DateTime _addMonths(DateTime monthStart, int deltaMonths) {
    final startIndex = monthStart.year * 12 + (monthStart.month - 1);
    final targetIndex = startIndex + deltaMonths;
    final year = targetIndex ~/ 12;
    final month = (targetIndex % 12) + 1;
    return DateTime(year, month);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsProvider);

    final txAsync = ref.watch(transactionsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: txAsync.when(
        data: (txs) {
          final dateHasAnyTx = <DateTime>{
            for (final tx in txs) DateUtils.dateOnly(tx.occurredAt),
          };

          final monthStart = _monthForPage(_page);
          final monthLabel = DateFormat('MMMM yyyy').format(monthStart);

          final selected = _selectedDate;

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s16,
                  AppSpacing.s16,
                  AppSpacing.s16,
                  AppSpacing.s8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    monthLabel,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              _WeekdayHeader(
                firstDayIsSunday:
                    settings.firstDayOfWeek == FirstDayOfWeek.sunday,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _page = value),
                  itemBuilder: (context, pageIndex) {
                    final m = _monthForPage(pageIndex);
                    return _MonthGrid(
                      monthStart: m,
                      firstDayIsSunday:
                          settings.firstDayOfWeek == FirstDayOfWeek.sunday,
                      dateHasAnyTx: dateHasAnyTx,
                      selectedDate: selected,
                      onTapDate: (date) {
                        final normalized = DateUtils.dateOnly(date);
                        setState(() => _selectedDate = normalized);
                      },
                    );
                  },
                ),
              ),
              if (selected != null)
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.s16,
                      0,
                      AppSpacing.s16,
                      AppSpacing.s16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          final dateParam = DateFormat(
                            'yyyy-MM-dd',
                          ).format(DateUtils.dateOnly(selected));
                          context.push('${Routes.calendarDay}?date=$dateParam');
                        },
                        child: Text(
                          'View transactions for ${DateFormat('d MMM yyyy').format(DateUtils.dateOnly(selected))}',
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        error: (e, _) {
          return Padding(
            padding: AppSpacing.pagePadding,
            child: EmptyState(
              title: 'Couldn\'t load calendar',
              body: e.toString(),
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

final class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.firstDayIsSunday});

  final bool firstDayIsSunday;

  @override
  Widget build(BuildContext context) {
    final labels = firstDayIsSunday
        ? const <String>['S', 'M', 'T', 'W', 'T', 'F', 'S']
        : const <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Row(
        children: <Widget>[
          for (final l in labels)
            Expanded(
              child: Center(
                child: Text(
                  l,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

final class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.monthStart,
    required this.firstDayIsSunday,
    required this.dateHasAnyTx,
    required this.selectedDate,
    required this.onTapDate,
  });

  final DateTime monthStart;
  final bool firstDayIsSunday;
  final Set<DateTime> dateHasAnyTx;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onTapDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final firstOfMonth = DateTime(monthStart.year, monthStart.month, 1);
    final firstWeekday = firstOfMonth.weekday; // 1=Mon ... 7=Sun
    final firstDayIndex = firstDayIsSunday ? DateTime.sunday : DateTime.monday;

    final startOffset = (firstWeekday - firstDayIndex + 7) % 7;
    final gridStart = firstOfMonth.subtract(Duration(days: startOffset));

    final today = DateUtils.dateOnly(DateTime.now());
    final selected = selectedDate == null
        ? null
        : DateUtils.dateOnly(selectedDate!);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: AppSpacing.s8,
          crossAxisSpacing: AppSpacing.s8,
        ),
        itemCount: 42,
        itemBuilder: (context, index) {
          final date = DateUtils.dateOnly(gridStart.add(Duration(days: index)));
          final isInMonth =
              date.month == monthStart.month && date.year == monthStart.year;
          final isToday = date == today;
          final isSelected = selected != null && date == selected;
          final hasTx = dateHasAnyTx.contains(date);

          final textStyle = theme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? cs.onPrimaryContainer
                : (isInMonth ? cs.onSurface : cs.onSurfaceVariant),
          );

          final border = isSelected
              ? Border.all(color: cs.primary)
              : (isToday
                    ? Border.all(color: cs.primary.withValues(alpha: 0.75))
                    : Border.all(color: cs.outline.withValues(alpha: 0.35)));

          final bgColor = isSelected
              ? cs.primaryContainer
              : (isInMonth ? cs.surface : cs.surface.withValues(alpha: 0.55));

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: isInMonth ? () => onTapDate(date) : null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: border,
                color: bgColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('${date.day}', style: textStyle),
                  const SizedBox(height: 4),
                  if (hasTx)
                    Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        color: isSelected ? cs.onPrimaryContainer : cs.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    const SizedBox(height: 4, width: 4),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
