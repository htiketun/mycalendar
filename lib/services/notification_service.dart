import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import '../models/event.dart';

enum ReminderDuration {
  never,
  fifteenMinutes,
  thirtyMinutes,
  oneHour,
  twoHours,
  oneDay,
  twoDays,
  oneWeek,
}

class ReminderDurationHelper {
  static const Map<ReminderDuration, String> names = {
    ReminderDuration.never: 'Never',
    ReminderDuration.fifteenMinutes: '15 minutes before',
    ReminderDuration.thirtyMinutes: '30 minutes before',
    ReminderDuration.oneHour: '1 hour before',
    ReminderDuration.twoHours: '2 hours before',
    ReminderDuration.oneDay: '1 day before',
    ReminderDuration.twoDays: '2 days before',
    ReminderDuration.oneWeek: '1 week before',
  };

  static const Map<ReminderDuration, Duration> durations = {
    ReminderDuration.never: Duration.zero,
    ReminderDuration.fifteenMinutes: Duration(minutes: 15),
    ReminderDuration.thirtyMinutes: Duration(minutes: 30),
    ReminderDuration.oneHour: Duration(hours: 1),
    ReminderDuration.twoHours: Duration(hours: 2),
    ReminderDuration.oneDay: Duration(days: 1),
    ReminderDuration.twoDays: Duration(days: 2),
    ReminderDuration.oneWeek: Duration(days: 7),
  };

  static String getName(ReminderDuration duration) {
    return names[duration] ?? 'Never';
  }

