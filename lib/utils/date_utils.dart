import 'package:intl/intl.dart';

class DateUtils {
  // Get the first day of the month
  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get the last day of the month
  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  // Get the number of days in a month
  static int getDaysInMonth(DateTime date) {
    return getLastDayOfMonth(date).day;
  }

  // Get the first day of the week for the calendar grid
  static DateTime getFirstDayOfWeek(DateTime date) {
    final firstDayOfMonth = getFirstDayOfMonth(date);
    final weekday = firstDayOfMonth.weekday;
    // Adjust for Monday as first day of week (weekday 1)
    return firstDayOfMonth.subtract(Duration(days: weekday - 1));
  }

  // Get the last day of the week for the calendar grid
  static DateTime getLastDayOfWeek(DateTime date) {
    final lastDayOfMonth = getLastDayOfMonth(date);
    final weekday = lastDayOfMonth.weekday;
    // Adjust to get Sunday (weekday 7)
    return lastDayOfMonth.add(Duration(days: 7 - weekday));
  }

  // Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Check if a date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  // Check if a date is in the current month
  static bool isInCurrentMonth(DateTime date, DateTime currentMonth) {
    return date.year == currentMonth.year && date.month == currentMonth.month;
  }

  // Format date as "Mon, Jan 1"
  static String formatDateShort(DateTime date) {
    return DateFormat('E, MMM d').format(date);
  }

  // Format date as "January 1, 2023"
  static String formatDateLong(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  // Format month and year as "January 2023"
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM y').format(date);
  }

  // Get the previous month
  static DateTime getPreviousMonth(DateTime date) {
    return DateTime(date.year, date.month - 1, 1);
  }

  // Get the next month
  static DateTime getNextMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 1);
  }

  // Get all days to display in the calendar grid (6 weeks)
  static List<DateTime> getCalendarDays(DateTime month) {
    final firstDay = getFirstDayOfWeek(month);
    final List<DateTime> days = [];
    
    for (int i = 0; i < 42; i++) { // 6 weeks * 7 days
      days.add(firstDay.add(Duration(days: i)));
    }
    
    return days;
  }

  // Get week days starting from Monday
  static List<String> getWeekDays() {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }

  // Get month names
  static List<String> getMonthNames() {
    return [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
  }

  // Check if a year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  // Get the day of year (1-366)
  static int getDayOfYear(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    return date.difference(startOfYear).inDays + 1;
  }

  // Get the week number of the year
  static int getWeekOfYear(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final firstMonday = startOfYear.add(Duration(days: (8 - startOfYear.weekday) % 7));
    
    if (date.isBefore(firstMonday)) {
      return getWeekOfYear(DateTime(date.year - 1, 12, 31));
    }
    
    return ((date.difference(firstMonday).inDays) / 7).floor() + 1;
  }
}
