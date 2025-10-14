import 'package:flutter/material.dart';

// Myanmar Holiday Types
enum MyanmarHolidayType {
  public,        // Public Holiday
  religious,     // Religious Holiday  
  national,      // National Holiday
  traditional,   // Traditional Holiday
  regional,      // Regional Holiday
}

class MyanmarHoliday {
  final String name;
  final String nameMyanmar;
  final DateTime date;
  final MyanmarHolidayType type;
  final String description;
  final bool isRecurring;
  final Color color;

  const MyanmarHoliday({
    required this.name,
    required this.nameMyanmar,
    required this.date,
    required this.type,
    required this.description,
    this.isRecurring = true,
    required this.color,
  });

  // Create holiday for specific year
  MyanmarHoliday forYear(int year) {
    return MyanmarHoliday(
      name: name,
      nameMyanmar: nameMyanmar,
      date: DateTime(year, date.month, date.day),
      type: type,
      description: description,
      isRecurring: isRecurring,
      color: color,
    );
  }
}

class MyanmarHolidayService {
  // Colors for different holiday types
  static const Color publicHolidayColor = Color(0xFFFF6B6B);      // Red
  static const Color religiousHolidayColor = Color(0xFF4ECDC4);   // Teal
  static const Color nationalHolidayColor = Color(0xFFFFE66D);    // Yellow
  static const Color traditionalHolidayColor = Color(0xFFFF8B94); // Pink
  static const Color regionalHolidayColor = Color(0xFFA8E6CF);    // Green

  // Fixed Myanmar Holidays (Gregorian Calendar)
  static final List<MyanmarHoliday> _fixedHolidays = [
    // January
    MyanmarHoliday(
      name: "Independence Day",
      nameMyanmar: "လွတ်လပ်ရေးနေ့",
      date: DateTime(2025, 1, 4),
      type: MyanmarHolidayType.national,
      description: "Myanmar Independence Day",
      color: nationalHolidayColor,
    ),
    
    // February
    MyanmarHoliday(
      name: "Union Day",
      nameMyanmar: "ပြည်ထောင်စုနေ့",
      date: DateTime(2025, 2, 12),
      type: MyanmarHolidayType.national,
      description: "Panglong Agreement Day",
      color: nationalHolidayColor,
    ),
    
    // March
    MyanmarHoliday(
      name: "Peasants' Day",
      nameMyanmar: "တောင်သူလယ်သမားနေ့",
      date: DateTime(2025, 3, 2),
      type: MyanmarHolidayType.public,
      description: "Farmers' Day",
      color: publicHolidayColor,
    ),
    
    MyanmarHoliday(
      name: "Full Moon of Tabaung",
      nameMyanmar: "တပေါင်းလပြည့်နေ့",
      date: DateTime(2025, 3, 14), // This varies yearly
      type: MyanmarHolidayType.religious,
      description: "Buddhist religious day",
      color: religiousHolidayColor,
    ),
    
    // April - Thingyan Water Festival
    MyanmarHoliday(
      name: "Thingyan Day 1",
      nameMyanmar: "သင်္ကြန်နေ့ ၁",
      date: DateTime(2025, 4, 13),
      type: MyanmarHolidayType.traditional,
      description: "Myanmar New Year Water Festival",
      color: traditionalHolidayColor,
    ),
    
    MyanmarHoliday(
      name: "Thingyan Day 2",
      nameMyanmar: "သင်္ကြန်နေ့ ၂",
      date: DateTime(2025, 4, 14),
      type: MyanmarHolidayType.traditional,
      description: "Myanmar New Year Water Festival",
      color: traditionalHolidayColor,
    ),
    
    MyanmarHoliday(
      name: "Thingyan Day 3",
      nameMyanmar: "သင်္ကြန်နေ့ ၃",
      date: DateTime(2025, 4, 15),
      type: MyanmarHolidayType.traditional,
      description: "Myanmar New Year Water Festival",
      color: traditionalHolidayColor,
    ),
    
    MyanmarHoliday(
      name: "Myanmar New Year",
      nameMyanmar: "မြန်မာနှစ်သစ်ကူးနေ့",
      date: DateTime(2025, 4, 16),
      type: MyanmarHolidayType.national,
      description: "Myanmar New Year Day",
      color: nationalHolidayColor,
    ),
    
    // May
    MyanmarHoliday(
      name: "Labour Day",
      nameMyanmar: "အလုပ်သမားနေ့",
      date: DateTime(2025, 5, 1),
      type: MyanmarHolidayType.public,
      description: "International Workers' Day",
      color: publicHolidayColor,
    ),
    
    MyanmarHoliday(
      name: "Full Moon of Kason",
      nameMyanmar: "ကဆုန်လပြည့်နေ့",
      date: DateTime(2025, 5, 12), // Buddha Day - varies yearly
      type: MyanmarHolidayType.religious,
      description: "Buddha's Birth, Enlightenment and Death",
      color: religiousHolidayColor,
    ),
    
    // July
    MyanmarHoliday(
      name: "Martyrs' Day",
      nameMyanmar: "အာဇာနည်နေ့",
      date: DateTime(2025, 7, 19),
      type: MyanmarHolidayType.national,
      description: "Commemorating General Aung San and others",
      color: nationalHolidayColor,
    ),
    
    // October
    MyanmarHoliday(
      name: "Full Moon of Thadingyut",
      nameMyanmar: "သီတင်းကျွတ်လပြည့်နေ့",
      date: DateTime(2025, 10, 6), // Festival of Lights - varies yearly
      type: MyanmarHolidayType.religious,
      description: "End of Buddhist Lent, Festival of Lights",
      color: religiousHolidayColor,
    ),
    
    // November
    MyanmarHoliday(
      name: "Full Moon of Tazaungmone",
      nameMyanmar: "တန်ဆောင်မုန်းလပြည့်နေ့",
      date: DateTime(2025, 11, 5), // Varies yearly
      type: MyanmarHolidayType.religious,
      description: "Buddhist religious festival",
      color: religiousHolidayColor,
    ),
    
    // December
    MyanmarHoliday(
      name: "National Day",
      nameMyanmar: "အမျိုးသားနေ့",
      date: DateTime(2025, 12, 7),
      type: MyanmarHolidayType.national,
      description: "Student Union Day",
      color: nationalHolidayColor,
    ),
    
    MyanmarHoliday(
      name: "Christmas Day",
      nameMyanmar: "ခရစ်စမတ်နေ့",
      date: DateTime(2025, 12, 25),
      type: MyanmarHolidayType.public,
      description: "Christmas celebration",
      color: publicHolidayColor,
    ),
  ];

