import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Arcade Theme Colors - Vibrant Purple/Magenta Theme
  static const Color primaryColor = Color(0xFF9D4EDD); // Electric Purple
  static const Color secondaryColor = Color(0xFFFF006E); // Hot Pink
  static const Color accentColor = Color(0xFF00F5FF); // Neon Cyan
  static const Color backgroundColor = Color(0xFF0A0A0A); // Dark Background
  static const Color surfaceColor = Color(0xFF2D1B69); // Deep Purple Surface
  static const Color cardColor = Color(0xFF3C1C5B); // Purple Card Background
  static const Color errorColor = Color(0xFFFF073A); // Neon Red
  static const Color successColor = Color(0xFF39FF14); // Bright Green
  static const Color warningColor = Color(0xFFFFD700); // Gold
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xFFD4B6FF); // Light Purple
  static const Color textAccent = Color(0xFF9D4EDD); // Electric Purple Text
  static const Color dividerColor = Color(0xFF4A2C6B); // Purple Divider
  
  // Neon Glow Colors - Purple Theme
  static const Color neonPurple = Color(0xFF9D4EDD);
  static const Color neonMagenta = Color(0xFFFF006E);
  static const Color neonViolet = Color(0xFF7209B7);
  static const Color neonPink = Color(0xFFFF1493);
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonOrange = Color(0xFFFF6600);
  static const Color neonRed = Color(0xFFFF073A);

  // Gradients for Arcade Theme - Purple Theme
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonPurple, neonViolet],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonMagenta, neonPink],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonGreen, neonCyan],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0A0A), Color(0xFF2D1B69), Color(0xFF3C1C5B)],
  );

  // Event Category Colors - Purple Theme Palette
  static const List<Color> eventColors = [
    neonPurple,  // Work
    neonMagenta, // Personal
    neonPink,    // Health & Fitness
    neonViolet,  // Education
    neonCyan,    // Social
    neonGreen,   // Travel
    neonOrange,  // Entertainment
    neonRed,     // Important
  ];

  static Color getEventColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return primaryColor;
    }
  }

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  // Helper methods for event form dialog
  static String getCategoryName(EventCategory category) {
    return EventCategoryHelper.getName(category);
  }

  static IconData getCategoryIcon(EventCategory category) {
    return EventCategoryHelper.getIcon(category);
  }

  static Color getCategoryColor(EventCategory category) {
    return EventCategoryHelper.getColor(category);
  }
}

// Event Categories
enum EventCategory {
  work,
  personal,
  health,
  education,
  social,
  travel,
  entertainment,
  important,
}

class EventCategoryHelper {
  static const Map<EventCategory, String> categoryNames = {
    EventCategory.work: 'Work',
    EventCategory.personal: 'Personal',
    EventCategory.health: 'Health & Fitness',
    EventCategory.education: 'Education',
    EventCategory.social: 'Social',
    EventCategory.travel: 'Travel',
    EventCategory.entertainment: 'Entertainment',
    EventCategory.important: 'Important',
  };

  static const Map<EventCategory, IconData> categoryIcons = {
    EventCategory.work: Icons.work_rounded,
    EventCategory.personal: Icons.person_rounded,
    EventCategory.health: Icons.fitness_center_rounded,
    EventCategory.education: Icons.school_rounded,
    EventCategory.social: Icons.groups_rounded,
    EventCategory.travel: Icons.flight_rounded,
    EventCategory.entertainment: Icons.movie_rounded,
    EventCategory.important: Icons.priority_high_rounded,
  };

  static const Map<EventCategory, Color> categoryColors = {
    EventCategory.work: AppColors.neonPurple,
    EventCategory.personal: AppColors.neonMagenta,
    EventCategory.health: AppColors.neonPink,
    EventCategory.education: AppColors.neonViolet,
    EventCategory.social: AppColors.neonCyan,
    EventCategory.travel: AppColors.neonGreen,
    EventCategory.entertainment: AppColors.neonOrange,
    EventCategory.important: AppColors.neonRed,
  };

  static String getName(EventCategory category) {
    return categoryNames[category] ?? 'Unknown';
  }

  static IconData getIcon(EventCategory category) {
    return categoryIcons[category] ?? Icons.event;
  }

