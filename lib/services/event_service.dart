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
}
