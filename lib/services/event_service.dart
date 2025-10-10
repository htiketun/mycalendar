import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';
import 'notification_service.dart';
import 'recurring_event_service.dart';

class EventService {
  static const String _eventsKey = 'calendar_events';
  static EventService? _instance;
  SharedPreferences? _prefs;

  EventService._();

  static EventService get instance {
    _instance ??= EventService._();
    return _instance!;
  }

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Get all events
  Future<List<Event>> getEvents() async {
    await init();
    final String? eventsJson = _prefs?.getString(_eventsKey);
    if (eventsJson == null) return [];

    final List<dynamic> eventsList = json.decode(eventsJson);
    return eventsList.map((eventMap) => Event.fromMap(eventMap)).toList();
  }

  // Add a new event
  Future<void> addEvent(Event event) async {
    final events = await getEvents();
    events.add(event);
    await _saveEvents(events);
    
    // Schedule notification reminder
    await NotificationService().scheduleEventReminder(event, event.reminder);
    
    // Schedule recurring reminders if applicable
    if (event.recurrence != RecurrenceType.never) {
      await NotificationService().scheduleRecurringEventReminders(event, event.reminder);
    }
  }

  // Update an existing event
  Future<void> updateEvent(Event updatedEvent) async {
    final events = await getEvents();
    final index = events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      // Cancel existing notifications
      await NotificationService().cancelEventReminder(updatedEvent.id);
      
      events[index] = updatedEvent;
      await _saveEvents(events);
      
      // Schedule new notification reminder
      await NotificationService().scheduleEventReminder(updatedEvent, updatedEvent.reminder);
      
      // Schedule recurring reminders if applicable
      if (updatedEvent.recurrence != RecurrenceType.never) {
        await NotificationService().scheduleRecurringEventReminders(updatedEvent, updatedEvent.reminder);
      }
    }
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    // Cancel notification first
    await NotificationService().cancelEventReminder(eventId);
    
