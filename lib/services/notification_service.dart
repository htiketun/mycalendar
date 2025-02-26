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
}// Commit 17: 2025-02-06T18:02:56
// Commit 32: 2025-02-11T03:40:20
// Commit 52: 2025-02-17T01:14:22
// Commit 95: 2025-03-01T18:26:47
// Commit 168: 2025-03-23T07:18:37
// Commit 41: 2025-02-13T19:46:12
// Commit 52: 2025-02-17T01:29:46
// Commit 85: 2025-02-26T19:01:55
// Commit 117: 2025-03-08T06:16:04
// Commit 151: 2025-03-18T06:34:30
// Commit 167: 2025-03-23T00:01:46
// Commit 183: 2025-03-27T16:35:55
// Commit 186: 2025-03-28T13:57:12
// Commit 192: 2025-03-30T08:25:04
// Commit 1: 2025-02-02T00:22:10
// Commit 7: 2025-02-03T18:32:58
// Commit 9: 2025-02-04T09:38:21
// Commit 12: 2025-02-05T06:25:09
// Commit 15: 2025-02-06T04:04:25
// Commit 16: 2025-02-06T10:23:07
// Commit 24: 2025-02-08T19:36:22
// Commit 33: 2025-02-11T11:21:59
// Commit 50: 2025-02-16T11:02:46
// Commit 52: 2025-02-17T01:54:08
// Commit 58: 2025-02-18T20:12:55
// Commit 66: 2025-02-21T04:30:24
// Commit 99: 2025-03-02T22:17:08
// Commit 104: 2025-03-04T09:26:48
// Commit 129: 2025-03-11T19:01:49
// Commit 135: 2025-03-13T13:00:08
// Commit 140: 2025-03-15T01:03:05
// Commit 144: 2025-03-16T05:24:50
// Commit 147: 2025-03-17T02:31:35
// Commit 153: 2025-03-18T20:42:45
// Commit 178: 2025-03-26T05:10:42
// Commit 182: 2025-03-27T09:55:16
// Commit 26: 2025-02-09T09:31:38
// Commit 34: 2025-02-11T17:47:15
// Commit 42: 2025-02-14T03:05:38
// Commit 44: 2025-02-14T16:47:52
// Commit 52: 2025-02-17T01:19:20
// Commit 57: 2025-02-18T13:01:45
// Commit 60: 2025-02-19T09:46:32
// Commit 61: 2025-02-19T17:26:41
// Commit 65: 2025-02-20T21:08:52
// Commit 66: 2025-02-21T05:09:11
// Commit 76: 2025-02-24T03:25:31
// Commit 77: 2025-02-24T10:16:55
// Commit 80: 2025-02-25T08:09:56
// Commit 81: 2025-02-25T14:58:39
// Commit 102: 2025-03-03T19:41:39
// Commit 106: 2025-03-05T00:14:46
// Commit 125: 2025-03-10T14:01:13
// Commit 131: 2025-03-12T08:53:00
// Commit 132: 2025-03-12T16:00:02
// Commit 133: 2025-03-12T23:31:16
// Commit 142: 2025-03-15T14:32:57
// Commit 151: 2025-03-18T06:05:20
// Commit 158: 2025-03-20T07:37:17
// Commit 161: 2025-03-21T05:03:28
// Commit 170: 2025-03-23T20:33:30
// Commit 183: 2025-03-27T16:58:08
// Commit 194: 2025-03-30T23:01:49
// Commit 196: 2025-03-31T13:22:02
// Commit 2: 2025-02-02T07:48:32
// Commit 4: 2025-02-02T21:42:45
// Commit 8: 2025-02-04T01:47:36
// Commit 15: 2025-02-06T03:19:27
// Commit 20: 2025-02-07T14:40:59
// Commit 38: 2025-02-12T22:40:30
// Commit 49: 2025-02-16T04:33:46
// Commit 58: 2025-02-18T19:36:07
// Commit 67: 2025-02-21T11:35:49
// Commit 77: 2025-02-24T10:46:19
// Commit 82: 2025-02-25T21:52:44
// Commit 93: 2025-03-01T04:09:07
// Commit 181: 2025-03-27T02:48:54
// Commit 185: 2025-03-28T07:18:03
// Commit 198: 2025-04-01T03:08:38
// Commit 8: 2025-02-04T02:11:36
// Commit 33: 2025-02-11T11:15:19
// Commit 34: 2025-02-11T18:16:22
// Commit 36: 2025-02-12T08:43:04
// Commit 50: 2025-02-16T11:00:14
// Commit 53: 2025-02-17T08:48:56
// Commit 71: 2025-02-22T16:10:05
// Commit 72: 2025-02-22T23:35:26
// Commit 96: 2025-03-02T01:08:55
// Commit 109: 2025-03-05T21:37:24
// Commit 117: 2025-03-08T05:27:00
// Commit 136: 2025-03-13T20:22:45
// Commit 142: 2025-03-15T14:20:08
// Commit 173: 2025-03-24T18:17:50
// Commit 178: 2025-03-26T06:04:43
// Commit 190: 2025-03-29T18:09:52
// Commit 12: 2025-02-05T06:40:07
// Commit 26: 2025-02-09T09:20:28
// Commit 34: 2025-02-11T17:44:56
// Commit 36: 2025-02-12T07:51:46
// Commit 40: 2025-02-13T12:16:55
// Commit 44: 2025-02-14T17:19:11
// Commit 53: 2025-02-17T08:13:47
// Commit 57: 2025-02-18T13:10:59
// Commit 68: 2025-02-21T19:00:20
// Commit 71: 2025-02-22T16:31:13
// Commit 85: 2025-02-26T19:04:47
