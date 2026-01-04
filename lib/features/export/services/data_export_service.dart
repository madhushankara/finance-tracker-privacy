import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import '../../../data/models/account.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/models/budget.dart';
import '../../../data/models/category.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/money.dart';
import '../../../data/models/transaction.dart';

final class ExportBundle {
  const ExportBundle({required this.fileName, required this.bytes});

  final String fileName;
  final Uint8List bytes;
}

/// Isolate-safe payload for export encoding.
///
/// Must contain only sendable types (String/bool/int/double/null + Lists/Maps of those).
typedef ExportPayload = Map<String, Object?>;

/// Builds the final ZIP bundle from an [ExportPayload].
///
/// Intended to run inside an isolate.
ExportBundle buildZipBundleFromPayload(ExportPayload payload) {
  final fileName = payload['fileName'] as String;
  final files = payload['files'] as List<Object?>;

  final archive = Archive();

  for (final f in files) {
    final file = f as Map<Object?, Object?>;
    final name = file['name'] as String;
    final header = (file['header'] as List<Object?>).cast<String>();
    final rows = (file['rows'] as List<Object?>).cast<Map<String, String>>();
    final csv = _CsvWriter().write(header: header, rows: rows);
    archive.addFile(DataExportService._utf8File(name, csv));
  }

  final zipBytes = ZipEncoder().encode(archive);
  return ExportBundle(fileName: fileName, bytes: Uint8List.fromList(zipBytes));
}

/// READ-ONLY data export for backup/external analysis.
///
/// - Produces UTF-8 CSV files (ISO dates, decimal major units).
/// - Excludes scheduled transactions and recurring templates.
/// - Does not mutate input models.
final class DataExportService {
  const DataExportService();

  /// Creates an isolate-safe payload (no CSV string building).
  ExportPayload buildPayload({
    required List<Account> accounts,
    required List<Category> categories,
    required List<FinanceTransaction> transactions,
    required List<Budget> budgets,
    required AppSettings settings,
    DateTime? now,
  }) {
    final timestamp = _isoDate(now ?? DateTime.now());
    final zipName = 'financial_ai_export_$timestamp.zip';

    return <String, Object?>{
      'fileName': zipName,
      'files': <Object?>[
        <String, Object?>{
          'name': 'accounts.csv',
          'header': _accountsHeader,
          'rows': _buildAccountsRows(accounts: accounts, settings: settings),
        },
        <String, Object?>{
          'name': 'categories.csv',
          'header': _categoriesHeader,
          'rows': _buildCategoriesRows(categories: categories),
        },
        <String, Object?>{
          'name': 'transactions.csv',
          'header': _transactionsHeader,
          'rows': _buildTransactionsRows(transactions: transactions, settings: settings),
        },
        <String, Object?>{
          'name': 'budgets.csv',
          'header': _budgetsHeader,
          'rows': _buildBudgetsRows(budgets: budgets, settings: settings),
        },
      ],
    };
  }

  ExportBundle buildZipBundle({
    required List<Account> accounts,
    required List<Category> categories,
    required List<FinanceTransaction> transactions,
    required List<Budget> budgets,
    required AppSettings settings,
    DateTime? now,
  }) {
    final payload = buildPayload(
      accounts: accounts,
      categories: categories,
      transactions: transactions,
      budgets: budgets,
      settings: settings,
      now: now,
    );
    return buildZipBundleFromPayload(payload);
  }

  String buildAccountsCsv({
    required List<Account> accounts,
    required AppSettings settings,
  }) {
    return _CsvWriter().write(
      header: _accountsHeader,
      rows: _buildAccountsRows(accounts: accounts, settings: settings),
    );
  }

  String buildCategoriesCsv({
    required List<Category> categories,
  }) {
    return _CsvWriter().write(header: _categoriesHeader, rows: _buildCategoriesRows(categories: categories));
  }

  String buildBudgetsCsv({
    required List<Budget> budgets,
    required AppSettings settings,
  }) {
    return _CsvWriter().write(
      header: _budgetsHeader,
      rows: _buildBudgetsRows(budgets: budgets, settings: settings),
    );
  }

  String buildTransactionsCsv({
    required List<FinanceTransaction> transactions,
    required AppSettings settings,
  }) {
    return _CsvWriter().write(
      header: _transactionsHeader,
      rows: _buildTransactionsRows(transactions: transactions, settings: settings),
    );
  }

  static const List<String> _accountsHeader = <String>[
    'id',
    'name',
    'type',
    'account_currency_code',
    'opening_balance',
    'opening_balance_currency_code',
    'primary_currency_code',
    'institution',
    'note',
    'archived',
    'created_at',
    'updated_at',
  ];

  static const List<String> _categoriesHeader = <String>[
    'id',
    'name',
    'type',
    'parent_id',
    'icon_key',
    'color_hex',
    'archived',
    'created_at',
    'updated_at',
  ];

  static const List<String> _budgetsHeader = <String>[
    'id',
    'name',
    'amount',
    'currency_code',
    'primary_currency_code',
    'category_ids',
    'start_date',
    'end_date',
    'archived',
    'created_at',
    'updated_at',
  ];

  static const List<String> _transactionsHeader = <String>[
    'id',
    'type',
    'account_id',
    'to_account_id',
    'category_id',
    'budget_id',
    'amount',
    'currency_code',
    'primary_currency_code',
    'occurred_at',
    'title',
    'merchant',
    'reference',
    'note',
    'created_at',
    'updated_at',
  ];

