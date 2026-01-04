import 'package:intl/intl.dart';

import '../../data/models/app_settings.dart';
import '../../data/models/money.dart';

String formatMoney(
  Money money, {
  String? locale,
  bool includeCurrencyCode = true,
  AppSettings? settings,
}) {
  final effectiveSettings = settings ?? AppSettings.defaults;
  final converted = _convertForDisplay(
    money,
    targetCurrencyCode: effectiveSettings.primaryCurrencyCode,
  );

  final isNegative = converted.amountMinor < 0;
  final absMinor = converted.amountMinor.abs();

  final scale = converted.scale;
  final digits = absMinor.toString().padLeft(scale + 1, '0');

  final intPartRaw = scale == 0
      ? digits
      : digits.substring(0, digits.length - scale);
  final fracPart = scale == 0 ? '' : digits.substring(digits.length - scale);

  final intPart = effectiveSettings.useGrouping
      ? NumberFormat.decimalPattern(locale).format(int.parse(intPartRaw))
      : intPartRaw;

  final decimal = switch (effectiveSettings.decimalSeparator) {
    DecimalSeparator.dot => '.',
    DecimalSeparator.comma => ',',
  };

  final amount = scale == 0 ? intPart : '$intPart$decimal$fracPart';
  final signed = isNegative ? '-$amount' : amount;

  if (!includeCurrencyCode) return signed;

  // Keep formatting intentionally simple and deterministic: show the currency code.
  return '${converted.currencyCode} $signed';
}

// Fixed conversion rates (hardcoded for now).
// Baseline: INR.
// 1 USD = 84 INR
// 1 EUR = 90 INR
Money _convertForDisplay(Money money, {required String targetCurrencyCode}) {
  final source = money.currencyCode.toUpperCase();
  final target = targetCurrencyCode.toUpperCase();

  // Keep it safe: conversion is only supported for scale=2 currencies.
  if (money.scale != 2) return money;
  if (source == target) return money;

  const toInrRate = <String, int>{'INR': 1, 'USD': 84, 'EUR': 90};

  final srcRate = toInrRate[source];
  final tgtRate = toInrRate[target];
  if (srcRate == null || tgtRate == null) return money;

  // Convert source minor units to INR minor units.
  // Because all supported currencies use scale=2, minor-unit conversion follows the same ratio.
  final inrMinor = money.amountMinor * srcRate;

  // Convert INR minor units to target minor units using integer rounding.
  final convertedMinor = _roundDiv(inrMinor, tgtRate);

  return Money(currencyCode: target, amountMinor: convertedMinor, scale: 2);
}

int _roundDiv(int numerator, int denominator) {
  if (denominator == 0) throw StateError('Division by zero');
  if (numerator == 0) return 0;
  final sign = numerator.isNegative ? -1 : 1;
  final n = numerator.abs();
  final rounded = (n + (denominator ~/ 2)) ~/ denominator;
  return rounded * sign;
}
