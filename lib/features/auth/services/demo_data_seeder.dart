import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:math';

import '../../../data/models/account.dart';
import '../../../data/models/budget.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/money.dart';
import '../../../data/models/transaction.dart';
import '../../../data/providers/repository_providers.dart';
import '../../../data/repositories/app_settings_repository.dart';

final class DemoDataSeeder {
  const DemoDataSeeder();

  static const String demoAccountCashId = 'demo_acc_cash';
  static const String demoAccountBankId = 'demo_acc_bank';

  static const String demoBudgetFoodId = 'demo_budget_food';

  Future<void> seedIfNeeded(Ref ref) async {
    final AppSettingsRepository settingsRepo = ref.read(
      appSettingsRepositoryProvider,
    );
    final current = await settingsRepo.get();
    final alreadySeeded = current.demoDataSeeded;

    final now = DateTime.now();
    final createdAt = now;

    if (!alreadySeeded) {
      final accountsRepo = ref.read(accountRepositoryProvider);
      final cash = Account(
        id: demoAccountCashId,
        name: 'Cash',
        type: AccountType.cash,
        currencyCode: current.primaryCurrencyCode,
        openingBalance: Money(
          currencyCode: current.primaryCurrencyCode,
          amountMinor: 450000,
          scale: 2,
        ),
        institution: null,
        note: null,
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      final bank = Account(
        id: demoAccountBankId,
        name: 'Bank',
        type: AccountType.bank,
        currencyCode: current.primaryCurrencyCode,
        openingBalance: Money(
          currencyCode: current.primaryCurrencyCode,
          amountMinor: 2500000,
          scale: 2,
        ),
        institution: 'Demo Bank',
        note: null,
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      await accountsRepo.upsert(cash);
      await accountsRepo.upsert(bank);

      // Ensure default categories exist (ids are stable: seed_exp_food, etc.).
      await ref.read(categoryRepositoryProvider).seedDefaultsIfEmpty();

      final budgetsRepo = ref.read(budgetRepositoryProvider);
      final range = _thisMonthRange(now);

      final foodBudget = Budget(
        id: demoBudgetFoodId,
        name: 'Food Budget',
        amount: Money(
          currencyCode: current.primaryCurrencyCode,
          amountMinor: 1500000,
          scale: 2,
        ),
        startDate: range.$1,
        endDate: range.$2,
        categoryIds: const <String>['seed_exp_food'],
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      await budgetsRepo.upsert(foodBudget);
    }

    final txRepo = ref.read(transactionRepositoryProvider);
    final txs = _demoTransactions(
      now: now,
      currency: current.primaryCurrencyCode,
    );
    for (final tx in txs) {
      await txRepo.insertIfAbsent(tx);
    }

    if (!alreadySeeded) {
      await settingsRepo.upsert(current.copyWith(demoDataSeeded: true));
    }
  }

  (DateTime, DateTime) _thisMonthRange(DateTime now) {
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return (start, end);
  }

  List<FinanceTransaction> _demoTransactions({
    required DateTime now,
    required String currency,
  }) {
    final createdAt = now;
    final updatedAt = now;

    Money inrInt(int rupees) =>
        Money(currencyCode: currency, amountMinor: rupees * 100, scale: 2);

    int clampInt(int v, int min, int max) {
      if (v < min) return min;
      if (v > max) return max;
      return v;
    }

    int randInt(Random r, int min, int maxInclusive) {
      if (maxInclusive <= min) return min;
      return min + r.nextInt(maxInclusive - min + 1);
    }

    DateTime dateOnly(DateTime d) => DateUtils.dateOnly(d);

    String ymd(DateTime d) {
      final dd = dateOnly(d);
      final mm = dd.month.toString().padLeft(2, '0');
      final day = dd.day.toString().padLeft(2, '0');
      return '${dd.year}$mm$day';
    }

    FinanceTransaction tx({
      required String id,
      required TransactionType type,
      required TransactionStatus status,
      required String accountId,
      String? toAccountId,
      String? categoryId,
      String? budgetId,
      required int amountRupees,
      required DateTime occurredAt,
      String? title,
      String? merchant,
      String? note,
    }) {
      return FinanceTransaction(
        id: id,
        type: type,
        status: status,
        accountId: accountId,
        toAccountId: toAccountId,
        categoryId: categoryId,
        budgetId: budgetId,
        amount: inrInt(amountRupees),
        currencyCode: currency,
        occurredAt: occurredAt,
        title: title,
        note: note,
        merchant: merchant,
        reference: null,
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastExecutedAt: null,
        recurrenceType: null,
        recurrenceInterval: 1,
        recurrenceEndAt: null,
      );
    }

    final today = dateOnly(now);
    final txs = <FinanceTransaction>[];

    // Build ~160 posted transactions across the last ~7 months.
    // Deterministic generation keeps the demo consistent per-install.
    const monthlyCounts = <int>[26, 25, 24, 23, 22, 21, 19];

    // Seed in a repeating salary pattern (one per month).
    for (
      var monthOffset = 0;
      monthOffset < monthlyCounts.length;
      monthOffset++
    ) {
      final monthAnchor = DateTime(today.year, today.month - monthOffset, 1);
      final daysInMonth = DateTime(
        monthAnchor.year,
        monthAnchor.month + 1,
        0,
      ).day;
      final salaryDay = clampInt(1, 1, daysInMonth);
      final occurredAt = DateTime(
        monthAnchor.year,
        monthAnchor.month,
        salaryDay,
        10,
        15,
      );
      if (!dateOnly(occurredAt).isAfter(today)) {
        final base = 82000 - (monthOffset * 700);
        final salary = clampInt(base, 72000, 92000);
        txs.add(
          tx(
            id: 'demo_tx_salary_${ymd(occurredAt)}',
            type: TransactionType.income,
            status: TransactionStatus.posted,
            accountId: demoAccountBankId,
            categoryId: 'seed_inc_salary',
            amountRupees: salary,
            occurredAt: occurredAt,
            title: 'Salary',
            merchant: 'Acme Corp',
          ),
        );
      }
    }

    // Generate expenses/transfers with variable day density.
    for (
      var monthOffset = 0;
      monthOffset < monthlyCounts.length;
      monthOffset++
    ) {
      final monthAnchor = DateTime(today.year, today.month - monthOffset, 1);
      final daysInMonth = DateTime(
        monthAnchor.year,
        monthAnchor.month + 1,
        0,
      ).day;
      final seed = 1337 + (monthAnchor.year * 100) + monthAnchor.month;
      final r = Random(seed);

      final target = monthlyCounts[monthOffset];
      var added = 0;
      var seq = 0;

      // A few deterministic transfers (cash withdrawals) across months.
      if (monthOffset % 2 == 0) {
        final day = clampInt(12 + r.nextInt(10), 1, daysInMonth);
        final occurredAt = DateTime(
          monthAnchor.year,
          monthAnchor.month,
          day,
          13,
          5,
        );
        if (!dateOnly(occurredAt).isAfter(today)) {
          final amt = randInt(r, 2000, 8000);
          txs.add(
            tx(
              id: 'demo_tx_withdraw_${ymd(occurredAt)}',
              type: TransactionType.transfer,
              status: TransactionStatus.posted,
              accountId: demoAccountBankId,
              toAccountId: demoAccountCashId,
              amountRupees: amt,
              occurredAt: occurredAt,
              title: 'Cash withdrawal',
              merchant: 'ATM',
            ),
          );
        }
      }

      while (added < target) {
        seq++;

        // Prefer a few clustered spending days for heatmap realism.
        final baseDay = randInt(r, 1, daysInMonth);
        final cluster = r.nextDouble() < 0.25;
        final day = clampInt(
          cluster ? (baseDay + randInt(r, -1, 1)) : baseDay,
          1,
          daysInMonth,
        );

        final hour = randInt(r, 8, 21);
        final minute = randInt(r, 0, 59);
        final occurredAt = DateTime(
          monthAnchor.year,
          monthAnchor.month,
          day,
          hour,
          minute,
        );
        if (dateOnly(occurredAt).isAfter(today)) {
          continue;
        }

        final choice = r.nextInt(100);
        // Bias: most entries are expenses.
        if (choice < 90) {
          final categoryRoll = r.nextInt(100);
          String categoryId;
          String title;
          String merchant;
          int amount;
          String accountId;

          if (categoryRoll < 30) {
            categoryId = 'seed_exp_food';
            accountId = demoAccountCashId;
            final t = r.nextInt(4);
            switch (t) {
              case 0:
                title = 'Coffee';
                merchant = 'Cafe';
                amount = randInt(r, 120, 280);
                break;
              case 1:
                title = 'Lunch';
                merchant = 'Eatery';
                amount = randInt(r, 180, 520);
                break;
              case 2:
                title = 'Groceries';
                merchant = 'Fresh Mart';
                amount = randInt(r, 800, 2400);
                break;
              default:
                title = 'Snacks';
                merchant = 'Store';
                amount = randInt(r, 80, 220);
                break;
            }
          } else if (categoryRoll < 45) {
            categoryId = 'seed_exp_transport';
            final t = r.nextInt(3);
            switch (t) {
              case 0:
                title = 'Ride';
                merchant = 'Taxi';
                amount = randInt(r, 120, 650);
                accountId = demoAccountBankId;
                break;
              case 1:
                title = 'Fuel';
                merchant = 'Fuel Station';
                amount = randInt(r, 800, 2200);
                accountId = demoAccountBankId;
                break;
              default:
                title = 'Metro';
                merchant = 'Metro';
                amount = randInt(r, 40, 180);
                accountId = demoAccountCashId;
                break;
            }
          } else if (categoryRoll < 62) {
            categoryId = 'seed_exp_home';
            accountId = demoAccountBankId;
            final t = r.nextInt(3);
            switch (t) {
              case 0:
                title = 'Electricity bill';
                merchant = 'Utility';
                amount = randInt(r, 1200, 2600);
                break;
              case 1:
                title = 'Internet';
                merchant = 'ISP';
                amount = randInt(r, 650, 1200);
                break;
              default:
                title = 'Rent';
                merchant = 'Landlord';
                amount = randInt(r, 14000, 22000);
                break;
            }
          } else if (categoryRoll < 75) {
            categoryId = 'seed_exp_shopping';
            accountId = demoAccountBankId;
            final t = r.nextInt(3);
            switch (t) {
              case 0:
                title = 'Shopping';
                merchant = 'Online Store';
                amount = randInt(r, 600, 5200);
                break;
              case 1:
                title = 'Clothing';
                merchant = 'Store';
                amount = randInt(r, 700, 4200);
                break;
              default:
                title = 'Electronics';
                merchant = 'Online Store';
                amount = randInt(r, 1200, 9000);
                break;
            }
          } else if (categoryRoll < 85) {
            categoryId = 'seed_exp_health';
            accountId = demoAccountBankId;
            final t = r.nextInt(2);
            if (t == 0) {
              title = 'Pharmacy';
              merchant = 'Pharmacy';
              amount = randInt(r, 180, 1100);
            } else {
              title = 'Doctor visit';
              merchant = 'Clinic';
              amount = randInt(r, 500, 2200);
            }
          } else if (categoryRoll < 92) {
            categoryId = 'seed_exp_education';
            accountId = demoAccountBankId;
            final t = r.nextInt(2);
            if (t == 0) {
              title = 'Books';
              merchant = 'Bookstore';
              amount = randInt(r, 350, 1800);
            } else {
              title = 'Course';
              merchant = 'Online';
              amount = randInt(r, 900, 4500);
            }
          } else {
            categoryId = 'seed_exp_travel';
            accountId = demoAccountBankId;
            title = 'Travel';
            merchant = 'Travel';
            amount = randInt(r, 1500, 12000);
          }

          txs.add(
            tx(
              id: 'demo_tx_${ymd(occurredAt)}_${seq.toString().padLeft(2, '0')}',
              type: TransactionType.expense,
              status: TransactionStatus.posted,
              accountId: accountId,
              categoryId: categoryId,
              amountRupees: amount,
              occurredAt: occurredAt,
              title: title,
              merchant: merchant,
            ),
          );
          added++;
        } else {
          // Small income spikes (gifts/refunds).
          final amt = randInt(r, 300, 2500);
          txs.add(
            tx(
              id: 'demo_tx_gift_${ymd(occurredAt)}_${seq.toString().padLeft(2, '0')}',
              type: TransactionType.income,
              status: TransactionStatus.posted,
              accountId: demoAccountBankId,
              categoryId: 'seed_inc_gift',
              amountRupees: amt,
              occurredAt: occurredAt,
              title: 'Gift',
              merchant: 'Friend',
            ),
          );
          added++;
        }
      }
    }

    // Add a few scheduled items to populate Scheduled / Overdue.
    final scheduledSeed = Random(4242);
    for (var i = 0; i < 6; i++) {
      final daysAhead = 3 + scheduledSeed.nextInt(18);
      final date = dateOnly(now).add(Duration(days: daysAhead));
      final occurredAt = DateTime(date.year, date.month, date.day, 9, 0);
      final amount = randInt(scheduledSeed, 500, 3500);
      txs.add(
        tx(
          id: 'demo_tx_sched_${ymd(occurredAt)}_${i.toString().padLeft(2, '0')}',
          type: TransactionType.expense,
          status: TransactionStatus.scheduled,
          accountId: demoAccountBankId,
          categoryId: 'seed_exp_home',
          amountRupees: amount,
          occurredAt: occurredAt,
          title: 'Bill (scheduled)',
          merchant: 'Utility',
        ),
      );
    }
    for (var i = 0; i < 3; i++) {
      final daysBehind = 2 + scheduledSeed.nextInt(10);
      final date = dateOnly(now).subtract(Duration(days: daysBehind));
      final occurredAt = DateTime(date.year, date.month, date.day, 9, 0);
      final amount = randInt(scheduledSeed, 300, 1800);
      txs.add(
        tx(
          id: 'demo_tx_overdue_${ymd(occurredAt)}_${i.toString().padLeft(2, '0')}',
          type: TransactionType.expense,
          status: TransactionStatus.scheduled,
          accountId: demoAccountBankId,
          categoryId: 'seed_exp_home',
          amountRupees: amount,
          occurredAt: occurredAt,
          title: 'Bill (overdue)',
          merchant: 'Utility',
        ),
      );
    }

    return txs;
  }
}
