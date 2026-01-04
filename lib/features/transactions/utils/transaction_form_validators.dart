import '../../../data/models/money.dart';

String? validateRequiredId(String? id, String message) {
  if (id == null || id.trim().isEmpty) return message;
  return null;
}

String? validateAmountText(String input) {
  final normalized = input.trim().replaceAll(',', '');
  if (normalized.isEmpty) return 'Amount is required';

  final match = RegExp(r'^\d+(?:\.\d{0,2})?$').firstMatch(normalized);
  if (match == null) return 'Enter a valid amount';

  final value = double.tryParse(normalized);
  if (value == null) return 'Enter a valid amount';
  if (value <= 0) return 'Amount must be > 0';

  return null;
}

String? validateMoneyAmount(Money? amount) {
  if (amount == null) return 'Amount is required';
  if (amount.amountMinor <= 0) return 'Amount must be > 0';
  return null;
}

String? validateTransferAccounts({required String? fromAccountId, required String? toAccountId}) {
  final fromErr = validateRequiredId(fromAccountId, 'From account is required');
  if (fromErr != null) return fromErr;

  final toErr = validateRequiredId(toAccountId, 'To account is required');
  if (toErr != null) return toErr;

  if (fromAccountId == toAccountId) return 'From and To accounts must be different';
  return null;
}

Money? parseAmountToMoney({required String input, required String currencyCode}) {
  final normalized = input.trim().replaceAll(',', '');
  final match = RegExp(r'^\d+(?:\.\d{0,2})?$').firstMatch(normalized);
  if (match == null) return null;

  const scale = 2;
  final parts = normalized.split('.');
  final whole = int.tryParse(parts[0]) ?? 0;
  final frac = parts.length == 2 ? parts[1] : '';
  final fracPadded = frac.padRight(scale, '0');
  final fracMinor = int.tryParse(fracPadded) ?? 0;

  final minor = whole * 100 + fracMinor;
  return Money(
    currencyCode: currencyCode,
    amountMinor: minor,
    scale: scale,
  );
}
