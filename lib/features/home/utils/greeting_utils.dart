/// Time-based greeting helpers for the Home header.
///
/// Deterministic and testable: callers pass [now].
String timeOfDayGreetingPrefix(DateTime now) {
  final hour = now.hour;

  // Time ranges (exact):
  // 05:00 – 11:59 → “Good morning”
  // 12:00 – 16:59 → “Good afternoon”
  // 17:00 – 20:59 → “Good evening”
  // 21:00 – 04:59 → “Good night”
  if (hour >= 5 && hour <= 11) return 'Good morning';
  if (hour >= 12 && hour <= 16) return 'Good afternoon';
  if (hour >= 17 && hour <= 20) return 'Good evening';
  return 'Good night';
}

String buildHomeGreeting({required DateTime now, String? username}) {
  final prefix = timeOfDayGreetingPrefix(now);
  final name = (username ?? '').trim();
  if (name.isEmpty) return prefix;
  return '$prefix, $name';
}
