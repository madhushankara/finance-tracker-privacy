import 'package:drift/drift.dart';

import '../datasources/drift/app_database.dart';
import '../models/goal.dart';
import '../models/money.dart';

final class GoalMapper {
  const GoalMapper();

  Goal fromRow(GoalRow row) {
    return Goal(
      id: row.id,
      name: row.name,
      currencyCode: row.currencyCode,
      target: Money(
        currencyCode: row.currencyCode,
        amountMinor: row.targetMinor,
        scale: row.targetScale,
      ),
      saved: (row.savedMinor != null && row.savedScale != null)
          ? Money(
              currencyCode: row.currencyCode,
              amountMinor: row.savedMinor!,
              scale: row.savedScale!,
            )
          : null,
      targetDate: row.targetDate,
      note: row.note,
      archived: row.archived,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  GoalsTableCompanion toCompanion(Goal goal) {
    return GoalsTableCompanion(
      id: Value(goal.id),
      name: Value(goal.name),
      currencyCode: Value(goal.currencyCode),
      targetMinor: Value(goal.target.amountMinor),
      targetScale: Value(goal.target.scale),
      savedMinor: Value(goal.saved?.amountMinor),
      savedScale: Value(goal.saved?.scale),
      targetDate: Value(goal.targetDate),
      note: Value(goal.note),
      archived: Value(goal.archived),
      createdAt: Value(goal.createdAt),
      updatedAt: Value(goal.updatedAt),
    );
  }
}
