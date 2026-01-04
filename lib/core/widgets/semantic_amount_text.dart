import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../formatting/money_format.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/enums.dart';
import '../../data/models/money.dart';
import '../../features/settings/providers/settings_providers.dart';

final class SemanticAmountText extends ConsumerWidget {
  const SemanticAmountText({
    super.key,
    required this.type,
    required this.amount,
    this.style,
    this.textAlign,
    this.includeCurrencyCode = false,
    this.locale,
    this.settings,
  });

  /// Semantic type for coloring/sign.
  ///
  /// When null, falls back to sign-based semantics (positive=credit, negative=debit, zero=neutral).
  final TransactionType? type;
  final Money amount;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool includeCurrencyCode;
  final String? locale;
  final AppSettings? settings;

  static const Color _creditGreen = Color(0xFF1B5E20);
  static const Color _debitRed = Color(0xFFB71C1C);
  static const Color _neutralGray = Color(0xFF616161);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseStyle = style ?? DefaultTextStyle.of(context).style;

    final AppSettings effectiveSettings =
        settings ?? ref.watch(appSettingsProvider);

    final rawNumeric = formatMoney(
      amount,
      includeCurrencyCode: false,
      locale: locale,
      settings: effectiveSettings,
    );

    final moneyHasNegativeSign = rawNumeric.startsWith('-');
    final numeric = moneyHasNegativeSign ? rawNumeric.substring(1) : rawNumeric;

    final semanticType = type;

    final explicitSign = switch (semanticType) {
      TransactionType.expense => '-',
      TransactionType.income => '+',
      TransactionType.transfer => moneyHasNegativeSign ? '-' : '',
      null => moneyHasNegativeSign ? '-' : '',
    };

    final Color numericColor = switch (semanticType) {
      TransactionType.expense => _debitRed,
      TransactionType.income => _creditGreen,
      TransactionType.transfer => _neutralGray,
      null =>
        amount.amountMinor == 0
            ? _neutralGray
            : (amount.amountMinor > 0 ? _creditGreen : _debitRed),
    };

    final spans = <InlineSpan>[
      if (explicitSign.isNotEmpty)
        TextSpan(
          text: explicitSign,
          style: baseStyle.copyWith(color: numericColor),
        ),
      if (includeCurrencyCode) ...<InlineSpan>[
        TextSpan(
          text: amount.currencyCode,
          style: baseStyle.copyWith(color: numericColor),
        ),
        TextSpan(
          text: ' ',
          style: baseStyle.copyWith(color: numericColor),
        ),
      ],
      TextSpan(
        text: numeric,
        style: baseStyle.copyWith(color: numericColor),
      ),
    ];

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(style: baseStyle, children: spans),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
