import '../models/event.dart';

class RecurringEventService {
  static final RecurringEventService _instance = RecurringEventService._internal();
  factory RecurringEventService() => _instance;
  RecurringEventService._internal();

  /// Generate recurring events for a specific date range
  List<Event> generateRecurringEvents(Event baseEvent, DateTime startDate, DateTime endDate) {
    if (baseEvent.recurrence == RecurrenceType.never) {
      // Return the original event if it falls within the date range
      if (_isDateInRange(baseEvent.date, startDate, endDate)) {
        return [baseEvent];
      }
      return [];
    }

    final recurringEvents = <Event>[];
    var currentDate = baseEvent.date;
    int occurrenceCount = 0;
    const maxOccurrences = 1000; // Prevent infinite loops

    while (currentDate.isBefore(endDate) && occurrenceCount < maxOccurrences) {
      // Check if we've reached the recurrence end date
      if (baseEvent.recurrenceEndDate != null && currentDate.isAfter(baseEvent.recurrenceEndDate!)) {
        break;
      }

      // Add event if it's within our date range
      if (_isDateInRange(currentDate, startDate, endDate)) {
        final recurringEvent = _createRecurringEvent(baseEvent, currentDate, occurrenceCount);
        recurringEvents.add(recurringEvent);
      }

      // Move to next occurrence
      currentDate = _getNextOccurrence(currentDate, baseEvent.recurrence);
      occurrenceCount++;
    }

    return recurringEvents;
  }

