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
}
