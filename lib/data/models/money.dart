import 'package:meta/meta.dart';

@immutable
final class Money {
  const Money({
    required this.currencyCode,
    required this.amountMinor,
    required this.scale,
  });

  /// ISO 4217 (e.g. USD, INR) or crypto code (e.g. BTC).
  final String currencyCode;

  /// Amount in minor units at [scale] precision.
  /// Example: $12.34 => amountMinor=1234, scale=2
  /// Example: 0.00001234 BTC => amountMinor=1234, scale=8
  final int amountMinor;

  /// Number of fractional digits represented in [amountMinor].
  final int scale;

  Money copyWith({
    String? currencyCode,
    int? amountMinor,
    int? scale,
  }) {
    return Money(
      currencyCode: currencyCode ?? this.currencyCode,
      amountMinor: amountMinor ?? this.amountMinor,
      scale: scale ?? this.scale,
    );
  }

  @override
  String toString() => 'Money($currencyCode, $amountMinor, scale=$scale)';

  @override
  bool operator ==(Object other) {
    return other is Money &&
        other.currencyCode == currencyCode &&
        other.amountMinor == amountMinor &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(currencyCode, amountMinor, scale);
}
