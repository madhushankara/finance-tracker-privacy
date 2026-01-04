import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/material_you_support.dart';
import '../../../data/models/account.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/providers/repository_providers.dart';

final appSettingsStreamProvider = StreamProvider<AppSettings>((ref) {
  return ref.watch(appSettingsRepositoryProvider).watch();
});

/// Synchronous-friendly access: returns defaults while loading/error.
final appSettingsProvider = Provider<AppSettings>((ref) {
  final settings = ref.watch(appSettingsStreamProvider);
  return settings.value ?? AppSettings.defaults;
});

final settingsCurrencyOptionsProvider = StreamProvider<List<String>>((ref) {
  return ref
      .watch(accountRepositoryProvider)
      .watchAll()
      .map((accounts) => _currencyOptionsFromAccounts(accounts));
});

final materialYouSupportProvider = FutureProvider<bool>((ref) {
  return MaterialYouSupport.isSupported();
});

List<String> _currencyOptionsFromAccounts(List<Account> accounts) {
  final codes = <String>{
    // Always include a small safe baseline.
    'USD',
    'EUR',
    'INR',
  };

  for (final a in accounts) {
    final code = a.currencyCode.trim();
    if (code.isNotEmpty) codes.add(code);
  }

  final list = codes.toList(growable: false)..sort();
  return list;
}