  static Color getColor(EventCategory category) {
    return categoryColors[category] ?? AppColors.primaryColor;
  }
}

class AppTextStyles {
  // Modern, tech-inspired fonts for arcade theme
  
  static TextStyle get heading1 => GoogleFonts.orbitron(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
    height: 1.2,
  );

  static TextStyle get heading2 => GoogleFonts.orbitron(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
    height: 1.3,
  );

  static TextStyle get heading3 => GoogleFonts.orbitron(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.8,
    height: 1.3,
  );

  static TextStyle get bodyText => GoogleFonts.exo(
    fontSize: 16,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  static TextStyle get caption => GoogleFonts.exo(
    fontSize: 14,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
    height: 1.3,
  );

  static TextStyle get button => GoogleFonts.orbitron(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
    height: 1.2,
  );

  static TextStyle get neonText => GoogleFonts.orbitron(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.neonPurple,
    letterSpacing: 1.2,
    height: 1.2,
    shadows: [
      const Shadow(
        blurRadius: 10.0,
        color: AppColors.neonPurple,
        offset: Offset(0, 0),
      ),
    ],
  );

  static TextStyle get arcadeTitle => GoogleFonts.orbitron(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: 2.0,
    height: 1.1,
    shadows: [
      const Shadow(
        blurRadius: 15.0,
        color: AppColors.neonPurple,
        offset: Offset(0, 0),
      ),
      const Shadow(
        blurRadius: 25.0,
        color: AppColors.neonMagenta,
        offset: Offset(0, 0),
      ),
    ],
  );
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double borderRadius = 8.0;
  static const double borderRadiusLarge = 16.0;

  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
}

class AppStrings {
  // App Info
  static const String appName = 'MY CALENDAR';
  static const String appSubtitle = 'Level up your productivity!';
  
  // Navigation
  static const String today = 'Today';
  static const String monthView = 'Month';
  static const String weekView = 'Week';
  static const String dayView = 'Day';
  static const String agenda = 'Agenda';
  static const String statistics = 'Stats';
  
  // Event Actions
  static const String addEvent = 'Add Event';
  static const String editEvent = 'Edit Event';
  static const String deleteEvent = 'Delete Event';
  static const String duplicateEvent = 'Duplicate Event';
  static const String moveEvent = 'Move Event';
  
  // Event Properties
  static const String eventTitle = 'Event Title';
  static const String eventDescription = 'Event Description';
  static const String eventCategory = 'Category';
  static const String eventColor = 'Color';
  static const String eventDate = 'Date';
  static const String startTime = 'Start Time';
  static const String endTime = 'End Time';
  static const String allDay = 'All Day';
  static const String recurring = 'Recurring';
  static const String location = 'Location';
  static const String notes = 'Notes';
  
  // Recurring Options
  static const String never = 'Never';
  static const String daily = 'Daily';
  static const String weekly = 'Weekly';
  static const String monthly = 'Monthly';
  static const String yearly = 'Yearly';
  static const String custom = 'Custom';
  
  // Actions
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String clear = 'Clear';
  static const String apply = 'Apply';
  
  // Messages
  static const String noEvents = 'No events found';
  static const String noEventsToday = 'No events for today';
  static const String confirmDelete = 'Are you sure you want to delete this event?';
  static const String eventTitleRequired = 'Event title is required';
  static const String eventSaved = 'Event saved successfully!';
  static const String eventDeleted = 'Event deleted successfully!';
  static const String eventUpdated = 'Event updated successfully!';
  
  // Search & Filter
  static const String searchEvents = 'Search events...';
  static const String filterByCategory = 'Filter by category';
  static const String filterByDate = 'Filter by date';
  static const String showAll = 'Show All';
  
  // Statistics
  static const String totalEvents = 'Total Events';
  static const String thisWeek = 'This Week';
  static const String thisMonth = 'This Month';
  static const String completed = 'Completed';
  static const String upcoming = 'Upcoming';
  static const String productivity = 'Productivity Score';
  
