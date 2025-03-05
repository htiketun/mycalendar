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
}// Commit 22: 2025-02-08T05:08:19
// Commit 67: 2025-02-21T12:14:29
// Commit 104: 2025-03-04T09:16:47
// Commit 146: 2025-03-16T19:21:53
// Commit 152: 2025-03-18T13:53:51
// Commit 186: 2025-03-28T14:24:24
// Commit 189: 2025-03-29T11:28:39
// Commit 195: 2025-03-31T06:17:41
// Commit 40: 2025-02-13T12:35:27
// Commit 98: 2025-03-02T15:23:19
// Commit 169: 2025-03-23T13:30:44
// Commit 96: 2025-03-02T01:29:23
// Commit 149: 2025-03-17T16:38:56
// Commit 155: 2025-03-19T10:36:09
// Commit 163: 2025-03-21T19:54:05
// Commit 168: 2025-03-23T06:28:20
// Commit 180: 2025-03-26T20:02:13
// Commit 181: 2025-03-27T02:49:53
// Commit 192: 2025-03-30T08:24:37
// Commit 1: 2025-02-02T00:29:36
// Commit 14: 2025-02-05T20:54:50
// Commit 31: 2025-02-10T20:40:32
// Commit 49: 2025-02-16T04:00:09
// Commit 56: 2025-02-18T05:49:12
// Commit 67: 2025-02-21T11:43:13
// Commit 68: 2025-02-21T19:18:14
// Commit 69: 2025-02-22T02:18:20
// Commit 83: 2025-02-26T05:25:41
// Commit 86: 2025-02-27T02:19:35
// Commit 92: 2025-02-28T21:13:09
// Commit 94: 2025-03-01T11:14:40
// Commit 98: 2025-03-02T15:34:10
// Commit 99: 2025-03-02T22:14:23
// Commit 140: 2025-03-15T01:00:15
// Commit 145: 2025-03-16T12:29:28
// Commit 156: 2025-03-19T18:04:35
// Commit 160: 2025-03-20T22:36:27
// Commit 186: 2025-03-28T14:28:29
// Commit 190: 2025-03-29T18:57:45
// Commit 191: 2025-03-30T01:49:02
// Commit 6: 2025-02-03T12:01:12
// Commit 12: 2025-02-05T06:26:19
// Commit 24: 2025-02-08T19:24:09
// Commit 27: 2025-02-09T16:10:06
// Commit 36: 2025-02-12T07:52:15
// Commit 42: 2025-02-14T02:57:00
// Commit 47: 2025-02-15T14:27:21
// Commit 50: 2025-02-16T11:44:48
// Commit 64: 2025-02-20T14:46:39
// Commit 69: 2025-02-22T02:25:54
// Commit 84: 2025-02-26T12:08:13
// Commit 103: 2025-03-04T02:33:26
// Commit 106: 2025-03-04T23:30:30
// Commit 117: 2025-03-08T05:59:40
// Commit 170: 2025-03-23T20:43:23
// Commit 177: 2025-03-25T22:35:50
// Commit 2: 2025-02-02T07:19:28
// Commit 4: 2025-02-02T21:56:01
// Commit 14: 2025-02-05T20:35:47
// Commit 17: 2025-02-06T17:32:06
// Commit 19: 2025-02-07T07:27:12
// Commit 22: 2025-02-08T05:02:23
// Commit 24: 2025-02-08T19:21:47
// Commit 45: 2025-02-14T23:41:35
// Commit 63: 2025-02-20T07:23:54
// Commit 74: 2025-02-23T13:13:27
// Commit 77: 2025-02-24T10:52:24
// Commit 78: 2025-02-24T17:38:04
// Commit 79: 2025-02-25T00:47:41
// Commit 90: 2025-02-28T07:05:18
// Commit 110: 2025-03-06T04:36:15
// Commit 113: 2025-03-07T01:50:21
// Commit 119: 2025-03-08T20:15:07
// Commit 141: 2025-03-15T07:13:57
// Commit 147: 2025-03-17T02:40:38
// Commit 156: 2025-03-19T18:10:15
// Commit 166: 2025-03-22T16:19:03
// Commit 174: 2025-03-25T01:47:24
// Commit 175: 2025-03-25T08:45:36
// Commit 176: 2025-03-25T15:07:57
// Commit 183: 2025-03-27T17:08:09
// Commit 185: 2025-03-28T07:01:25
// Commit 197: 2025-03-31T19:47:02
// Commit 19: 2025-02-07T07:37:19
// Commit 25: 2025-02-09T02:53:51
// Commit 43: 2025-02-14T10:10:36
// Commit 56: 2025-02-18T05:34:42
// Commit 60: 2025-02-19T10:03:55
// Commit 64: 2025-02-20T14:31:52
// Commit 72: 2025-02-22T23:03:21
// Commit 80: 2025-02-25T07:24:46
// Commit 101: 2025-03-03T12:35:42
// Commit 103: 2025-03-04T02:55:59
// Commit 107: 2025-03-05T07:27:48
