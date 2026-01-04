import 'package:flutter/material.dart';

import '../../../data/models/enums.dart';

final class AccountTypeIcon extends StatelessWidget {
  const AccountTypeIcon({super.key, required this.type, this.size = 22});

  final AccountType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Icon(_iconFor(type), size: size, color: cs.onSurface.withValues(alpha: 0.9));
  }
}

IconData _iconFor(AccountType type) {
  return switch (type) {
    AccountType.cash => Icons.payments_outlined,
    AccountType.bank => Icons.account_balance_outlined,
    AccountType.credit => Icons.credit_card_outlined,
    AccountType.crypto => Icons.currency_bitcoin_outlined,
  };
}