  /// Generate recurring events for a specific month (optimized for calendar view)
  List<Event> generateRecurringEventsForMonth(Event baseEvent, int year, int month) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0); // Last day of the month
    return generateRecurringEvents(baseEvent, startDate, endDate);
  }

  /// Generate all upcoming occurrences of a recurring event (for upcoming events view)
  List<Event> generateUpcomingOccurrences(Event baseEvent, {int maxCount = 10}) {
    if (baseEvent.recurrence == RecurrenceType.never) {
      return baseEvent.date.isAfter(DateTime.now()) ? [baseEvent] : [];
    }

    final upcomingEvents = <Event>[];
    var currentDate = _getNextValidOccurrence(baseEvent);
    int occurrenceCount = 0;

    while (upcomingEvents.length < maxCount && occurrenceCount < 100) {
      // Check if we've reached the recurrence end date
      if (baseEvent.recurrenceEndDate != null && currentDate.isAfter(baseEvent.recurrenceEndDate!)) {
        break;
      }

      final recurringEvent = _createRecurringEvent(baseEvent, currentDate, occurrenceCount);
      upcomingEvents.add(recurringEvent);

      // Move to next occurrence
      currentDate = _getNextOccurrence(currentDate, baseEvent.recurrence);
      occurrenceCount++;
    }

    return upcomingEvents;
  }

  /// Get the next valid occurrence after today
  DateTime _getNextValidOccurrence(Event baseEvent) {
    var currentDate = baseEvent.date;
    final now = DateTime.now();

    // If the base event is in the future, return it
    if (currentDate.isAfter(now)) {
      return currentDate;
    }

    // Find the next occurrence after today
    while (currentDate.isBefore(now) || currentDate.isAtSameMomentAs(now)) {
      currentDate = _getNextOccurrence(currentDate, baseEvent.recurrence);
    }

    return currentDate;
  }

  /// Create a recurring event instance
  Event _createRecurringEvent(Event baseEvent, DateTime occurrenceDate, int occurrenceIndex) {
    // Create a unique ID for this occurrence
    final occurrenceId = '${baseEvent.id}_occurrence_${occurrenceDate.millisecondsSinceEpoch}';

    return baseEvent.copyWith(
      id: occurrenceId,
      date: occurrenceDate,
      startTime: baseEvent.startTime != null
          ? DateTime(
              occurrenceDate.year,
              occurrenceDate.month,
              occurrenceDate.day,
              baseEvent.startTime!.hour,
              baseEvent.startTime!.minute,
            )
          : null,
      endTime: baseEvent.endTime != null
          ? DateTime(
              occurrenceDate.year,
              occurrenceDate.month,
              occurrenceDate.day,
              baseEvent.endTime!.hour,
              baseEvent.endTime!.minute,
            )
          : null,
    );
  }

  /// Get the next occurrence date based on recurrence type
  DateTime _getNextOccurrence(DateTime currentDate, RecurrenceType recurrence) {
    switch (recurrence) {
      case RecurrenceType.daily:
        return currentDate.add(const Duration(days: 1));

      case RecurrenceType.weekly:
        return currentDate.add(const Duration(days: 7));

      case RecurrenceType.monthly:
        // Handle month boundaries correctly
        final nextMonth = currentDate.month == 12 ? 1 : currentDate.month + 1;
        final nextYear = currentDate.month == 12 ? currentDate.year + 1 : currentDate.year;
        
        // Handle cases where the day doesn't exist in the next month (e.g., Jan 31 -> Feb 28)
        final daysInNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        final nextDay = currentDate.day > daysInNextMonth ? daysInNextMonth : currentDate.day;
        
        return DateTime(
          nextYear,
          nextMonth,
          nextDay,
          currentDate.hour,
          currentDate.minute,
          currentDate.second,
        );

      case RecurrenceType.yearly:
        // Handle leap year edge case (Feb 29)
        var nextYear = currentDate.year + 1;
        var nextDay = currentDate.day;
        
        // If it's Feb 29 and next year is not a leap year, use Feb 28
        if (currentDate.month == 2 && currentDate.day == 29 && !_isLeapYear(nextYear)) {
          nextDay = 28;
        }
        
        return DateTime(
          nextYear,
          currentDate.month,
          nextDay,
          currentDate.hour,
          currentDate.minute,
          currentDate.second,
        );

      case RecurrenceType.never:
        return currentDate; // This shouldn't happen, but return the same date
    }
  }

  /// Check if a date falls within a range
  bool _isDateInRange(DateTime date, DateTime startDate, DateTime endDate) {
    return (date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
           (date.isBefore(endDate) || date.isAtSameMomentAs(endDate));
  }

  /// Check if a year is a leap year
  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Check if two events are part of the same recurring series
  bool areEventsInSameSeries(Event event1, Event event2) {
    // Extract base ID (remove occurrence suffix if present)
    final baseId1 = event1.id.contains('_occurrence_') 
        ? event1.id.split('_occurrence_')[0] 
        : event1.id;
    final baseId2 = event2.id.contains('_occurrence_') 
        ? event2.id.split('_occurrence_')[0] 
        : event2.id;
    
    return baseId1 == baseId2;
  }

  /// Get the base event ID from a recurring event
  String getBaseEventId(Event event) {
    return event.id.contains('_occurrence_') 
        ? event.id.split('_occurrence_')[0] 
        : event.id;
  }

  /// Check if an event is a recurring occurrence
  bool isRecurringOccurrence(Event event) {
    return event.id.contains('_occurrence_');
  }

  /// Calculate how many days between two recurrence dates
  int getDaysBetweenRecurrences(RecurrenceType recurrence) {
    switch (recurrence) {
      case RecurrenceType.daily:
        return 1;
      case RecurrenceType.weekly:
        return 7;
      case RecurrenceType.monthly:
        return 30; // Approximate
      case RecurrenceType.yearly:
        return 365; // Approximate
      case RecurrenceType.never:
        return 0;
    }
  }

  /// Get a human-readable description of the recurrence
  String getRecurrenceDescription(Event event) {
    if (event.recurrence == RecurrenceType.never) {
      return 'Does not repeat';
    }

    String pattern;
    switch (event.recurrence) {
      case RecurrenceType.daily:
        pattern = 'Daily';
        break;
      case RecurrenceType.weekly:
        pattern = 'Weekly';
        break;
      case RecurrenceType.monthly:
        pattern = 'Monthly';
        break;
      case RecurrenceType.yearly:
        pattern = 'Yearly';
        break;
      case RecurrenceType.never:
        pattern = 'Never';
        break;
    }

    if (event.recurrenceEndDate != null) {
      final endDate = event.recurrenceEndDate!;
      return '$pattern until ${endDate.day}/${endDate.month}/${endDate.year}';
    }

    return pattern;
  }
}// Commit 76: 2025-02-24T03:59:03
// Commit 79: 2025-02-25T00:30:58
// Commit 160: 2025-03-20T22:06:32
// Commit 100: 2025-03-03T05:17:05
// Commit 114: 2025-03-07T08:15:21
// Commit 172: 2025-03-24T11:19:30
// Commit 188: 2025-03-29T04:12:48
// Commit 200: 2025-04-01T17:22:00
// Commit 2: 2025-02-02T07:28:41
// Commit 19: 2025-02-07T08:21:38
// Commit 30: 2025-02-10T13:40:16
// Commit 62: 2025-02-20T00:01:02
// Commit 68: 2025-02-21T19:13:29
// Commit 70: 2025-02-22T09:23:58
// Commit 82: 2025-02-25T21:53:57
// Commit 84: 2025-02-26T12:04:11
// Commit 91: 2025-02-28T14:02:34
// Commit 97: 2025-03-02T07:58:40
// Commit 103: 2025-03-04T03:08:22
// Commit 111: 2025-03-06T10:54:58
// Commit 121: 2025-03-09T10:21:23
// Commit 161: 2025-03-21T05:40:51
// Commit 167: 2025-03-22T23:47:22
// Commit 174: 2025-03-25T01:20:17
// Commit 6: 2025-02-03T12:03:28
// Commit 10: 2025-02-04T16:21:01
// Commit 11: 2025-02-04T23:43:04
// Commit 25: 2025-02-09T02:01:47
// Commit 29: 2025-02-10T06:19:23
// Commit 30: 2025-02-10T13:30:10
// Commit 37: 2025-02-12T15:41:10
// Commit 84: 2025-02-26T12:31:25
// Commit 90: 2025-02-28T06:24:06
// Commit 91: 2025-02-28T13:50:15
// Commit 101: 2025-03-03T12:08:28
// Commit 104: 2025-03-04T09:16:07
// Commit 108: 2025-03-05T13:49:00
// Commit 120: 2025-03-09T03:30:50
// Commit 141: 2025-03-15T07:46:05
// Commit 148: 2025-03-17T09:02:12
// Commit 163: 2025-03-21T19:34:26
// Commit 172: 2025-03-24T11:20:58
// Commit 174: 2025-03-25T01:40:51
// Commit 176: 2025-03-25T15:14:30
// Commit 177: 2025-03-25T22:25:29
// Commit 198: 2025-04-01T02:57:04
// Commit 21: 2025-02-07T21:43:59
// Commit 35: 2025-02-12T01:16:09
// Commit 44: 2025-02-14T17:26:15
// Commit 51: 2025-02-16T18:36:03
// Commit 53: 2025-02-17T08:54:07
// Commit 57: 2025-02-18T13:06:02
// Commit 62: 2025-02-20T00:31:52
// Commit 66: 2025-02-21T04:55:07
// Commit 75: 2025-02-23T20:20:04
// Commit 81: 2025-02-25T14:44:25
// Commit 107: 2025-03-05T07:17:37
// Commit 125: 2025-03-10T14:49:48
// Commit 138: 2025-03-14T10:07:09
// Commit 166: 2025-03-22T16:23:23
// Commit 171: 2025-03-24T03:58:57
// Commit 1: 2025-02-02T00:52:58
// Commit 7: 2025-02-03T19:16:52
// Commit 26: 2025-02-09T09:40:38
// Commit 28: 2025-02-09T23:21:43
// Commit 31: 2025-02-10T21:22:45
// Commit 32: 2025-02-11T04:23:40
// Commit 40: 2025-02-13T12:25:13
// Commit 43: 2025-02-14T10:10:24
// Commit 51: 2025-02-16T18:01:27
// Commit 57: 2025-02-18T13:12:25
// Commit 58: 2025-02-18T19:53:07
// Commit 62: 2025-02-20T00:51:18
// Commit 86: 2025-02-27T02:45:15
// Commit 104: 2025-03-04T09:53:29
// Commit 105: 2025-03-04T17:04:58
// Commit 115: 2025-03-07T15:49:57
// Commit 118: 2025-03-08T12:46:13
// Commit 139: 2025-03-14T17:38:54
// Commit 153: 2025-03-18T20:38:22
// Commit 167: 2025-03-22T23:50:30
// Commit 168: 2025-03-23T06:38:21
// Commit 170: 2025-03-23T20:43:42
// Commit 171: 2025-03-24T04:01:11
// Commit 180: 2025-03-26T19:26:18
// Commit 7: 2025-02-03T18:31:22
// Commit 8: 2025-02-04T02:07:51
// Commit 29: 2025-02-10T06:32:35
// Commit 32: 2025-02-11T04:24:48
// Commit 37: 2025-02-12T15:19:03
// Commit 45: 2025-02-14T23:50:08
// Commit 48: 2025-02-15T21:20:48
// Commit 50: 2025-02-16T11:49:40
// Commit 51: 2025-02-16T18:22:50
// Commit 52: 2025-02-17T01:18:27
// Commit 70: 2025-02-22T08:49:14
// Commit 75: 2025-02-23T20:11:53
// Commit 76: 2025-02-24T03:54:35
// Commit 89: 2025-02-27T23:09:19
// Commit 115: 2025-03-07T15:47:23
// Commit 119: 2025-03-08T20:12:05
// Commit 125: 2025-03-10T14:49:21
// Commit 126: 2025-03-10T21:47:22
// Commit 165: 2025-03-22T09:10:24
// Commit 173: 2025-03-24T18:20:37
// Commit 188: 2025-03-29T04:33:04
// Commit 190: 2025-03-29T18:39:05
// Commit 196: 2025-03-31T12:51:27