  static List<Map<String, String>> _buildAccountsRows({
    required List<Account> accounts,
    required AppSettings settings,
  }) {
    return accounts
        .map((a) => <String, String>{
              'id': a.id,
              'name': a.name,
              'type': a.type.name,
              'account_currency_code': a.currencyCode,
              'opening_balance': _formatMajor(a.openingBalance),
              'opening_balance_currency_code': a.openingBalance.currencyCode,
              'primary_currency_code': settings.primaryCurrencyCode,
              'institution': a.institution ?? '',
              'note': a.note ?? '',
              'archived': a.archived ? 'true' : 'false',
              'created_at': _isoDate(a.createdAt),
              'updated_at': _isoDate(a.updatedAt),
            })
        .toList(growable: false);
  }

  static List<Map<String, String>> _buildCategoriesRows({
    required List<Category> categories,
  }) {
    return categories
        .map((c) => <String, String>{
              'id': c.id,
              'name': c.name,
              'type': c.type.name,
              'parent_id': c.parentId ?? '',
              'icon_key': c.iconKey ?? '',
              'color_hex': c.colorHex == null ? '' : _colorHex(c.colorHex!),
              'archived': c.archived ? 'true' : 'false',
              'created_at': _isoDate(c.createdAt),
              'updated_at': _isoDate(c.updatedAt),
            })
        .toList(growable: false);
  }

  static List<Map<String, String>> _buildBudgetsRows({
    required List<Budget> budgets,
    required AppSettings settings,
  }) {
    return budgets
        .map((b) => <String, String>{
              'id': b.id,
              'name': b.name,
              'amount': _formatMajor(b.amount),
              'currency_code': b.amount.currencyCode,
              'primary_currency_code': settings.primaryCurrencyCode,
              'category_ids': b.categoryIds.join(';'),
              'start_date': _isoDate(b.startDate),
              'end_date': _isoDate(b.endDate),
              'archived': b.archived ? 'true' : 'false',
              'created_at': _isoDate(b.createdAt),
              'updated_at': _isoDate(b.updatedAt),
            })
        .toList(growable: false);
  }

  static List<Map<String, String>> _buildTransactionsRows({
    required List<FinanceTransaction> transactions,
    required AppSettings settings,
  }) {
    return transactions
        .where(_isExecutedFact)
        .map((tx) {
          final signed = _signedAmount(tx);
          return <String, String>{
            'id': tx.id,
            'type': tx.type.name,
            'account_id': tx.accountId,
            'to_account_id': tx.toAccountId ?? '',
            'category_id': tx.categoryId ?? '',
            'budget_id': tx.budgetId ?? '',
            'amount': _formatMajor(signed),
            'currency_code': signed.currencyCode,
            'primary_currency_code': settings.primaryCurrencyCode,
            'occurred_at': _isoDate(tx.occurredAt),
            'title': tx.title ?? '',
            'merchant': tx.merchant ?? '',
            'reference': tx.reference ?? '',
            'note': tx.note ?? '',
            'created_at': _isoDate(tx.createdAt),
            'updated_at': _isoDate(tx.updatedAt),
          };
        })
        .toList(growable: false);
  }

  static bool _isExecutedFact(FinanceTransaction tx) {
    if (tx.status != TransactionStatus.posted) return false;
    // Recurring templates are not executed facts.
    if (tx.recurrenceType != null) return false;
    return true;
  }

  static Money _signedAmount(FinanceTransaction tx) {
    final minor = switch (tx.type) {
      TransactionType.expense => -tx.amount.amountMinor,
      TransactionType.income => tx.amount.amountMinor,
      TransactionType.transfer => tx.amount.amountMinor,
    };
    return Money(currencyCode: tx.amount.currencyCode, amountMinor: minor, scale: tx.amount.scale);
  }

  static ArchiveFile _utf8File(String name, String content) {
    final bytes = utf8.encode(content);
    return ArchiveFile(name, bytes.length, bytes);
  }

  static String _isoDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String _formatMajor(Money money) {
    final scale = money.scale;
    final minor = money.amountMinor;
    final isNegative = minor < 0;
    final absMinor = minor.abs();

    if (scale <= 0) {
      return isNegative ? '-$absMinor' : absMinor.toString();
    }

    final base = absMinor.toString().padLeft(scale + 1, '0');
    final intPart = base.substring(0, base.length - scale);
    final fracPart = base.substring(base.length - scale);
    final out = '$intPart.$fracPart';
    return isNegative ? '-$out' : out;
  }

  static String _colorHex(int value) {
    final v = value & 0xFFFFFFFF;
    return '0x${v.toRadixString(16).padLeft(8, '0')}';
  }
}

final class _CsvWriter {
  String write({required List<String> header, required List<Map<String, String>> rows}) {
    final sb = StringBuffer();
    sb.writeln(header.map(_escape).join(','));

    for (final row in rows) {
      final values = header.map((h) => _escape(row[h] ?? '')).join(',');
      sb.writeln(values);
    }

    return sb.toString();
  }

  String _escape(String value) {
    final needsQuotes = value.contains(',') || value.contains('"') || value.contains('\n') || value.contains('\r');
    if (!needsQuotes) return value;
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