  // Get holidays for a specific year
  static List<MyanmarHoliday> getHolidaysForYear(int year) {
    return _fixedHolidays.map((holiday) => holiday.forYear(year)).toList();
  }

  // Get holidays for a specific month
  static List<MyanmarHoliday> getHolidaysForMonth(int year, int month) {
    return getHolidaysForYear(year)
        .where((holiday) => holiday.date.month == month)
        .toList();
  }

  // Get holiday for a specific date
  static MyanmarHoliday? getHolidayForDate(DateTime date) {
    try {
      return getHolidaysForYear(date.year).firstWhere(
        (holiday) => 
          holiday.date.year == date.year &&
          holiday.date.month == date.month &&
          holiday.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  // Check if a date is a holiday
  static bool isHoliday(DateTime date) {
    return getHolidayForDate(date) != null;
  }

  // Get holiday type name
  static String getHolidayTypeName(MyanmarHolidayType type) {
    switch (type) {
      case MyanmarHolidayType.public:
        return 'Public Holiday';
      case MyanmarHolidayType.religious:
        return 'Religious Holiday';
      case MyanmarHolidayType.national:
        return 'National Holiday';
      case MyanmarHolidayType.traditional:
        return 'Traditional Holiday';
      case MyanmarHolidayType.regional:
        return 'Regional Holiday';
    }
  }

  // Get holiday type icon
  static IconData getHolidayTypeIcon(MyanmarHolidayType type) {
    switch (type) {
      case MyanmarHolidayType.public:
        return Icons.public_rounded;
      case MyanmarHolidayType.religious:
        return Icons.temple_buddhist_rounded;
      case MyanmarHolidayType.national:
        return Icons.flag_rounded;
      case MyanmarHolidayType.traditional:
        return Icons.festival_rounded;
      case MyanmarHolidayType.regional:
        return Icons.location_city_rounded;
    }
  }

  // Get all holiday types with their colors
  static Map<MyanmarHolidayType, Color> getHolidayTypeColors() {
    return {
      MyanmarHolidayType.public: publicHolidayColor,
      MyanmarHolidayType.religious: religiousHolidayColor,
      MyanmarHolidayType.national: nationalHolidayColor,
      MyanmarHolidayType.traditional: traditionalHolidayColor,
      MyanmarHolidayType.regional: regionalHolidayColor,
    };
  }

  // Get upcoming holidays (next N holidays from today)
  static List<MyanmarHoliday> getUpcomingHolidays({int count = 5}) {
    final today = DateTime.now();
    final currentYear = today.year;
    final nextYear = currentYear + 1;
    
    // Get holidays for current and next year
    final allHolidays = [
      ...getHolidaysForYear(currentYear),
      ...getHolidaysForYear(nextYear),
    ];
    
    // Filter holidays that are today or in the future
    final upcomingHolidays = allHolidays
        .where((holiday) => 
          holiday.date.isAfter(today.subtract(const Duration(days: 1))))
        .toList();
    
    // Sort by date
    upcomingHolidays.sort((a, b) => a.date.compareTo(b.date));
    
    // Return the requested number of holidays
    return upcomingHolidays.take(count).toList();
  }

  // Get next holiday (the very next one)
  static MyanmarHoliday? getNextHoliday() {
    final upcoming = getUpcomingHolidays(count: 1);
    return upcoming.isNotEmpty ? upcoming.first : null;
  }

  // Get holidays in the next N days
  static List<MyanmarHoliday> getHolidaysInNextDays(int days) {
    final today = DateTime.now();
    final endDate = today.add(Duration(days: days));
    
    final currentYear = today.year;
    final nextYear = currentYear + 1;
    
    final allHolidays = [
      ...getHolidaysForYear(currentYear),
      ...getHolidaysForYear(nextYear),
    ];
    
    return allHolidays
        .where((holiday) => 
          holiday.date.isAfter(today.subtract(const Duration(days: 1))) &&
          holiday.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // Calculate days until a holiday
  static int daysUntilHoliday(MyanmarHoliday holiday) {
    final today = DateTime.now();
    final holidayDate = DateTime(holiday.date.year, holiday.date.month, holiday.date.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    
    return holidayDate.difference(todayDate).inDays;
  }

  // Format days until holiday in a user-friendly way
  static String formatDaysUntil(int days) {
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    if (days < 7) return 'In $days days';
    if (days < 14) return 'In ${(days / 7).floor()} week';
    if (days < 30) return 'In ${(days / 7).floor()} weeks';
    if (days < 60) return 'In ${(days / 30).floor()} month';
    return 'In ${(days / 30).floor()} months';
  }
}
