import 'package:intl/intl.dart';

class DateStyleConverter {
  static String covertToDateStyle(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static String covertToTimeStyle(DateTime date) {
    final DateFormat formatter = DateFormat('jm');
    return formatter.format(date);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}
