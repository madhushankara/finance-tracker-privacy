import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../models/budget.dart';
import '../../models/category.dart';
import '../../models/enums.dart';
import '../../models/goal.dart';
import '../../models/loan.dart';
import '../../models/money.dart';
import '../../models/transaction.dart';
import '../account_repository.dart';
import '../app_settings_repository.dart';
import '../budget_repository.dart';
import '../category_repository.dart';
import '../demo_data_repository.dart';
import '../goal_repository.dart';
import '../loan_repository.dart';
import '../transaction_repository.dart';

final class DemoDataRepositoryImpl implements DemoDataRepository {
  DemoDataRepositoryImpl({
    required AccountRepository accounts,
    required CategoryRepository categories,
    required BudgetRepository budgets,
    required GoalRepository goals,
    required LoanRepository loans,
    required TransactionRepository transactions,
    required AppSettingsRepository appSettings,
  }) : _accounts = accounts,
       _categories = categories,
       _budgets = budgets,
       _goals = goals,
       _loans = loans,
       _transactions = transactions,
       _appSettings = appSettings;

  final AccountRepository _accounts;
  final CategoryRepository _categories;
  final BudgetRepository _budgets;
  final GoalRepository _goals;
  final LoanRepository _loans;
  final TransactionRepository _transactions;
  final AppSettingsRepository _appSettings;

  static const String _accCashId = 'demo_acc_cash';
  static const String _accSavingsId = 'demo_acc_savings';
  static const String _accBankId = 'demo_acc_bank';
  static const String _accWalletId = 'demo_acc_wallet';

  static const String _budgetFoodId = 'demo_budget_food';
  static const String _budgetTransportId = 'demo_budget_transport';
  static const String _budgetTravelId = 'demo_budget_travel';

  static const List<String> _userCategoryIds = <String>[
    'demo_cat_coffee',
    'demo_cat_movies',
    'demo_cat_fitness',
    'demo_cat_gadgets',
    'demo_cat_pets',
  ];

