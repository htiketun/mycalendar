import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/notification_service.dart';

enum RecurrenceType { never, daily, weekly, monthly, yearly }

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String color;
  final EventCategory category;
  final bool isAllDay;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? location;
  final String? notes;
  final RecurrenceType recurrence;
  final DateTime? recurrenceEndDate;
  final ReminderDuration reminder;
  final List<String> tags;
  final bool isCompleted;
  final int priority;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.color = '#00F5FF',
    this.category = EventCategory.personal,
    this.isAllDay = true,
    this.startTime,
    this.endTime,
    this.location,
    this.notes,
    this.recurrence = RecurrenceType.never,
    this.recurrenceEndDate,
    this.reminder = ReminderDuration.never,
    this.tags = const [],
    this.isCompleted = false,
    this.priority = 1,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Get duration of the event
  Duration get duration {
    if (isAllDay || startTime == null || endTime == null) {
      return const Duration(days: 1);
    }
    return endTime!.difference(startTime!);
  }

  // Get category color
  Color get categoryColor => EventCategoryHelper.getColor(category);

  // Get category icon
  IconData get categoryIcon => EventCategoryHelper.getIcon(category);

  // Get category name
  String get categoryName => EventCategoryHelper.getName(category);

  // Check if event is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // Check if event is upcoming (within next 7 days)
  bool get isUpcoming {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    return difference >= 0 && difference <= 7;
  }

  // Convert Event to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'color': color,
      'category': category.index,
      'isAllDay': isAllDay,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'location': location,
      'notes': notes,
      'recurrence': recurrence.index,
      'recurrenceEndDate': recurrenceEndDate?.toIso8601String(),
      'reminder': reminder.index,
      'tags': tags,
      'isCompleted': isCompleted,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create Event from Map for JSON deserialization
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.parse(map['date']),
      color: map['color'] ?? '#00F5FF',
      category: EventCategory.values[map['category'] ?? 0],
      isAllDay: map['isAllDay'] ?? true,
      startTime: map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      location: map['location'],
      notes: map['notes'],
      recurrence: RecurrenceType.values[map['recurrence'] ?? 0],
      recurrenceEndDate: map['recurrenceEndDate'] != null ? DateTime.parse(map['recurrenceEndDate']) : null,
      reminder: ReminderDuration.values[map['reminder'] ?? 0],
      tags: List<String>.from(map['tags'] ?? []),
      isCompleted: map['isCompleted'] ?? false,
      priority: map['priority'] ?? 1,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : DateTime.now(),
    );
  }

  // Convert Event to JSON string
  String toJson() => json.encode(toMap());

  // Create Event from JSON string
  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));

  // Create a copy of the event with modified fields
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? color,
    EventCategory? category,
    bool? isAllDay,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? notes,
    RecurrenceType? recurrence,
    DateTime? recurrenceEndDate,
    ReminderDuration? reminder,
    List<String>? tags,
    bool? isCompleted,
    int? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      color: color ?? this.color,
      category: category ?? this.category,
      isAllDay: isAllDay ?? this.isAllDay,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      recurrence: recurrence ?? this.recurrence,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      reminder: reminder ?? this.reminder,
      tags: tags ?? this.tags,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Event(id: $id, title: $title, category: $category, date: $date, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Event &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.date == date &&
        other.color == color &&
        other.category == category &&
        other.isAllDay == isAllDay &&
        other.priority == priority;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        date.hashCode ^
        color.hashCode ^
        category.hashCode ^
        isAllDay.hashCode ^
        priority.hashCode;
  }
}// Commit 3: 2025-02-02T14:48:40
// Commit 5: 2025-02-03T04:29:18
// Commit 7: 2025-02-03T19:04:01
// Commit 9: 2025-02-04T09:17:11
// Commit 13: 2025-02-05T13:44:28
// Commit 19: 2025-02-07T07:50:50
// Commit 27: 2025-02-09T16:07:24
// Commit 33: 2025-02-11T10:39:57
// Commit 36: 2025-02-12T08:20:03
// Commit 46: 2025-02-15T07:33:40
// Commit 50: 2025-02-16T11:15:05
// Commit 53: 2025-02-17T08:15:58
// Commit 62: 2025-02-20T00:48:53
// Commit 64: 2025-02-20T14:59:09
// Commit 69: 2025-02-22T01:36:09
// Commit 71: 2025-02-22T16:28:17
// Commit 72: 2025-02-22T23:24:07
// Commit 73: 2025-02-23T06:19:39
// Commit 77: 2025-02-24T10:42:11
// Commit 81: 2025-02-25T15:06:54
// Commit 90: 2025-02-28T06:52:46
// Commit 99: 2025-03-02T22:12:29
// Commit 100: 2025-03-03T05:20:02
// Commit 105: 2025-03-04T16:32:22
// Commit 110: 2025-03-06T03:59:19
// Commit 118: 2025-03-08T12:53:07
// Commit 119: 2025-03-08T20:22:17
// Commit 135: 2025-03-13T13:22:35
// Commit 158: 2025-03-20T08:32:37
// Commit 159: 2025-03-20T14:44:50
// Commit 161: 2025-03-21T05:01:27
// Commit 162: 2025-03-21T11:57:53
// Commit 176: 2025-03-25T15:29:23
// Commit 180: 2025-03-26T19:36:17
// Commit 183: 2025-03-27T16:43:44
// Commit 184: 2025-03-27T23:46:00
// Commit 192: 2025-03-30T08:36:57
// Commit 193: 2025-03-30T15:21:47
// Commit 194: 2025-03-30T23:02:58
// Commit 197: 2025-03-31T20:19:20
// Commit 15: 2025-02-06T03:08:52
// Commit 32: 2025-02-11T04:01:32
// Commit 36: 2025-02-12T08:14:09
// Commit 42: 2025-02-14T02:37:42
// Commit 43: 2025-02-14T10:20:43
// Commit 49: 2025-02-16T04:38:25
// Commit 53: 2025-02-17T08:38:12
// Commit 58: 2025-02-18T19:59:29
// Commit 68: 2025-02-21T19:12:08
// Commit 77: 2025-02-24T10:29:25
// Commit 78: 2025-02-24T17:36:11
// Commit 79: 2025-02-25T01:01:14
// Commit 82: 2025-02-25T21:46:01
// Commit 86: 2025-02-27T02:19:29
// Commit 88: 2025-02-27T16:21:14
// Commit 89: 2025-02-27T23:58:28
// Commit 103: 2025-03-04T03:00:55
// Commit 106: 2025-03-04T23:49:34
// Commit 108: 2025-03-05T14:32:49
// Commit 109: 2025-03-05T20:47:19
// Commit 119: 2025-03-08T20:05:49
// Commit 130: 2025-03-12T01:20:42
// Commit 132: 2025-03-12T16:20:20
// Commit 137: 2025-03-14T03:15:07
// Commit 138: 2025-03-14T10:55:53
// Commit 146: 2025-03-16T18:55:12
// Commit 147: 2025-03-17T02:07:37
// Commit 149: 2025-03-17T16:22:00
// Commit 161: 2025-03-21T05:36:11
// Commit 179: 2025-03-26T12:34:23
// Commit 182: 2025-03-27T09:40:24
// Commit 193: 2025-03-30T15:21:55
// Commit 197: 2025-03-31T19:46:12
// Commit 1: 2025-02-02T00:22:10
// Commit 2: 2025-02-02T07:28:41
// Commit 3: 2025-02-02T14:17:50
// Commit 4: 2025-02-02T21:34:30
// Commit 5: 2025-02-03T05:01:17
// Commit 10: 2025-02-04T15:50:57
// Commit 11: 2025-02-04T23:39:16
// Commit 13: 2025-02-05T13:44:19
// Commit 14: 2025-02-05T20:19:33
// Commit 15: 2025-02-06T04:04:25
// Commit 19: 2025-02-07T08:21:38
// Commit 21: 2025-02-07T21:51:55
// Commit 23: 2025-02-08T11:49:40
// Commit 25: 2025-02-09T01:57:58
// Commit 27: 2025-02-09T16:15:49
// Commit 29: 2025-02-10T06:59:08
// Commit 31: 2025-02-10T21:12:19
// Commit 32: 2025-02-11T04:22:57
// Commit 33: 2025-02-11T11:21:59
// Commit 37: 2025-02-12T15:06:14
// Commit 40: 2025-02-13T12:20:12
// Commit 42: 2025-02-14T02:22:10
// Commit 43: 2025-02-14T09:40:26
// Commit 44: 2025-02-14T17:16:30
// Commit 45: 2025-02-14T23:47:20
// Commit 49: 2025-02-16T04:29:13
// Commit 50: 2025-02-16T11:02:46
// Commit 51: 2025-02-16T18:00:25
// Commit 54: 2025-02-17T16:04:57
// Commit 55: 2025-02-17T22:30:18
// Commit 59: 2025-02-19T03:33:16
// Commit 62: 2025-02-20T00:01:02
// Commit 66: 2025-02-21T04:30:24
// Commit 69: 2025-02-22T01:56:51
// Commit 70: 2025-02-22T09:23:58
// Commit 71: 2025-02-22T15:53:40
// Commit 72: 2025-02-22T22:53:56
// Commit 73: 2025-02-23T05:57:59
// Commit 74: 2025-02-23T13:02:14
// Commit 77: 2025-02-24T10:14:00
// Commit 78: 2025-02-24T17:17:00
// Commit 79: 2025-02-25T01:13:24
// Commit 80: 2025-02-25T08:07:12
// Commit 81: 2025-02-25T15:21:47
// Commit 83: 2025-02-26T05:02:21
// Commit 87: 2025-02-27T09:52:03
// Commit 89: 2025-02-27T23:43:23
// Commit 90: 2025-02-28T06:59:27
// Commit 92: 2025-02-28T20:23:39
// Commit 93: 2025-03-01T04:12:33
// Commit 95: 2025-03-01T17:39:30
// Commit 99: 2025-03-02T22:17:08
// Commit 100: 2025-03-03T05:19:45
// Commit 101: 2025-03-03T12:09:15
// Commit 102: 2025-03-03T20:03:03
// Commit 103: 2025-03-04T03:08:22
// Commit 110: 2025-03-06T04:14:04
// Commit 111: 2025-03-06T10:54:58
// Commit 116: 2025-03-07T22:59:22
// Commit 117: 2025-03-08T05:38:59
// Commit 119: 2025-03-08T20:08:10
// Commit 123: 2025-03-10T00:15:38
// Commit 126: 2025-03-10T21:40:24
// Commit 128: 2025-03-11T11:23:15
// Commit 132: 2025-03-12T16:05:11
// Commit 137: 2025-03-14T03:01:32
// Commit 138: 2025-03-14T09:59:44
// Commit 139: 2025-03-14T17:52:43
// Commit 140: 2025-03-15T01:03:05
// Commit 143: 2025-03-15T22:04:54
// Commit 144: 2025-03-16T05:24:50
// Commit 145: 2025-03-16T11:32:30
// Commit 147: 2025-03-17T02:31:35
// Commit 148: 2025-03-17T08:46:08
// Commit 149: 2025-03-17T16:38:56
// Commit 151: 2025-03-18T06:58:11
// Commit 153: 2025-03-18T20:42:45
// Commit 154: 2025-03-19T03:17:42
// Commit 158: 2025-03-20T08:27:27
// Commit 160: 2025-03-20T22:06:17
// Commit 164: 2025-03-22T02:31:44
// Commit 166: 2025-03-22T16:59:15
// Commit 167: 2025-03-22T23:47:22
// Commit 170: 2025-03-23T21:29:47
// Commit 171: 2025-03-24T04:12:46
// Commit 172: 2025-03-24T10:55:12
// Commit 174: 2025-03-25T01:20:17
// Commit 175: 2025-03-25T08:09:43
// Commit 177: 2025-03-25T22:13:50
// Commit 178: 2025-03-26T05:10:42
// Commit 179: 2025-03-26T13:11:45
// Commit 184: 2025-03-27T23:55:37
// Commit 185: 2025-03-28T07:12:25
// Commit 187: 2025-03-28T21:06:55
// Commit 188: 2025-03-29T04:24:09
// Commit 190: 2025-03-29T18:38:08
// Commit 191: 2025-03-30T01:14:41
// Commit 193: 2025-03-30T15:39:47
// Commit 194: 2025-03-30T22:51:22
// Commit 195: 2025-03-31T05:54:55
// Commit 197: 2025-03-31T20:06:53
// Commit 198: 2025-04-01T02:57:34
// Commit 199: 2025-04-01T10:10:30
// Commit 200: 2025-04-01T17:04:03
// Commit 2: 2025-02-02T07:14:23
// Commit 3: 2025-02-02T14:37:35
// Commit 4: 2025-02-02T21:56:17
// Commit 6: 2025-02-03T12:03:28
// Commit 7: 2025-02-03T18:54:45
// Commit 9: 2025-02-04T08:39:17
// Commit 12: 2025-02-05T06:12:31
// Commit 14: 2025-02-05T20:54:50
// Commit 15: 2025-02-06T03:46:56
// Commit 18: 2025-02-07T00:27:25
// Commit 19: 2025-02-07T07:51:26
// Commit 23: 2025-02-08T12:34:06
// Commit 24: 2025-02-08T19:30:15
// Commit 25: 2025-02-09T02:01:47
// Commit 27: 2025-02-09T16:43:21
// Commit 28: 2025-02-09T23:38:56
// Commit 29: 2025-02-10T06:19:23
// Commit 31: 2025-02-10T20:40:32
// Commit 32: 2025-02-11T03:33:26
// Commit 33: 2025-02-11T10:54:56
// Commit 34: 2025-02-11T17:47:15
// Commit 35: 2025-02-12T00:55:40
// Commit 36: 2025-02-12T08:02:07
// Commit 37: 2025-02-12T15:41:10
// Commit 38: 2025-02-12T22:44:20
// Commit 41: 2025-02-13T20:03:34
// Commit 43: 2025-02-14T09:28:25
// Commit 45: 2025-02-15T00:14:19
// Commit 47: 2025-02-15T13:42:31
// Commit 51: 2025-02-16T18:14:32
// Commit 53: 2025-02-17T08:11:47
// Commit 54: 2025-02-17T15:39:40
// Commit 55: 2025-02-17T22:45:57
// Commit 57: 2025-02-18T13:01:45
// Commit 60: 2025-02-19T09:46:32
// Commit 61: 2025-02-19T17:26:41
// Commit 65: 2025-02-20T21:08:52
// Commit 68: 2025-02-21T19:18:14
// Commit 71: 2025-02-22T16:07:32
// Commit 73: 2025-02-23T06:45:25
// Commit 74: 2025-02-23T13:37:32
// Commit 76: 2025-02-24T03:25:31
// Commit 78: 2025-02-24T18:09:12
// Commit 79: 2025-02-25T00:14:48
// Commit 82: 2025-02-25T22:08:51
// Commit 88: 2025-02-27T16:26:53
// Commit 96: 2025-03-02T01:33:53
// Commit 97: 2025-03-02T08:08:09
// Commit 98: 2025-03-02T15:34:10
// Commit 100: 2025-03-03T05:49:09
// Commit 101: 2025-03-03T12:08:28
// Commit 102: 2025-03-03T19:41:39
// Commit 103: 2025-03-04T02:32:34
// Commit 104: 2025-03-04T09:16:07
// Commit 105: 2025-03-04T17:16:32
// Commit 106: 2025-03-05T00:14:46
// Commit 111: 2025-03-06T11:44:21
// Commit 112: 2025-03-06T18:07:22
// Commit 113: 2025-03-07T01:56:20
// Commit 114: 2025-03-07T08:16:13
// Commit 115: 2025-03-07T15:53:51
// Commit 116: 2025-03-07T22:45:02
// Commit 117: 2025-03-08T05:28:55
// Commit 119: 2025-03-08T19:43:51
// Commit 121: 2025-03-09T09:44:40
// Commit 122: 2025-03-09T17:29:29
// Commit 123: 2025-03-10T00:19:46
// Commit 125: 2025-03-10T14:01:13
// Commit 126: 2025-03-10T21:36:05
// Commit 127: 2025-03-11T04:30:44
// Commit 128: 2025-03-11T11:25:01
// Commit 129: 2025-03-11T18:47:42
// Commit 131: 2025-03-12T08:53:00
// Commit 133: 2025-03-12T23:31:16
// Commit 135: 2025-03-13T13:12:40
// Commit 136: 2025-03-13T20:10:56
// Commit 137: 2025-03-14T03:20:33
// Commit 138: 2025-03-14T10:00:18
// Commit 139: 2025-03-14T17:06:30
// Commit 140: 2025-03-15T01:00:15
// Commit 145: 2025-03-16T12:29:28
// Commit 146: 2025-03-16T19:12:56
// Commit 147: 2025-03-17T02:10:17
// Commit 148: 2025-03-17T09:02:12
// Commit 149: 2025-03-17T16:33:55
// Commit 150: 2025-03-17T23:54:23
// Commit 152: 2025-03-18T13:57:25
// Commit 155: 2025-03-19T10:23:26
// Commit 156: 2025-03-19T18:04:35
// Commit 158: 2025-03-20T07:37:17
// Commit 163: 2025-03-21T19:34:26
// Commit 165: 2025-03-22T09:14:39
// Commit 166: 2025-03-22T16:37:37
// Commit 168: 2025-03-23T06:21:40
// Commit 169: 2025-03-23T13:46:52
// Commit 170: 2025-03-23T20:33:30
// Commit 172: 2025-03-24T11:20:58
// Commit 174: 2025-03-25T01:40:51
// Commit 183: 2025-03-27T16:58:08
// Commit 184: 2025-03-27T23:52:43
// Commit 185: 2025-03-28T06:47:20
// Commit 189: 2025-03-29T12:01:23
// Commit 190: 2025-03-29T18:57:45
// Commit 191: 2025-03-30T01:49:02
// Commit 193: 2025-03-30T15:22:15
// Commit 199: 2025-04-01T10:20:55
// Commit 2: 2025-02-02T07:48:32
// Commit 3: 2025-02-02T14:53:53
// Commit 8: 2025-02-04T01:47:36
// Commit 10: 2025-02-04T16:33:23
// Commit 11: 2025-02-04T23:16:54
// Commit 13: 2025-02-05T13:17:00
// Commit 14: 2025-02-05T20:33:47
// Commit 15: 2025-02-06T03:19:27
// Commit 16: 2025-02-06T10:53:57
// Commit 17: 2025-02-06T17:38:22
// Commit 21: 2025-02-07T21:43:59
// Commit 25: 2025-02-09T02:32:44
// Commit 26: 2025-02-09T09:40:06
// Commit 27: 2025-02-09T16:10:06
// Commit 28: 2025-02-09T23:34:20
// Commit 29: 2025-02-10T07:03:11
// Commit 31: 2025-02-10T21:20:11
// Commit 32: 2025-02-11T04:13:59
// Commit 33: 2025-02-11T10:59:15
// Commit 34: 2025-02-11T18:21:18
// Commit 35: 2025-02-12T01:16:09
// Commit 37: 2025-02-12T15:06:35
// Commit 38: 2025-02-12T22:40:30
// Commit 39: 2025-02-13T05:04:08
// Commit 40: 2025-02-13T13:01:01
// Commit 41: 2025-02-13T19:38:33
// Commit 42: 2025-02-14T02:57:00
// Commit 43: 2025-02-14T10:02:59
// Commit 45: 2025-02-14T23:53:06
// Commit 48: 2025-02-15T21:21:40
// Commit 49: 2025-02-16T04:33:46
// Commit 52: 2025-02-17T01:12:05
// Commit 53: 2025-02-17T08:54:07
// Commit 54: 2025-02-17T15:33:47
// Commit 56: 2025-02-18T06:19:54
// Commit 57: 2025-02-18T13:06:02
// Commit 58: 2025-02-18T19:36:07
// Commit 59: 2025-02-19T03:23:41
// Commit 60: 2025-02-19T09:44:55
// Commit 61: 2025-02-19T17:44:32
// Commit 66: 2025-02-21T04:55:07
// Commit 68: 2025-02-21T18:25:29
// Commit 70: 2025-02-22T08:49:20
// Commit 71: 2025-02-22T16:03:18
// Commit 72: 2025-02-22T23:38:03
// Commit 73: 2025-02-23T06:25:09
// Commit 76: 2025-02-24T03:05:12
// Commit 79: 2025-02-25T00:45:24
// Commit 82: 2025-02-25T21:52:44
// Commit 84: 2025-02-26T12:08:13
// Commit 87: 2025-02-27T09:34:30
// Commit 88: 2025-02-27T16:35:26
// Commit 89: 2025-02-27T23:40:33
// Commit 90: 2025-02-28T06:18:13
// Commit 91: 2025-02-28T14:03:49
// Commit 92: 2025-02-28T20:33:46
// Commit 93: 2025-03-01T04:09:07
// Commit 94: 2025-03-01T11:09:42
// Commit 95: 2025-03-01T18:15:00
// Commit 98: 2025-03-02T15:40:24
// Commit 100: 2025-03-03T05:43:22
// Commit 101: 2025-03-03T12:07:41
// Commit 102: 2025-03-03T19:33:18
// Commit 105: 2025-03-04T16:57:41
// Commit 108: 2025-03-05T13:59:46
// Commit 109: 2025-03-05T20:54:07
// Commit 110: 2025-03-06T04:41:41
// Commit 112: 2025-03-06T18:35:06
// Commit 113: 2025-03-07T01:07:24
// Commit 114: 2025-03-07T08:28:20
// Commit 116: 2025-03-07T22:55:58
// Commit 121: 2025-03-09T09:51:25
// Commit 123: 2025-03-09T23:55:56
// Commit 124: 2025-03-10T07:21:25
// Commit 125: 2025-03-10T14:49:48
// Commit 126: 2025-03-10T21:28:26
// Commit 128: 2025-03-11T11:36:17
// Commit 130: 2025-03-12T01:38:10
// Commit 131: 2025-03-12T08:57:59
// Commit 134: 2025-03-13T06:34:17
// Commit 137: 2025-03-14T03:38:56
// Commit 138: 2025-03-14T10:07:09
// Commit 139: 2025-03-14T17:36:40
// Commit 140: 2025-03-15T01:03:51
// Commit 142: 2025-03-15T14:40:18
// Commit 143: 2025-03-15T21:42:50
// Commit 144: 2025-03-16T04:46:59
// Commit 149: 2025-03-17T16:30:57
// Commit 151: 2025-03-18T06:21:08
// Commit 152: 2025-03-18T13:51:18
// Commit 156: 2025-03-19T18:16:37
// Commit 158: 2025-03-20T07:41:12
// Commit 159: 2025-03-20T15:37:17
// Commit 160: 2025-03-20T22:00:00
// Commit 161: 2025-03-21T05:30:43
// Commit 163: 2025-03-21T19:15:06
// Commit 164: 2025-03-22T02:28:00
// Commit 165: 2025-03-22T09:52:53
// Commit 170: 2025-03-23T20:43:23
// Commit 175: 2025-03-25T08:23:15
// Commit 176: 2025-03-25T15:06:30
// Commit 178: 2025-03-26T05:44:22
// Commit 180: 2025-03-26T19:31:15
// Commit 181: 2025-03-27T02:48:54
// Commit 185: 2025-03-28T07:18:03
// Commit 191: 2025-03-30T02:03:31
// Commit 192: 2025-03-30T08:27:36
// Commit 194: 2025-03-30T23:01:35
// Commit 197: 2025-03-31T20:02:10
// Commit 4: 2025-02-02T21:56:01
// Commit 7: 2025-02-03T19:16:52
// Commit 10: 2025-02-04T16:00:44
// Commit 13: 2025-02-05T13:56:58
// Commit 14: 2025-02-05T20:35:47
// Commit 19: 2025-02-07T07:27:12
// Commit 20: 2025-02-07T15:13:59
// Commit 21: 2025-02-07T22:23:44
// Commit 22: 2025-02-08T05:02:23
// Commit 23: 2025-02-08T12:31:34
// Commit 24: 2025-02-08T19:21:47
// Commit 27: 2025-02-09T16:43:27
// Commit 28: 2025-02-09T23:21:43
// Commit 29: 2025-02-10T06:53:26
// Commit 31: 2025-02-10T21:22:45
// Commit 32: 2025-02-11T04:23:40
// Commit 34: 2025-02-11T18:16:22
// Commit 35: 2025-02-12T01:00:52
// Commit 36: 2025-02-12T08:43:04
// Commit 38: 2025-02-12T22:05:29
// Commit 41: 2025-02-13T19:23:09
// Commit 49: 2025-02-16T04:16:31
// Commit 50: 2025-02-16T11:00:14
// Commit 54: 2025-02-17T15:52:22
// Commit 60: 2025-02-19T10:26:23
// Commit 61: 2025-02-19T17:26:28
// Commit 62: 2025-02-20T00:51:18
// Commit 63: 2025-02-20T07:23:54
// Commit 64: 2025-02-20T14:34:10
// Commit 67: 2025-02-21T11:30:53
// Commit 68: 2025-02-21T18:35:43
// Commit 70: 2025-02-22T08:39:38
// Commit 72: 2025-02-22T23:35:26
// Commit 76: 2025-02-24T03:48:31
// Commit 77: 2025-02-24T10:52:24
// Commit 80: 2025-02-25T07:44:54
// Commit 81: 2025-02-25T14:41:55
// Commit 83: 2025-02-26T04:45:21
// Commit 84: 2025-02-26T11:54:52
// Commit 85: 2025-02-26T19:20:55
// Commit 86: 2025-02-27T02:45:15
// Commit 87: 2025-02-27T09:37:33
// Commit 89: 2025-02-27T23:44:59
// Commit 91: 2025-02-28T13:49:21
// Commit 92: 2025-02-28T21:02:35
// Commit 94: 2025-03-01T10:53:05
// Commit 97: 2025-03-02T08:08:54
// Commit 100: 2025-03-03T05:38:32
// Commit 101: 2025-03-03T12:49:53
// Commit 102: 2025-03-03T19:51:52
// Commit 105: 2025-03-04T17:04:58
// Commit 108: 2025-03-05T14:33:25
// Commit 110: 2025-03-06T04:36:15
// Commit 112: 2025-03-06T18:01:44
// Commit 114: 2025-03-07T08:44:03
// Commit 116: 2025-03-07T22:36:55
// Commit 117: 2025-03-08T05:27:00
// Commit 121: 2025-03-09T09:51:31
// Commit 122: 2025-03-09T16:53:15
// Commit 126: 2025-03-10T21:29:18
// Commit 129: 2025-03-11T19:05:11
// Commit 130: 2025-03-12T01:30:57
// Commit 132: 2025-03-12T15:49:35
// Commit 133: 2025-03-12T22:52:28
// Commit 134: 2025-03-13T05:38:41
// Commit 135: 2025-03-13T13:21:51
// Commit 137: 2025-03-14T03:00:44
// Commit 138: 2025-03-14T10:31:28
// Commit 140: 2025-03-15T00:15:34
// Commit 148: 2025-03-17T08:53:28
// Commit 149: 2025-03-17T16:01:16
// Commit 152: 2025-03-18T13:34:01
// Commit 155: 2025-03-19T11:18:15
// Commit 156: 2025-03-19T18:10:15
// Commit 157: 2025-03-20T00:39:22
// Commit 158: 2025-03-20T07:59:33
// Commit 159: 2025-03-20T15:31:55
// Commit 160: 2025-03-20T22:16:44
// Commit 165: 2025-03-22T09:45:48
// Commit 167: 2025-03-22T23:50:30
// Commit 170: 2025-03-23T20:43:42
// Commit 172: 2025-03-24T10:44:29
// Commit 173: 2025-03-24T18:17:50
// Commit 175: 2025-03-25T08:45:36
// Commit 178: 2025-03-26T06:04:43
// Commit 180: 2025-03-26T19:26:18
// Commit 182: 2025-03-27T10:11:41
// Commit 184: 2025-03-28T00:04:12
// Commit 186: 2025-03-28T13:59:53
// Commit 193: 2025-03-30T15:50:40
// Commit 194: 2025-03-30T22:26:54
// Commit 196: 2025-03-31T13:04:05
// Commit 198: 2025-04-01T03:28:06
// Commit 200: 2025-04-01T17:01:21
// Commit 3: 2025-02-02T15:02:36
// Commit 4: 2025-02-02T22:06:24
// Commit 6: 2025-02-03T11:50:34
// Commit 14: 2025-02-05T20:32:22
// Commit 16: 2025-02-06T10:28:52
// Commit 18: 2025-02-07T00:24:48
// Commit 19: 2025-02-07T07:37:19
// Commit 21: 2025-02-07T22:35:49
// Commit 23: 2025-02-08T12:42:52
// Commit 24: 2025-02-08T19:06:02
// Commit 25: 2025-02-09T02:53:51
// Commit 29: 2025-02-10T06:32:35
// Commit 31: 2025-02-10T21:12:56
// Commit 35: 2025-02-12T01:33:03
// Commit 36: 2025-02-12T07:51:46
// Commit 37: 2025-02-12T15:19:03
// Commit 38: 2025-02-12T22:35:50
// Commit 39: 2025-02-13T05:39:55
// Commit 40: 2025-02-13T12:16:55
// Commit 41: 2025-02-13T20:06:22
// Commit 45: 2025-02-14T23:50:08
// Commit 49: 2025-02-16T04:33:26
// Commit 50: 2025-02-16T11:49:40
// Commit 51: 2025-02-16T18:22:50
// Commit 57: 2025-02-18T13:10:59
// Commit 58: 2025-02-18T19:47:12
// Commit 60: 2025-02-19T10:03:55
// Commit 62: 2025-02-20T00:10:59
// Commit 71: 2025-02-22T16:31:13
// Commit 73: 2025-02-23T05:57:41
// Commit 75: 2025-02-23T20:11:53
// Commit 77: 2025-02-24T11:03:29
// Commit 79: 2025-02-25T00:57:08
// Commit 80: 2025-02-25T07:24:46
// Commit 82: 2025-02-25T21:36:33
// Commit 84: 2025-02-26T12:21:06
// Commit 86: 2025-02-27T02:41:09
// Commit 88: 2025-02-27T16:51:45
// Commit 89: 2025-02-27T23:09:19
// Commit 90: 2025-02-28T06:21:25
// Commit 91: 2025-02-28T13:56:30
// Commit 94: 2025-03-01T10:46:03
// Commit 97: 2025-03-02T08:17:43