  // Achievement System
  static const String achievements = 'Achievements';
  static const String streak = 'Streak';
  static const String level = 'Level';
  static const String xp = 'XP';
  static const String newAchievement = 'New Achievement Unlocked!';
}// Commit 16: 2025-02-06T11:08:28
// Commit 20: 2025-02-07T14:38:32
// Commit 24: 2025-02-08T19:05:55
// Commit 38: 2025-02-12T22:34:29
// Commit 59: 2025-02-19T03:32:26
// Commit 101: 2025-03-03T12:24:07
// Commit 121: 2025-03-09T10:12:56
// Commit 144: 2025-03-16T05:23:55
// Commit 156: 2025-03-19T17:31:00
// Commit 173: 2025-03-24T18:16:36
// Commit 3: 2025-02-02T14:53:17
// Commit 4: 2025-02-02T21:56:05
// Commit 11: 2025-02-04T23:30:55
// Commit 19: 2025-02-07T07:43:56
// Commit 22: 2025-02-08T05:23:41
// Commit 23: 2025-02-08T12:23:54
// Commit 47: 2025-02-15T14:37:34
// Commit 61: 2025-02-19T17:26:03
// Commit 74: 2025-02-23T13:18:15
// Commit 95: 2025-03-01T17:49:38
// Commit 112: 2025-03-06T18:18:15
// Commit 144: 2025-03-16T05:18:43
// Commit 150: 2025-03-17T23:03:48
// Commit 155: 2025-03-19T11:03:09
// Commit 162: 2025-03-21T12:33:37
// Commit 170: 2025-03-23T20:44:29
// Commit 171: 2025-03-24T03:50:01
// Commit 178: 2025-03-26T05:20:29
// Commit 190: 2025-03-29T18:28:55
// Commit 198: 2025-04-01T03:19:35
// Commit 2: 2025-02-02T07:28:41
// Commit 6: 2025-02-03T12:19:13
// Commit 8: 2025-02-04T02:16:47
// Commit 9: 2025-02-04T09:38:21
// Commit 15: 2025-02-06T04:04:25
// Commit 22: 2025-02-08T05:29:44
// Commit 26: 2025-02-09T09:54:52
// Commit 29: 2025-02-10T06:59:08
// Commit 31: 2025-02-10T21:12:19
// Commit 32: 2025-02-11T04:22:57
// Commit 35: 2025-02-12T00:50:20
// Commit 36: 2025-02-12T07:51:21
// Commit 46: 2025-02-15T07:00:52
// Commit 48: 2025-02-15T21:02:38
// Commit 56: 2025-02-18T05:37:00
// Commit 57: 2025-02-18T12:44:10
// Commit 58: 2025-02-18T20:12:55
// Commit 59: 2025-02-19T03:33:16
// Commit 61: 2025-02-19T16:50:50
// Commit 67: 2025-02-21T11:40:22
// Commit 71: 2025-02-22T15:53:40
// Commit 76: 2025-02-24T03:57:18
// Commit 80: 2025-02-25T08:07:12
// Commit 82: 2025-02-25T21:53:57
// Commit 88: 2025-02-27T16:44:23
// Commit 99: 2025-03-02T22:17:08
// Commit 105: 2025-03-04T16:59:00
// Commit 110: 2025-03-06T04:14:04
// Commit 112: 2025-03-06T18:22:24
// Commit 115: 2025-03-07T15:23:55
// Commit 116: 2025-03-07T22:59:22
// Commit 118: 2025-03-08T12:58:10
// Commit 119: 2025-03-08T20:08:10
// Commit 123: 2025-03-10T00:15:38
// Commit 124: 2025-03-10T07:06:05
// Commit 125: 2025-03-10T14:49:32
// Commit 128: 2025-03-11T11:23:15
// Commit 129: 2025-03-11T19:01:49
// Commit 137: 2025-03-14T03:01:32
// Commit 138: 2025-03-14T09:59:44
// Commit 143: 2025-03-15T22:04:54
// Commit 146: 2025-03-16T18:52:31
// Commit 153: 2025-03-18T20:42:45
// Commit 154: 2025-03-19T03:17:42
// Commit 161: 2025-03-21T05:40:51
// Commit 164: 2025-03-22T02:31:44
// Commit 166: 2025-03-22T16:59:15
// Commit 169: 2025-03-23T13:54:49
// Commit 170: 2025-03-23T21:29:47
// Commit 175: 2025-03-25T08:09:43
// Commit 176: 2025-03-25T15:25:06
// Commit 179: 2025-03-26T13:11:45
// Commit 181: 2025-03-27T02:49:53
// Commit 14: 2025-02-05T20:54:50
// Commit 15: 2025-02-06T03:46:56
// Commit 17: 2025-02-06T17:37:36
// Commit 21: 2025-02-07T21:49:19
// Commit 32: 2025-02-11T03:33:26
// Commit 34: 2025-02-11T17:47:15
// Commit 36: 2025-02-12T08:02:07
// Commit 37: 2025-02-12T15:41:10
// Commit 41: 2025-02-13T20:03:34
// Commit 44: 2025-02-14T16:47:52
// Commit 45: 2025-02-15T00:14:19
// Commit 49: 2025-02-16T04:00:09
// Commit 56: 2025-02-18T05:49:12
// Commit 60: 2025-02-19T09:46:32
// Commit 64: 2025-02-20T14:21:23
// Commit 65: 2025-02-20T21:08:52
// Commit 74: 2025-02-23T13:37:32
// Commit 75: 2025-02-23T20:07:44
// Commit 82: 2025-02-25T22:08:51
// Commit 85: 2025-02-26T19:06:11
// Commit 89: 2025-02-27T23:21:26
// Commit 102: 2025-03-03T19:41:39
// Commit 108: 2025-03-05T13:49:00
// Commit 111: 2025-03-06T11:44:21
// Commit 131: 2025-03-12T08:53:00
// Commit 133: 2025-03-12T23:31:16
// Commit 139: 2025-03-14T17:06:30
// Commit 141: 2025-03-15T07:46:05
// Commit 143: 2025-03-15T21:52:57
// Commit 144: 2025-03-16T05:23:41
// Commit 150: 2025-03-17T23:54:23
// Commit 154: 2025-03-19T03:19:54
// Commit 157: 2025-03-20T00:47:08
// Commit 158: 2025-03-20T07:37:17
// Commit 160: 2025-03-20T22:36:27
// Commit 161: 2025-03-21T05:03:28
// Commit 169: 2025-03-23T13:46:52
// Commit 174: 2025-03-25T01:40:51
// Commit 178: 2025-03-26T05:17:51
// Commit 179: 2025-03-26T13:02:07
// Commit 183: 2025-03-27T16:58:08
// Commit 190: 2025-03-29T18:57:45
// Commit 3: 2025-02-02T14:53:53
// Commit 5: 2025-02-03T04:52:55
// Commit 10: 2025-02-04T16:33:23
// Commit 14: 2025-02-05T20:33:47
// Commit 17: 2025-02-06T17:38:22
// Commit 26: 2025-02-09T09:40:06
// Commit 27: 2025-02-09T16:10:06
// Commit 28: 2025-02-09T23:34:20
// Commit 37: 2025-02-12T15:06:35
// Commit 40: 2025-02-13T13:01:01
// Commit 41: 2025-02-13T19:38:33
// Commit 46: 2025-02-15T07:11:29
// Commit 47: 2025-02-15T14:27:21
// Commit 51: 2025-02-16T18:36:03
// Commit 64: 2025-02-20T14:46:39
// Commit 73: 2025-02-23T06:25:09
// Commit 77: 2025-02-24T10:46:19
// Commit 91: 2025-02-28T14:03:49
// Commit 93: 2025-03-01T04:09:07
// Commit 95: 2025-03-01T18:15:00
// Commit 99: 2025-03-02T22:10:28
// Commit 106: 2025-03-04T23:30:30
// Commit 115: 2025-03-07T15:40:02
// Commit 116: 2025-03-07T22:55:58
// Commit 117: 2025-03-08T05:59:40
// Commit 118: 2025-03-08T12:35:58
// Commit 119: 2025-03-08T19:33:46
// Commit 121: 2025-03-09T09:51:25
// Commit 129: 2025-03-11T18:33:13
// Commit 131: 2025-03-12T08:57:59
// Commit 137: 2025-03-14T03:38:56
// Commit 140: 2025-03-15T01:03:51
// Commit 141: 2025-03-15T07:50:04
// Commit 143: 2025-03-15T21:42:50
// Commit 144: 2025-03-16T04:46:59
// Commit 148: 2025-03-17T09:39:40
// Commit 154: 2025-03-19T03:18:59
// Commit 156: 2025-03-19T18:16:37
// Commit 159: 2025-03-20T15:37:17
// Commit 161: 2025-03-21T05:30:43
// Commit 167: 2025-03-23T00:07:51
// Commit 168: 2025-03-23T07:20:53
// Commit 169: 2025-03-23T14:17:59
// Commit 171: 2025-03-24T03:58:57
// Commit 176: 2025-03-25T15:06:30
// Commit 179: 2025-03-26T12:22:20
// Commit 184: 2025-03-28T00:21:38
// Commit 187: 2025-03-28T21:09:04
// Commit 195: 2025-03-31T05:45:01
// Commit 198: 2025-04-01T03:08:38
// Commit 1: 2025-02-02T00:52:58
// Commit 5: 2025-02-03T05:03:06
// Commit 11: 2025-02-04T23:46:57
// Commit 14: 2025-02-05T20:35:47
// Commit 19: 2025-02-07T07:27:12
// Commit 26: 2025-02-09T09:40:38
// Commit 30: 2025-02-10T14:03:15
// Commit 32: 2025-02-11T04:23:40
// Commit 34: 2025-02-11T18:16:22
// Commit 37: 2025-02-12T15:25:21
// Commit 41: 2025-02-13T19:23:09
// Commit 43: 2025-02-14T10:10:24
// Commit 46: 2025-02-15T06:55:54
// Commit 47: 2025-02-15T14:38:47
// Commit 51: 2025-02-16T18:01:27
// Commit 52: 2025-02-17T01:12:59
// Commit 61: 2025-02-19T17:26:28
// Commit 67: 2025-02-21T11:30:53
// Commit 69: 2025-02-22T02:08:52
// Commit 74: 2025-02-23T13:13:27
// Commit 88: 2025-02-27T16:18:22
// Commit 96: 2025-03-02T01:08:55
// Commit 97: 2025-03-02T08:08:54
// Commit 99: 2025-03-02T22:34:16
// Commit 112: 2025-03-06T18:01:44
// Commit 115: 2025-03-07T15:49:57
// Commit 118: 2025-03-08T12:46:13
// Commit 125: 2025-03-10T14:26:54
// Commit 128: 2025-03-11T11:23:59
// Commit 131: 2025-03-12T09:18:38
// Commit 134: 2025-03-13T05:38:41
// Commit 137: 2025-03-14T03:00:44
// Commit 138: 2025-03-14T10:31:28
// Commit 139: 2025-03-14T17:38:54
// Commit 140: 2025-03-15T00:15:34
// Commit 141: 2025-03-15T07:13:57
// Commit 143: 2025-03-15T21:56:08
// Commit 144: 2025-03-16T05:15:19
// Commit 148: 2025-03-17T08:53:28
// Commit 151: 2025-03-18T06:17:45
// Commit 155: 2025-03-19T11:18:15
// Commit 157: 2025-03-20T00:39:22
// Commit 162: 2025-03-21T12:51:21
// Commit 163: 2025-03-21T19:53:06
// Commit 177: 2025-03-25T22:07:29
// Commit 181: 2025-03-27T02:55:07
// Commit 182: 2025-03-27T10:11:41
// Commit 185: 2025-03-28T07:01:25
// Commit 191: 2025-03-30T01:32:44
// Commit 195: 2025-03-31T06:01:23
// Commit 6: 2025-02-03T11:50:34
// Commit 7: 2025-02-03T18:31:22
// Commit 9: 2025-02-04T09:08:22
// Commit 16: 2025-02-06T10:28:52
// Commit 17: 2025-02-06T17:56:57
// Commit 21: 2025-02-07T22:35:49
// Commit 22: 2025-02-08T05:04:28
// Commit 26: 2025-02-09T09:20:28
// Commit 41: 2025-02-13T20:06:22
// Commit 42: 2025-02-14T02:43:51
// Commit 43: 2025-02-14T10:10:36
// Commit 46: 2025-02-15T06:46:10
// Commit 51: 2025-02-16T18:22:50
// Commit 54: 2025-02-17T16:04:45
// Commit 68: 2025-02-21T19:00:20
// Commit 71: 2025-02-22T16:31:13
