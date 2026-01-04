import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../models/app_settings.dart';
import '../../models/enums.dart';

part 'app_database.g.dart';

part 'tables/accounts_table.dart';
part 'tables/categories_table.dart';
part 'tables/budgets_table.dart';
part 'tables/app_settings_table.dart';
part 'tables/goals_table.dart';
part 'tables/loans_table.dart';
part 'tables/transactions_table.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(dir.path, 'financial_ai.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(
  tables: <Type>[
    AccountsTable,
    CategoriesTable,
    BudgetsTable,
    AppSettingsTable,
    GoalsTable,
    LoansTable,
    TransactionsTable,
  ],
)
final class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 14;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(transactionsTable, transactionsTable.recurrenceType);
        await m.addColumn(
          transactionsTable,
          transactionsTable.recurrenceInterval,
        );
        await m.addColumn(transactionsTable, transactionsTable.recurrenceEndAt);
      }

      if (from < 3) {
        await m.addColumn(budgetsTable, budgetsTable.categoryIdsCsv);
      }

      if (from < 4) {
        await m.createTable(appSettingsTable);
      }

      if (from < 5) {
        await m.addColumn(transactionsTable, transactionsTable.lastExecutedAt);
      }

      if (from < 6) {
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.onboardingCompleted,
        );

        // Treat existing installs as already onboarded to avoid showing
        // onboarding after an upgrade.
        await update(appSettingsTable).write(
          const AppSettingsTableCompanion(onboardingCompleted: Value(true)),
        );
      }

      if (from < 7) {
        await m.addColumn(appSettingsTable, appSettingsTable.showExpenseInRed);
      }

      if (from < 8) {
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.themeMode as GeneratedColumn<Object>,
        );
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.accentColor as GeneratedColumn<Object>,
        );
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.useMaterialYouColors as GeneratedColumn<Object>,
        );
      }

      if (from < 9) {
        await m.addColumn(appSettingsTable, appSettingsTable.authUserId);
        await m.addColumn(appSettingsTable, appSettingsTable.authUsername);
        await m.addColumn(appSettingsTable, appSettingsTable.authDisplayName);
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.authBirthdayMillis,
        );
        await m.addColumn(appSettingsTable, appSettingsTable.authIsDemo);
        await m.addColumn(appSettingsTable, appSettingsTable.demoDataSeeded);
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.homeFeatureCardsDismissedCsv,
        );
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.lastBirthdayCelebratedAtMillis,
        );
      }

      if (from < 10) {
        await m.addColumn(appSettingsTable, appSettingsTable.homeShowUsername);
        await m.addColumn(appSettingsTable, appSettingsTable.homeShowBanner);
        await m.addColumn(appSettingsTable, appSettingsTable.homeShowAccounts);
        await m.addColumn(appSettingsTable, appSettingsTable.homeShowBudgets);
        await m.addColumn(appSettingsTable, appSettingsTable.homeShowGoals);
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.homeShowIncomeAndExpenses,
        );
        await m.addColumn(appSettingsTable, appSettingsTable.homeShowNetWorth);
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.homeShowOverdueAndUpcoming,
        );
        await m.addColumn(appSettingsTable, appSettingsTable.homeShowLoans);
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.homeShowLongTermLoans,
        );
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.homeShowSpendingGraph,
        );
        await m.addColumn(appSettingsTable, appSettingsTable.homeShowPieChart);
        await m.addColumn(appSettingsTable, appSettingsTable.homeShowHeatMap);
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.homeShowTransactionsList,
        );

        await m.addColumn(
          appSettingsTable,
          appSettingsTable.transactionReminderEnabled,
        );
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.transactionReminderTimeMinutes,
        );
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.upcomingTransactionsEnabled,
        );

        await m.addColumn(
          appSettingsTable,
          appSettingsTable.requireBiometricOnLaunch,
        );

        await m.addColumn(appSettingsTable, appSettingsTable.languageCode);
      }

      if (from < 11) {
        // Preserve the pre-Phase-7 Home layout for existing installs.
        // (These sections were newly introduced as customization options.)
        await update(appSettingsTable).write(
          const AppSettingsTableCompanion(
            homeShowBudgets: Value(false),
            homeShowGoals: Value(false),
            homeShowIncomeAndExpenses: Value(false),
            homeShowNetWorth: Value(false),
            homeShowOverdueAndUpcoming: Value(false),
            homeShowLoans: Value(false),
            homeShowLongTermLoans: Value(false),
            homeShowSpendingGraph: Value(false),
            homeShowPieChart: Value(false),
            homeShowHeatMap: Value(false),
          ),
        );
      }

      if (from < 12) {
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.autoProcessScheduledOnAppOpen,
        );
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.autoProcessRecurringOnAppOpen,
        );
      }

      if (from < 13) {
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.homeSectionOrderCsv as GeneratedColumn<Object>,
        );
      }

      if (from < 14) {
        await m.addColumn(
          appSettingsTable,
          appSettingsTable.swipeBetweenTabsEnabled,
        );
      }
    },
  );
}
