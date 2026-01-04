abstract class DemoDataRepository {
  /// Seeds demo data for the hidden demo credentials (kingkong/kavin).
  ///
  /// Must be safe to call multiple times.
  Future<void> seedIfNeeded();
}
