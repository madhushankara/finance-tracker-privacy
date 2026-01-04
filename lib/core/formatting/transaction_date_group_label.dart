import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/app_settings.dart';

String transactionDateGroupLabel(
  DateTime occurredAt, {
  DateTime? now,
  String? locale,
  AppSettings? settings,
}) {
  final s = settings ?? AppSettings.defaults;
  final current = now ?? DateTime.now();
  final today = DateUtils.dateOnly(current);
  final date = DateUtils.dateOnly(occurredAt);

  final diffDays = today.difference(date).inDays;
  if (diffDays == 0) return 'Today';
  if (diffDays == 1) return 'Yesterday';

  final thisWeekStart = _startOfWeek(today, firstDayOfWeek: s.firstDayOfWeek);
  final nextWeekStart = thisWeekStart.add(const Duration(days: 7));
  final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));

  if (!date.isBefore(thisWeekStart) && date.isBefore(nextWeekStart)) {
    return 'This week';
  }
  if (!date.isBefore(lastWeekStart) && date.isBefore(thisWeekStart)) {
    return 'Last week';
  }

  return switch (s.dateFormat) {
    AppDateFormat.iso => DateFormat('yyyy-MM-dd', locale).format(date),
    AppDateFormat.localeBased => DateFormat('EEE, d MMM', locale).format(date),
  };
}

DateTime _startOfWeek(DateTime date, {required FirstDayOfWeek firstDayOfWeek}) {
  final d = DateUtils.dateOnly(date);
  // Dart: Monday=1 ... Sunday=7.
  final weekday = d.weekday;

  final offset = switch (firstDayOfWeek) {
    FirstDayOfWeek.monday => weekday - DateTime.monday,
    // Sunday=7 should yield offset 0.
    FirstDayOfWeek.sunday => weekday % DateTime.daysPerWeek,
  };

  return d.subtract(Duration(days: offset));
}
