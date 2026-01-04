import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/drift/app_database.dart';

/// Singleton database instance for the app lifecycle.
///
/// - No autoDispose: lives for the ProviderContainer lifetime.
/// - Disposed cleanly when the container is disposed.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
