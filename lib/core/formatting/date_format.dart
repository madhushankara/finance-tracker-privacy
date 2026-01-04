import 'package:intl/intl.dart';

String formatHomeDate(DateTime date, {String? locale}) {
  return DateFormat('EEE, d MMM', locale).format(date);
}
