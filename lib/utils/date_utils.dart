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
}// Commit 43: 2025-02-14T09:49:12
// Commit 51: 2025-02-16T18:20:03
// Commit 56: 2025-02-18T05:24:53
// Commit 78: 2025-02-24T17:17:21
// Commit 94: 2025-03-01T11:05:21
// Commit 102: 2025-03-03T19:52:42
// Commit 109: 2025-03-05T20:38:50
// Commit 115: 2025-03-07T15:55:51
// Commit 166: 2025-03-22T16:28:21
// Commit 12: 2025-02-05T06:30:28
// Commit 24: 2025-02-08T19:19:56
// Commit 28: 2025-02-10T00:04:27
// Commit 51: 2025-02-16T18:13:21
// Commit 63: 2025-02-20T07:34:00
// Commit 99: 2025-03-02T22:37:50
// Commit 101: 2025-03-03T12:10:39
// Commit 116: 2025-03-07T22:15:37
// Commit 140: 2025-03-15T00:19:55
// Commit 4: 2025-02-02T21:34:30
// Commit 12: 2025-02-05T06:25:09
// Commit 23: 2025-02-08T11:49:40
// Commit 28: 2025-02-09T23:35:12
// Commit 39: 2025-02-13T05:06:21
// Commit 40: 2025-02-13T12:20:12
// Commit 41: 2025-02-13T19:12:27
// Commit 47: 2025-02-15T14:32:09
// Commit 55: 2025-02-17T22:30:18
// Commit 63: 2025-02-20T07:12:36
// Commit 65: 2025-02-20T21:46:22
// Commit 69: 2025-02-22T01:56:51
// Commit 70: 2025-02-22T09:23:58
// Commit 72: 2025-02-22T22:53:56
// Commit 81: 2025-02-25T15:21:47
// Commit 85: 2025-02-26T19:39:25
// Commit 86: 2025-02-27T02:25:28
// Commit 90: 2025-02-28T06:59:27
// Commit 92: 2025-02-28T20:23:39
// Commit 98: 2025-03-02T14:49:32
// Commit 100: 2025-03-03T05:19:45
// Commit 101: 2025-03-03T12:09:15
// Commit 104: 2025-03-04T09:26:48
// Commit 106: 2025-03-05T00:06:09
// Commit 107: 2025-03-05T06:52:41
// Commit 108: 2025-03-05T13:47:53
// Commit 113: 2025-03-07T01:38:54
// Commit 121: 2025-03-09T10:21:23
// Commit 126: 2025-03-10T21:40:24
// Commit 127: 2025-03-11T04:29:53
// Commit 134: 2025-03-13T06:13:44
// Commit 140: 2025-03-15T01:03:05
// Commit 141: 2025-03-15T07:15:34
// Commit 142: 2025-03-15T14:22:22
// Commit 148: 2025-03-17T08:46:08
// Commit 150: 2025-03-17T23:43:52
// Commit 152: 2025-03-18T14:03:35
// Commit 155: 2025-03-19T10:36:09
// Commit 156: 2025-03-19T17:33:03
// Commit 158: 2025-03-20T08:27:27
// Commit 162: 2025-03-21T11:57:29
// Commit 168: 2025-03-23T06:28:20
// Commit 171: 2025-03-24T04:12:46
// Commit 172: 2025-03-24T10:55:12
// Commit 174: 2025-03-25T01:20:17
// Commit 177: 2025-03-25T22:13:50
// Commit 184: 2025-03-27T23:55:37
// Commit 190: 2025-03-29T18:38:08
// Commit 191: 2025-03-30T01:14:41
// Commit 195: 2025-03-31T05:54:55
// Commit 198: 2025-04-01T02:57:34
// Commit 2: 2025-02-02T07:14:23
// Commit 3: 2025-02-02T14:37:35
// Commit 5: 2025-02-03T04:25:24
// Commit 9: 2025-02-04T08:39:17
// Commit 10: 2025-02-04T16:21:01
// Commit 13: 2025-02-05T13:12:42
// Commit 16: 2025-02-06T10:34:47
// Commit 18: 2025-02-07T00:27:25
// Commit 23: 2025-02-08T12:34:06
// Commit 26: 2025-02-09T09:31:38
// Commit 27: 2025-02-09T16:43:21
// Commit 28: 2025-02-09T23:38:56
// Commit 35: 2025-02-12T00:55:40
// Commit 40: 2025-02-13T12:55:26
// Commit 43: 2025-02-14T09:28:25
// Commit 46: 2025-02-15T06:46:41
// Commit 47: 2025-02-15T13:42:31
// Commit 48: 2025-02-15T21:22:59
// Commit 55: 2025-02-17T22:45:57
// Commit 58: 2025-02-18T20:01:21
// Commit 63: 2025-02-20T07:16:33
// Commit 66: 2025-02-21T05:09:11
// Commit 67: 2025-02-21T11:43:13
// Commit 70: 2025-02-22T09:25:57
// Commit 76: 2025-02-24T03:25:31
// Commit 79: 2025-02-25T00:14:48
// Commit 80: 2025-02-25T08:09:56
// Commit 81: 2025-02-25T14:58:39
// Commit 96: 2025-03-02T01:33:53
// Commit 99: 2025-03-02T22:14:23
// Commit 101: 2025-03-03T12:08:28
// Commit 105: 2025-03-04T17:16:32
// Commit 107: 2025-03-05T07:01:14
// Commit 118: 2025-03-08T12:52:30
// Commit 120: 2025-03-09T03:30:50
// Commit 121: 2025-03-09T09:44:40
// Commit 122: 2025-03-09T17:29:29
// Commit 123: 2025-03-10T00:19:46
// Commit 124: 2025-03-10T07:07:51
// Commit 125: 2025-03-10T14:01:13
// Commit 126: 2025-03-10T21:36:05
// Commit 132: 2025-03-12T16:00:02
// Commit 135: 2025-03-13T13:12:40
// Commit 138: 2025-03-14T10:00:18
// Commit 145: 2025-03-16T12:29:28
// Commit 147: 2025-03-17T02:10:17
// Commit 152: 2025-03-18T13:57:25
// Commit 155: 2025-03-19T10:23:26
// Commit 165: 2025-03-22T09:14:39
// Commit 166: 2025-03-22T16:37:37
// Commit 172: 2025-03-24T11:20:58
// Commit 175: 2025-03-25T08:53:11
// Commit 180: 2025-03-26T19:43:19
// Commit 181: 2025-03-27T03:07:39
// Commit 184: 2025-03-27T23:52:43
// Commit 188: 2025-03-29T04:39:08
// Commit 192: 2025-03-30T08:19:11
// Commit 194: 2025-03-30T23:01:49
// Commit 195: 2025-03-31T06:13:43
// Commit 196: 2025-03-31T13:22:02
// Commit 199: 2025-04-01T10:20:55
// Commit 200: 2025-04-01T17:14:53
// Commit 7: 2025-02-03T18:37:29
// Commit 9: 2025-02-04T08:48:16
// Commit 16: 2025-02-06T10:53:57
// Commit 21: 2025-02-07T21:43:59
// Commit 23: 2025-02-08T11:58:09
// Commit 33: 2025-02-11T10:59:15
// Commit 38: 2025-02-12T22:40:30
// Commit 45: 2025-02-14T23:53:06
// Commit 48: 2025-02-15T21:21:40
// Commit 55: 2025-02-17T22:35:52
// Commit 65: 2025-02-20T21:31:06
// Commit 66: 2025-02-21T04:55:07
// Commit 68: 2025-02-21T18:25:29
// Commit 75: 2025-02-23T20:20:04
// Commit 76: 2025-02-24T03:05:12
// Commit 78: 2025-02-24T18:01:11
// Commit 83: 2025-02-26T04:34:20
// Commit 85: 2025-02-26T19:21:28
// Commit 87: 2025-02-27T09:34:30
// Commit 89: 2025-02-27T23:40:33
// Commit 98: 2025-03-02T15:40:24
// Commit 100: 2025-03-03T05:43:22
// Commit 110: 2025-03-06T04:41:41
// Commit 111: 2025-03-06T11:20:45
// Commit 113: 2025-03-07T01:07:24
// Commit 120: 2025-03-09T03:21:42
// Commit 122: 2025-03-09T16:42:12
// Commit 130: 2025-03-12T01:38:10
// Commit 134: 2025-03-13T06:34:17
// Commit 135: 2025-03-13T13:10:23
// Commit 138: 2025-03-14T10:07:09
// Commit 147: 2025-03-17T01:43:32
// Commit 151: 2025-03-18T06:21:08
// Commit 163: 2025-03-21T19:15:06
// Commit 164: 2025-03-22T02:28:00
// Commit 166: 2025-03-22T16:23:23
// Commit 170: 2025-03-23T20:43:23
// Commit 172: 2025-03-24T11:00:46
// Commit 174: 2025-03-25T00:56:32
// Commit 175: 2025-03-25T08:23:15
// Commit 182: 2025-03-27T10:24:48
// Commit 183: 2025-03-27T16:40:46
// Commit 189: 2025-03-29T11:18:10
// Commit 193: 2025-03-30T15:47:13
// Commit 197: 2025-03-31T20:02:10
// Commit 199: 2025-04-01T10:07:46
// Commit 2: 2025-02-02T07:19:28
// Commit 4: 2025-02-02T21:56:01
// Commit 12: 2025-02-05T06:10:12
// Commit 13: 2025-02-05T13:56:58
// Commit 15: 2025-02-06T03:44:55
// Commit 16: 2025-02-06T10:56:03
// Commit 21: 2025-02-07T22:23:44
// Commit 29: 2025-02-10T06:53:26
// Commit 33: 2025-02-11T11:15:19
// Commit 35: 2025-02-12T01:00:52
// Commit 40: 2025-02-13T12:25:13
// Commit 42: 2025-02-14T02:25:36
// Commit 44: 2025-02-14T16:40:01
// Commit 48: 2025-02-15T21:07:58
// Commit 55: 2025-02-17T23:16:21
// Commit 59: 2025-02-19T03:26:19
// Commit 60: 2025-02-19T10:26:23
// Commit 63: 2025-02-20T07:23:54
// Commit 68: 2025-02-21T18:35:43
// Commit 71: 2025-02-22T16:10:05
// Commit 91: 2025-02-28T13:49:21
// Commit 93: 2025-03-01T04:15:37
// Commit 94: 2025-03-01T10:53:05
// Commit 100: 2025-03-03T05:38:32
// Commit 101: 2025-03-03T12:49:53
// Commit 102: 2025-03-03T19:51:52
// Commit 104: 2025-03-04T09:53:29
// Commit 106: 2025-03-05T00:17:20
// Commit 107: 2025-03-05T06:44:40
// Commit 108: 2025-03-05T14:33:25
// Commit 111: 2025-03-06T11:01:24
// Commit 117: 2025-03-08T05:27:00
// Commit 121: 2025-03-09T09:51:31
// Commit 132: 2025-03-12T15:49:35
// Commit 135: 2025-03-13T13:21:51
// Commit 142: 2025-03-15T14:20:08
// Commit 149: 2025-03-17T16:01:16
// Commit 166: 2025-03-22T16:19:03
// Commit 168: 2025-03-23T06:38:21
// Commit 172: 2025-03-24T10:44:29
// Commit 173: 2025-03-24T18:17:50
// Commit 178: 2025-03-26T06:04:43
// Commit 183: 2025-03-27T17:08:09
// Commit 189: 2025-03-29T11:54:34
// Commit 190: 2025-03-29T18:09:52
// Commit 194: 2025-03-30T22:26:54
// Commit 200: 2025-04-01T17:01:21
// Commit 5: 2025-02-03T05:00:17
// Commit 14: 2025-02-05T20:32:22
// Commit 15: 2025-02-06T03:50:54
// Commit 20: 2025-02-07T15:01:11
// Commit 27: 2025-02-09T16:25:55
// Commit 29: 2025-02-10T06:32:35
// Commit 32: 2025-02-11T04:24:48
// Commit 33: 2025-02-11T11:10:28
// Commit 35: 2025-02-12T01:33:03
// Commit 37: 2025-02-12T15:19:03
// Commit 48: 2025-02-15T21:20:48
// Commit 50: 2025-02-16T11:49:40
// Commit 57: 2025-02-18T13:10:59
// Commit 59: 2025-02-19T03:10:46
// Commit 63: 2025-02-20T07:02:02
// Commit 79: 2025-02-25T00:57:08