  static Duration getDuration(ReminderDuration duration) {
    return durations[duration] ?? Duration.zero;
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Skip initialization on web platform
    if (kIsWeb) {
      _initialized = true;
      if (kDebugMode) {
        print('Notifications not supported on web platform');
      }
      return;
    }

    try {
      // Initialize timezone
      tz.initializeTimeZones();
      
      // Android initialization settings
      const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // iOS initialization settings
      const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Initialization settings
      const InitializationSettings initSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: iosInitSettings,
      );

      // Initialize
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permissions for Android 13+
      if (Platform.isAndroid) {
        await _notifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize notifications: $e');
      }
      _initialized = true; // Mark as initialized to prevent repeated attempts
    }
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
    // TODO: Navigate to event details or calendar
  }

  // Schedule notification for an event
  Future<void> scheduleEventReminder(Event event, ReminderDuration reminderDuration) async {
    if (!_initialized) await initialize();
    
    // Skip on web platform
    if (kIsWeb) return;
    
    if (reminderDuration == ReminderDuration.never) return;

    try {
      final reminderTime = _calculateReminderTime(event, reminderDuration);
      if (reminderTime.isBefore(DateTime.now())) return; // Don't schedule past reminders

      final notificationId = event.id.hashCode;
      
      await _notifications.zonedSchedule(
        notificationId,
        _getNotificationTitle(event),
        _getNotificationBody(event, reminderDuration),
        tz.TZDateTime.from(reminderTime, tz.local),
        _getNotificationDetails(event),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: event.id,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to schedule notification for event ${event.id}: $e');
      }
    }
  }

  // Cancel notification for an event
  Future<void> cancelEventReminder(String eventId) async {
    if (!_initialized) await initialize();
    
    // Skip on web platform
    if (kIsWeb) return;
    
    try {
      final notificationId = eventId.hashCode;
      await _notifications.cancel(notificationId);
    } catch (e) {
      if (kDebugMode) {
        print('Failed to cancel notification for event $eventId: $e');
      }
    }
  }

  // Cancel all notifications
  Future<void> cancelAllReminders() async {
    if (!_initialized) await initialize();
    
    // Skip on web platform
    if (kIsWeb) return;
    
    try {
      await _notifications.cancelAll();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to cancel all notifications: $e');
      }
    }
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingReminders() async {
    if (!_initialized) await initialize();
    
    // Return empty list on web platform
    if (kIsWeb) return [];
    
    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get pending notifications: $e');
      }
      return [];
    }
  }

  // Schedule reminder for recurring events
  Future<void> scheduleRecurringEventReminders(Event event, ReminderDuration reminderDuration, {int maxOccurrences = 10}) async {
    if (!_initialized) await initialize();
    
    // Skip on web platform
    if (kIsWeb) return;
    
    if (reminderDuration == ReminderDuration.never || event.recurrence == RecurrenceType.never) return;

    try {
      final occurrences = _generateRecurringOccurrences(event, maxOccurrences);
      
      for (int i = 0; i < occurrences.length; i++) {
        final occurrenceEvent = event.copyWith(
          id: '${event.id}_occurrence_$i',
          date: occurrences[i],
        );
        
        await scheduleEventReminder(occurrenceEvent, reminderDuration);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to schedule recurring notifications for event ${event.id}: $e');
      }
    }
  }

  // Generate recurring event occurrences
  List<DateTime> _generateRecurringOccurrences(Event event, int maxOccurrences) {
    final occurrences = <DateTime>[];
    var currentDate = event.date;
    final now = DateTime.now();
    
    for (int i = 0; i < maxOccurrences; i++) {
      if (currentDate.isAfter(now)) {
        occurrences.add(currentDate);
      }
      
      switch (event.recurrence) {
        case RecurrenceType.daily:
          currentDate = currentDate.add(const Duration(days: 1));
          break;
        case RecurrenceType.weekly:
          currentDate = currentDate.add(const Duration(days: 7));
          break;
        case RecurrenceType.monthly:
          currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
          break;
        case RecurrenceType.yearly:
          currentDate = DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
          break;
        case RecurrenceType.never:
          break;
      }
      
      // Stop if we've reached the recurrence end date
      if (event.recurrenceEndDate != null && currentDate.isAfter(event.recurrenceEndDate!)) {
        break;
      }
    }
    
    return occurrences;
  }

  // Calculate reminder time
  DateTime _calculateReminderTime(Event event, ReminderDuration reminderDuration) {
    final reminderDurationTime = ReminderDurationHelper.getDuration(reminderDuration);
    
    if (event.isAllDay) {
      // For all-day events, remind at 9 AM on the day (or earlier based on reminder)
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day, 9, 0);
      return eventDate.subtract(reminderDurationTime);
    } else {
      // For timed events, remind before the start time
      final startTime = event.startTime ?? event.date;
      return startTime.subtract(reminderDurationTime);
    }
  }

  // Get notification title
  String _getNotificationTitle(Event event) {
    return event.title;
  }

  // Get notification body
  String _getNotificationBody(Event event, ReminderDuration reminderDuration) {
    final reminderText = ReminderDurationHelper.getName(reminderDuration);
    final categoryName = event.categoryName;
    
    String body = '';
    
    if (event.isAllDay) {
      body = 'Today • $categoryName';
    } else if (event.startTime != null) {
      final timeFormat = event.startTime!.hour == 0 && event.startTime!.minute == 0 
          ? 'All day' 
          : '${event.startTime!.hour.toString().padLeft(2, '0')}:${event.startTime!.minute.toString().padLeft(2, '0')}';
      body = '$timeFormat • $categoryName';
    }
    
    if (event.location != null && event.location!.isNotEmpty) {
      body += ' • ${event.location}';
    }
    
    return body;
  }

  // Get notification details
  NotificationDetails _getNotificationDetails(Event event) {
    final categoryColor = event.categoryColor;
    
    final androidDetails = AndroidNotificationDetails(
      'event_reminders',
      'Event Reminders',
      channelDescription: 'Notifications for upcoming calendar events',
      importance: Importance.high,
      priority: Priority.high,
      color: categoryColor,
      icon: '@mipmap/ic_launcher',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(
        _getNotificationBody(event, ReminderDuration.never),
        contentTitle: event.title,
        summaryText: event.categoryName,
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    return NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  // Show immediate notification (for testing)
  Future<void> showTestNotification() async {
    if (!_initialized) await initialize();
    
    // Skip on web platform
    if (kIsWeb) {
      if (kDebugMode) {
        print('Test notification: This would show a notification on mobile platforms');
      }
      return;
    }
    
    try {
      await _notifications.show(
        999,
        'Test Notification',
        'This is a test notification from Arcade Calendar',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'Test Channel',
            channelDescription: 'Test notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to show test notification: $e');
      }
    }
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (!_initialized) await initialize();
    
    // Return false on web platform
    if (kIsWeb) return false;
    
    try {
      if (Platform.isAndroid) {
        final androidImplementation = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        return await androidImplementation?.areNotificationsEnabled() ?? false;
      }
      
      if (Platform.isIOS) {
        final iosImplementation = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
        return await iosImplementation?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ?? false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to check notification permissions: $e');
      }
    }
    
    return false;
  }

  // Request notification permissions
  Future<bool> requestPermissions() async {
    if (!_initialized) await initialize();
    
    // Return false on web platform
    if (kIsWeb) return false;
    
    try {
      if (Platform.isAndroid) {
        final androidImplementation = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        return await androidImplementation?.requestNotificationsPermission() ?? false;
      }
      
      if (Platform.isIOS) {
        final iosImplementation = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
        return await iosImplementation?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ?? false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to request notification permissions: $e');
      }
    }
    
    return false;
  }
}