    final events = await getEvents();
    events.removeWhere((event) => event.id == eventId);
    await _saveEvents(events);
  }

  // Get events for a specific month (including recurring events)
  Future<List<Event>> getEventsForMonth(int year, int month) async {
    final baseEvents = await getEvents();
    final allEvents = <Event>[];

    for (final event in baseEvents) {
      if (event.recurrence == RecurrenceType.never) {
        // Add non-recurring events that fall in this month
        if (event.date.year == year && event.date.month == month) {
          allEvents.add(event);
        }
      } else {
        // Generate recurring events for this month
        final recurringEvents = RecurringEventService().generateRecurringEventsForMonth(event, year, month);
        allEvents.addAll(recurringEvents);
      }
    }

    return allEvents;
  }

  // Get events for a specific date (including recurring events)
  Future<List<Event>> getEventsForDate(DateTime date) async {
    final baseEvents = await getEvents();
    final allEvents = <Event>[];

    for (final event in baseEvents) {
      if (event.recurrence == RecurrenceType.never) {
        // Add non-recurring events that match this date
        if (isSameDay(event.date, date)) {
          allEvents.add(event);
        }
      } else {
        // Check if this date is a recurring occurrence
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
        final recurringEvents = RecurringEventService().generateRecurringEvents(event, startOfDay, endOfDay);
        allEvents.addAll(recurringEvents);
      }
    }

    return allEvents;
  }

  // Save events to SharedPreferences
  Future<void> _saveEvents(List<Event> events) async {
    await init();
    final String eventsJson = json.encode(
      events.map((event) => event.toMap()).toList(),
    );
    await _prefs?.setString(_eventsKey, eventsJson);
  }

  // Helper method to check if two dates are the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Clear all events (useful for testing)
  Future<void> clearAllEvents() async {
    await init();
    await _prefs?.remove(_eventsKey);
  }
}// Commit 44: 2025-02-14T16:37:38
// Commit 167: 2025-03-23T00:06:10
// Commit 170: 2025-03-23T20:48:01
// Commit 37: 2025-02-12T15:25:35
// Commit 64: 2025-02-20T14:12:37
// Commit 83: 2025-02-26T04:45:27
// Commit 120: 2025-03-09T02:48:31
// Commit 163: 2025-03-21T19:35:57
// Commit 17: 2025-02-06T17:29:27
// Commit 18: 2025-02-07T01:14:40
// Commit 20: 2025-02-07T14:56:11
// Commit 26: 2025-02-09T09:54:52
// Commit 60: 2025-02-19T10:14:02
// Commit 88: 2025-02-27T16:44:23
// Commit 95: 2025-03-01T17:39:30
// Commit 130: 2025-03-12T01:44:29
// Commit 131: 2025-03-12T09:12:15
// Commit 136: 2025-03-13T20:00:36
// Commit 137: 2025-03-14T03:01:32
// Commit 145: 2025-03-16T11:32:30
// Commit 146: 2025-03-16T18:52:31
// Commit 165: 2025-03-22T10:02:17
// Commit 185: 2025-03-28T07:12:25
// Commit 189: 2025-03-29T11:44:24
// Commit 193: 2025-03-30T15:39:47
// Commit 194: 2025-03-30T22:51:22
// Commit 199: 2025-04-01T10:10:30
// Commit 4: 2025-02-02T21:56:17
// Commit 19: 2025-02-07T07:51:26
// Commit 33: 2025-02-11T10:54:56
// Commit 53: 2025-02-17T08:11:47
// Commit 70: 2025-02-22T09:25:57
// Commit 73: 2025-02-23T06:45:25
// Commit 74: 2025-02-23T13:37:32
// Commit 95: 2025-03-01T18:23:34
// Commit 115: 2025-03-07T15:53:51
// Commit 162: 2025-03-21T12:34:42
// Commit 167: 2025-03-22T23:45:12
// Commit 171: 2025-03-24T03:43:43
// Commit 182: 2025-03-27T10:07:01
// Commit 189: 2025-03-29T12:01:23
// Commit 5: 2025-02-03T04:52:55
// Commit 7: 2025-02-03T18:37:29
// Commit 18: 2025-02-07T00:54:37
// Commit 31: 2025-02-10T21:20:11
// Commit 39: 2025-02-13T05:04:08
// Commit 52: 2025-02-17T01:12:05
// Commit 59: 2025-02-19T03:23:41
// Commit 88: 2025-02-27T16:35:26
// Commit 89: 2025-02-27T23:40:33
// Commit 90: 2025-02-28T06:18:13
// Commit 101: 2025-03-03T12:07:41
// Commit 115: 2025-03-07T15:40:02
// Commit 128: 2025-03-11T11:36:17
// Commit 135: 2025-03-13T13:10:23
// Commit 136: 2025-03-13T20:05:24
// Commit 145: 2025-03-16T11:55:29
// Commit 146: 2025-03-16T19:33:24
// Commit 150: 2025-03-17T23:36:23
// Commit 152: 2025-03-18T13:51:18
// Commit 157: 2025-03-20T01:23:10
// Commit 172: 2025-03-24T11:00:46
// Commit 179: 2025-03-26T12:22:20
// Commit 188: 2025-03-29T04:18:42
// Commit 189: 2025-03-29T11:18:10
// Commit 196: 2025-03-31T12:38:26
// Commit 3: 2025-02-02T14:31:20
// Commit 12: 2025-02-05T06:10:12
// Commit 23: 2025-02-08T12:31:34
// Commit 48: 2025-02-15T21:07:58
// Commit 55: 2025-02-17T23:16:21
// Commit 73: 2025-02-23T06:25:44
// Commit 81: 2025-02-25T14:41:55
// Commit 85: 2025-02-26T19:20:55
// Commit 87: 2025-02-27T09:37:33
// Commit 92: 2025-02-28T21:02:35
// Commit 94: 2025-03-01T10:53:05
// Commit 108: 2025-03-05T14:33:25
// Commit 126: 2025-03-10T21:29:18
// Commit 144: 2025-03-16T05:15:19
// Commit 145: 2025-03-16T11:38:50
// Commit 161: 2025-03-21T05:41:56
// Commit 187: 2025-03-28T21:47:22
