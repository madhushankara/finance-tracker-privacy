import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker/core/formatting/transaction_date_group_label.dart';
import 'package:finance_tracker/data/models/app_settings.dart';

void main() {
  group('transactionDateGroupLabel + settings', () {
    test('respects firstDayOfWeek for This week/Last week boundaries', () {
      // Sunday 2026-01-04.
      final now = DateTime(2026, 1, 4, 12);

      final mondaySettings = AppSettings.defaults.copyWith(firstDayOfWeek: FirstDayOfWeek.monday);
      final sundaySettings = AppSettings.defaults.copyWith(firstDayOfWeek: FirstDayOfWeek.sunday);

      // Date = Monday 2025-12-29
      final d = DateTime(2025, 12, 29, 9);

      final labelMonday = transactionDateGroupLabel(d, now: now, settings: mondaySettings);
      // With Monday as first day, 2025-12-29 is in the same week as 2026-01-04.
      expect(labelMonday, 'This week');

      final labelSunday = transactionDateGroupLabel(d, now: now, settings: sundaySettings);
      // With Sunday as first day, week starts 2026-01-04, so 2025-12-29 falls in last week.
      expect(labelSunday, 'Last week');
    });

    test('respects ISO date format option (outside week buckets)', () {
      final now = DateTime(2026, 1, 3, 12);
      final settings = AppSettings.defaults.copyWith(dateFormat: AppDateFormat.iso);

      final d = DateTime(2025, 1, 1, 9);
      final label = transactionDateGroupLabel(d, now: now, settings: settings);
      expect(label, '2025-01-01');
    });
  });
}