  @override
  Future<void> seedIfNeeded() async {
    final current = await _appSettings.get();
    final alreadySeeded = current.demoDataSeeded;

    if (alreadySeeded) return;

    final now = DateTime.now();
    final createdAt = now;

    Money inrInt(int rupees) => Money(
      currencyCode: current.primaryCurrencyCode,
      amountMinor: rupees * 100,
      scale: 2,
    );

    DateTime dateOnly(DateTime d) => DateUtils.dateOnly(d);

    String ymd(DateTime d) {
      final dd = dateOnly(d);
      final mm = dd.month.toString().padLeft(2, '0');
      final day = dd.day.toString().padLeft(2, '0');
      return '${dd.year}$mm$day';
    }

    // Ensure default categories exist (ids are stable: seed_exp_food, etc.).
    await _categories.seedDefaultsIfEmpty();

    // 4 Accounts (Cash, Savings, Bank, Wallet)
    await _accounts.upsert(
      Account(
        id: _accCashId,
        name: 'Cash',
        type: AccountType.cash,
        currencyCode: current.primaryCurrencyCode,
        openingBalance: inrInt(4500),
        institution: null,
        note: null,
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );
    await _accounts.upsert(
      Account(
        id: _accSavingsId,
        name: 'Savings',
        type: AccountType.bank,
        currencyCode: current.primaryCurrencyCode,
        openingBalance: inrInt(12000),
        institution: 'Demo Savings',
        note: null,
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );
    await _accounts.upsert(
      Account(
        id: _accBankId,
        name: 'Bank',
        type: AccountType.bank,
        currencyCode: current.primaryCurrencyCode,
        openingBalance: inrInt(25000),
        institution: 'Demo Bank',
        note: null,
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );
    await _accounts.upsert(
      Account(
        id: _accWalletId,
        name: 'Wallet',
        type: AccountType.cash,
        currencyCode: current.primaryCurrencyCode,
        openingBalance: inrInt(1800),
        institution: null,
        note: null,
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );

    // 5 new user-added categories (not defaults)
    final userCats = <Category>[
      Category(
        id: _userCategoryIds[0],
        name: 'Coffee',
        type: CategoryType.expense,
        parentId: null,
        iconKey: 'food',
        colorHex: 0xFF8D6E63,
        createdAt: createdAt,
        updatedAt: createdAt,
        archived: false,
      ),
      Category(
        id: _userCategoryIds[1],
        name: 'Movies',
        type: CategoryType.expense,
        parentId: null,
        iconKey: 'gift',
        colorHex: 0xFF9575CD,
        createdAt: createdAt,
        updatedAt: createdAt,
        archived: false,
      ),
      Category(
        id: _userCategoryIds[2],
        name: 'Fitness',
        type: CategoryType.expense,
        parentId: null,
        iconKey: 'health',
        colorHex: 0xFF4DB6AC,
        createdAt: createdAt,
        updatedAt: createdAt,
        archived: false,
      ),
      Category(
        id: _userCategoryIds[3],
        name: 'Gadgets',
        type: CategoryType.expense,
        parentId: null,
        iconKey: 'shopping',
        colorHex: 0xFF64B5F6,
        createdAt: createdAt,
        updatedAt: createdAt,
        archived: false,
      ),
      Category(
        id: _userCategoryIds[4],
        name: 'Pets',
        type: CategoryType.expense,
        parentId: null,
        iconKey: 'other',
        colorHex: 0xFFAED581,
        createdAt: createdAt,
        updatedAt: createdAt,
        archived: false,
      ),
    ];
    for (final c in userCats) {
      await _categories.upsert(c);
    }

    // 3 Budgets
    final range = _thisMonthRange(now);
    await _budgets.upsert(
      Budget(
        id: _budgetFoodId,
        name: 'Food Budget',
        amount: inrInt(15000),
        startDate: range.$1,
        endDate: range.$2,
        categoryIds: const <String>['seed_exp_food', 'demo_cat_coffee'],
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );
    await _budgets.upsert(
      Budget(
        id: _budgetTransportId,
        name: 'Transport Budget',
        amount: inrInt(8000),
        startDate: range.$1,
        endDate: range.$2,
        categoryIds: const <String>['seed_exp_transport'],
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );
    await _budgets.upsert(
      Budget(
        id: _budgetTravelId,
        name: 'Travel Budget',
        amount: inrInt(12000),
        startDate: range.$1,
        endDate: range.$2,
        categoryIds: const <String>['seed_exp_travel'],
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );

    // 5 Goals
    final goals = <Goal>[
      Goal(
        id: 'demo_goal_emergency',
        name: 'Emergency Fund',
        target: inrInt(50000),
        saved: inrInt(8000),
        currencyCode: current.primaryCurrencyCode,
        targetDate: DateTime(now.year, now.month + 6, 1),
        note: 'Build a 3-month buffer',
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Goal(
        id: 'demo_goal_trip',
        name: 'Weekend Trip',
        target: inrInt(15000),
        saved: inrInt(2500),
        currencyCode: current.primaryCurrencyCode,
        targetDate: DateTime(now.year, now.month + 2, 1),
        note: 'Short getaway',
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Goal(
        id: 'demo_goal_gadget',
        name: 'New Phone',
        target: inrInt(60000),
        saved: inrInt(12000),
        currencyCode: current.primaryCurrencyCode,
        targetDate: DateTime(now.year, now.month + 8, 1),
        note: 'Upgrade device',
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Goal(
        id: 'demo_goal_course',
        name: 'Online Course',
        target: inrInt(7000),
        saved: inrInt(1000),
        currencyCode: current.primaryCurrencyCode,
        targetDate: DateTime(now.year, now.month + 1, 15),
        note: 'Skill up',
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Goal(
        id: 'demo_goal_car',
        name: 'Car Downpayment',
        target: inrInt(200000),
        saved: inrInt(25000),
        currencyCode: current.primaryCurrencyCode,
        targetDate: DateTime(now.year + 1, now.month, 1),
        note: 'Save steadily',
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    ];
    for (final g in goals) {
      await _goals.upsert(g);
    }

    // 6 Loans
    final loans = <Loan>[
      Loan(
        id: 'demo_loan_personal',
        name: 'Personal Loan',
        type: LoanType.personal,
        currencyCode: current.primaryCurrencyCode,
        principal: inrInt(75000),
        interestAprBps: 1450,
        lender: 'Demo Finance Co',
        startDate: DateTime(now.year, now.month - 6, 1),
        termMonths: 24,
        note: null,
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Loan(
        id: 'demo_loan_auto',
        name: 'Auto Loan',
        type: LoanType.auto,
        currencyCode: current.primaryCurrencyCode,
        principal: inrInt(300000),
        interestAprBps: 980,
        lender: 'Demo Bank',
        startDate: DateTime(now.year, now.month - 10, 1),
        termMonths: 60,
        note: null,
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Loan(
        id: 'demo_loan_student',
        name: 'Student Loan',
        type: LoanType.student,
        currencyCode: current.primaryCurrencyCode,
        principal: inrInt(120000),
        interestAprBps: 750,
        lender: 'Education Fund',
        startDate: DateTime(now.year - 1, now.month, 1),
        termMonths: 36,
        note: null,
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Loan(
        id: 'demo_loan_mortgage',
        name: 'Home Loan',
        type: LoanType.mortgage,
        currencyCode: current.primaryCurrencyCode,
        principal: inrInt(1500000),
        interestAprBps: 820,
        lender: 'Demo Housing Bank',
        startDate: DateTime(now.year - 2, 1, 1),
        termMonths: 240,
        note: null,
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Loan(
        id: 'demo_loan_business',
        name: 'Business Loan',
        type: LoanType.business,
        currencyCode: current.primaryCurrencyCode,
        principal: inrInt(500000),
        interestAprBps: 1325,
        lender: 'Demo SME Bank',
        startDate: DateTime(now.year, now.month - 3, 1),
        termMonths: 48,
        note: null,
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
      Loan(
        id: 'demo_loan_other',
        name: 'Borrowed from Friend',
        type: LoanType.other,
        currencyCode: current.primaryCurrencyCode,
        principal: inrInt(15000),
        interestAprBps: null,
        lender: 'Alex',
        startDate: DateTime(now.year, now.month - 1, 10),
        termMonths: 6,
        note: 'Pay back in 2 parts',
        archived: false,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    ];
    for (final l in loans) {
      await _loans.upsert(l);
    }

    FinanceTransaction baseTx({
      required String id,
      required TransactionType type,
      required TransactionStatus status,
      required String accountId,
      required int amountRupees,
      required DateTime occurredAt,
      String? toAccountId,
      String? categoryId,
      String? budgetId,
      String? title,
      String? merchant,
      String? note,
      RecurrenceType? recurrenceType,
      int recurrenceInterval = 1,
      DateTime? recurrenceEndAt,
      DateTime? lastExecutedAt,
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
        currencyCode: current.primaryCurrencyCode,
        occurredAt: occurredAt,
        title: title,
        note: note,
        merchant: merchant,
        reference: null,
        createdAt: createdAt,
        updatedAt: createdAt,
        lastExecutedAt: lastExecutedAt,
        recurrenceType: recurrenceType,
        recurrenceInterval: recurrenceInterval,
        recurrenceEndAt: recurrenceEndAt,
      );
    }

    // 2 Subscriptions (represented as recurring expense templates).
    final subscription1 = baseTx(
      id: 'demo_sub_netflix',
      type: TransactionType.expense,
      status: TransactionStatus.posted,
      accountId: _accBankId,
      categoryId: 'seed_exp_home',
      amountRupees: 499,
      occurredAt: DateTime(now.year, now.month, 5, 9, 0),
      title: 'Netflix',
      merchant: 'Netflix',
      recurrenceType: RecurrenceType.monthly,
      recurrenceInterval: 1,
      lastExecutedAt: dateOnly(DateTime(now.year, now.month - 1, 5)),
    );
    final subscription2 = baseTx(
      id: 'demo_sub_spotify',
      type: TransactionType.expense,
      status: TransactionStatus.posted,
      accountId: _accBankId,
      categoryId: 'demo_cat_movies',
      amountRupees: 119,
      occurredAt: DateTime(now.year, now.month, 12, 9, 0),
      title: 'Spotify',
      merchant: 'Spotify',
      recurrenceType: RecurrenceType.monthly,
      recurrenceInterval: 1,
      lastExecutedAt: dateOnly(DateTime(now.year, now.month - 1, 12)),
    );

    // 2 Scheduled transactions (non-recurring).
    final scheduled1 = baseTx(
      id: 'demo_sched_rent_${ymd(DateTime(now.year, now.month + 1, 1))}',
      type: TransactionType.expense,
      status: TransactionStatus.scheduled,
      accountId: _accBankId,
      categoryId: 'seed_exp_home',
      amountRupees: 12000,
      occurredAt: DateTime(now.year, now.month + 1, 1, 10, 0),
      title: 'Rent',
      merchant: 'Landlord',
    );
    final scheduled2 = baseTx(
      id: 'demo_sched_insurance_${ymd(DateTime(now.year, now.month + 1, 18))}',
      type: TransactionType.expense,
      status: TransactionStatus.scheduled,
      accountId: _accBankId,
      categoryId: 'seed_exp_health',
      amountRupees: 1800,
      occurredAt: DateTime(now.year, now.month + 1, 18, 10, 0),
      title: 'Insurance',
      merchant: 'Demo Insurance',
    );

    // 50 posted transactions total. We include the 2 subscriptions above as part
    // of the posted count (48 normal + 2 subscriptions).
    final posted = <FinanceTransaction>[subscription1, subscription2];

    final today = dateOnly(now);
    final r = Random(20260105);
    const categoryPool = <String>[
      'seed_exp_food',
      'seed_exp_transport',
      'seed_exp_shopping',
      'seed_exp_home',
      'seed_exp_health',
      'seed_exp_travel',
      'demo_cat_coffee',
      'demo_cat_movies',
      'demo_cat_fitness',
      'demo_cat_gadgets',
      'demo_cat_pets',
    ];
    const merchants = <String>[
      'Amazon',
      'Swiggy',
      'Uber',
      'Big Bazaar',
      'Bookstore',
      'Fuel Station',
      'Cafe',
      'Pharmacy',
      'Cinema',
    ];
    const titles = <String>[
      'Groceries',
      'Dinner',
      'Coffee',
      'Fuel',
      'Movie tickets',
      'Gym',
      'Shopping',
      'Taxi',
      'Snacks',
    ];

    for (var i = 0; i < 48; i++) {
      final occurredAt = today.subtract(Duration(days: 3 * i + (i % 2)));
      final accountId = switch (i % 4) {
        0 => _accCashId,
        1 => _accBankId,
        2 => _accWalletId,
        _ => _accSavingsId,
      };

      final isIncome = i % 9 == 0;
      final isTransfer = i % 17 == 0;

      if (isTransfer) {
        posted.add(
          baseTx(
            id: 'demo_tx_transfer_${ymd(occurredAt)}_$i',
            type: TransactionType.transfer,
            status: TransactionStatus.posted,
            accountId: _accBankId,
            toAccountId: _accSavingsId,
            amountRupees: 2000 + (i * 10),
            occurredAt: DateTime(
              occurredAt.year,
              occurredAt.month,
              occurredAt.day,
              11,
              30,
            ),
            title: 'Transfer to Savings',
            merchant: 'Internal',
          ),
        );
        continue;
      }

      if (isIncome) {
        posted.add(
          baseTx(
            id: 'demo_tx_income_${ymd(occurredAt)}_$i',
            type: TransactionType.income,
            status: TransactionStatus.posted,
            accountId: _accBankId,
            categoryId: 'seed_inc_salary',
            amountRupees: 15000 + (i * 25),
            occurredAt: DateTime(
              occurredAt.year,
              occurredAt.month,
              occurredAt.day,
              10,
              15,
            ),
            title: 'Side income',
            merchant: 'Client',
          ),
        );
        continue;
      }

      final categoryId = categoryPool[r.nextInt(categoryPool.length)];
      final merchant = merchants[r.nextInt(merchants.length)];
      final title = titles[r.nextInt(titles.length)];
      final amount = 80 + (r.nextInt(1200));

      posted.add(
        baseTx(
          id: 'demo_tx_exp_${ymd(occurredAt)}_$i',
          type: TransactionType.expense,
          status: TransactionStatus.posted,
          accountId: accountId,
          categoryId: categoryId,
          budgetId:
              categoryId == 'seed_exp_food' || categoryId == 'demo_cat_coffee'
              ? _budgetFoodId
              : (categoryId == 'seed_exp_transport'
                    ? _budgetTransportId
                    : null),
          amountRupees: amount,
          occurredAt: DateTime(
            occurredAt.year,
            occurredAt.month,
            occurredAt.day,
            19,
            0,
          ),
          title: title,
          merchant: merchant,
        ),
      );
    }

    // Insert transactions idempotently.
    for (final tx in posted.take(50)) {
      await _transactions.insertIfAbsent(tx);
    }
    await _transactions.insertIfAbsent(scheduled1);
    await _transactions.insertIfAbsent(scheduled2);

    await _appSettings.upsert(current.copyWith(demoDataSeeded: true));
  }

  (DateTime, DateTime) _thisMonthRange(DateTime now) {
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return (start, end);
  }
}
