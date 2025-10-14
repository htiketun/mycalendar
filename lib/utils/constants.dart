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
}
