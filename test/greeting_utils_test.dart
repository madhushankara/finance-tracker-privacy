import 'package:flutter_test/flutter_test.dart';

import 'package:finance_tracker/features/home/utils/greeting_utils.dart';

void main() {
  group('timeOfDayGreetingPrefix', () {
    test('05:00–11:59 => Good morning', () {
      expect(
        timeOfDayGreetingPrefix(DateTime(2026, 1, 4, 5, 0)),
        'Good morning',
      );
      expect(
        timeOfDayGreetingPrefix(DateTime(2026, 1, 4, 11, 59)),
        'Good morning',
      );
    });

    test('12:00–16:59 => Good afternoon', () {
      expect(
        timeOfDayGreetingPrefix(DateTime(2026, 1, 4, 12, 0)),
        'Good afternoon',
      );
      expect(
        timeOfDayGreetingPrefix(DateTime(2026, 1, 4, 16, 59)),
        'Good afternoon',
      );
    });

    test('17:00–20:59 => Good evening', () {
      expect(
        timeOfDayGreetingPrefix(DateTime(2026, 1, 4, 17, 0)),
        'Good evening',
      );
      expect(
        timeOfDayGreetingPrefix(DateTime(2026, 1, 4, 20, 59)),
        'Good evening',
      );
    });

    test('21:00–04:59 => Good night', () {
      expect(
        timeOfDayGreetingPrefix(DateTime(2026, 1, 4, 21, 0)),
        'Good night',
      );
      expect(
        timeOfDayGreetingPrefix(DateTime(2026, 1, 4, 23, 59)),
        'Good night',
      );
      expect(timeOfDayGreetingPrefix(DateTime(2026, 1, 4, 0, 0)), 'Good night');
      expect(
        timeOfDayGreetingPrefix(DateTime(2026, 1, 4, 4, 59)),
        'Good night',
      );
    });
  });

  group('buildHomeGreeting', () {
    test('Logged out: prefix only', () {
      expect(
        buildHomeGreeting(now: DateTime(2026, 1, 4, 9, 0), username: null),
        'Good morning',
      );
    });

    test('Logged in: prefix + username', () {
      expect(
        buildHomeGreeting(
          now: DateTime(2026, 1, 4, 14, 0),
          username: 'kingkong',
        ),
        'Good afternoon, kingkong',
      );
    });

    test('Trims username and omits when empty', () {
      expect(
        buildHomeGreeting(
          now: DateTime(2026, 1, 4, 19, 0),
          username: '  King Kong  ',
        ),
        'Good evening, King Kong',
      );
      expect(
        buildHomeGreeting(now: DateTime(2026, 1, 4, 19, 0), username: '   '),
        'Good evening',
      );
    });
  });
}
