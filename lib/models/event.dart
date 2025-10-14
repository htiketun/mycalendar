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
}
