import 'package:flutter/material.dart';
import '../utils/constants.dart';

enum MyanmarMonth {
  tagu,      // တန်ခူး (March-April)
  kason,     // ကဆုန် (April-May)
  nayon,     // နယုန် (May-June)
  waso,      // ဝါဆို (June-July)
  wagaung,   // ဝါခေါင် (July-August)
  tawthalin, // တော်သလင်း (August-September)
  thadingyut,// သီတင်းကျွတ် (September-October)
  tazaungmon,// တန်ဆောင်မုန်း (October-November)
  natdaw,    // နတ်တော် (November-December)
  pyatho,    // ပြာသို (December-January)
  tabodwe,   // တပေါင်း (January-February)  
  tabaung,   // တပေါင်း (February-March)
}

enum MyanmarWeekDay {
  sunday,    // တနင်္ဂနွေ
  monday,    // တနင်္လာ
  tuesday,   // အင်္ဂါ
  wednesday, // ဗုဒ္ဓဟူး
  thursday,  // ကြာသပတေး
  friday,    // သောကြာ
  saturday,  // စနေ
}

class MyanmarDate {
  final int year;
  final MyanmarMonth month;
  final int day;
  final MyanmarWeekDay weekday;
  final bool isWaxing; // လကြီးထွက် (waxing) or လကျဆုတ် (waning)
  final String moonPhase;

  const MyanmarDate({
    required this.year,
    required this.month,
    required this.day,
    required this.weekday,
    required this.isWaxing,
    required this.moonPhase,
  });

  @override
  String toString() {
    return 'Myanmar Year ${year}, ${MyanmarLunarCalendarService.getMonthName(month)} ${day}${isWaxing ? " လကြီးထွက်" : " လကျဆုတ်"}';
  }
}

class MyanmarLunarCalendarService {
  static final MyanmarLunarCalendarService _instance = MyanmarLunarCalendarService._internal();
  factory MyanmarLunarCalendarService() => _instance;
  MyanmarLunarCalendarService._internal();

  // Myanmar New Year typically falls around April 13-16
  static const int myanmarEraStart = 638; // Myanmar Era started in 638 CE
  static const int gregorianToMyanmarOffset = 1362; // Approximate offset

  /// Convert Gregorian date to Myanmar lunar date
  MyanmarDate gregorianToMyanmarDate(DateTime gregorianDate) {
    try {
      // This is a simplified conversion - in reality, Myanmar lunar calendar 
      // calculations are extremely complex and require astronomical calculations
      
      final myanmarYear = gregorianDate.year - gregorianToMyanmarOffset;
      final dayOfYear = gregorianDate.difference(DateTime(gregorianDate.year, 1, 1)).inDays + 1;
      
      // Approximate month based on day of year
      final MyanmarMonth month = _getApproximateMyanmarMonth(dayOfYear);
      
      // Calculate approximate day within the month
      final int dayInMonth = _calculateMyanmarDayInMonth(gregorianDate, month);
      
      // Determine moon phase (simplified)
      final bool isWaxing = _isWaxingMoon(gregorianDate);
      final String moonPhase = _getMoonPhase(gregorianDate);
      
      // Get Myanmar weekday
      final MyanmarWeekDay weekday = _getMyanmarWeekday(gregorianDate.weekday);

      final result = MyanmarDate(
        year: myanmarYear,
        month: month,
        day: dayInMonth,
        weekday: weekday,
        isWaxing: isWaxing,
        moonPhase: moonPhase,
      );
      
      print('Converted $gregorianDate to Myanmar date: $result'); // Debug log
      return result;
    } catch (e) {
      print('Error converting to Myanmar date: $e'); // Debug log
      // Return a fallback Myanmar date
      return MyanmarDate(
        year: gregorianDate.year - gregorianToMyanmarOffset,
        month: MyanmarMonth.tagu,
        day: 1,
        weekday: MyanmarWeekDay.sunday,
        isWaxing: true,
        moonPhase: 'လသစ်',
      );
    }
  }

  /// Get Myanmar month names in Myanmar script
  static String getMonthName(MyanmarMonth month) {
    const monthNames = {
      MyanmarMonth.tagu: 'တန်ခူး',
      MyanmarMonth.kason: 'ကဆုန်',
      MyanmarMonth.nayon: 'နယုန်',
      MyanmarMonth.waso: 'ဝါဆို',
      MyanmarMonth.wagaung: 'ဝါခေါင်',
      MyanmarMonth.tawthalin: 'တော်သလင်း',
      MyanmarMonth.thadingyut: 'သီတင်းကျွတ်',
      MyanmarMonth.tazaungmon: 'တန်ဆောင်မုန်း',
      MyanmarMonth.natdaw: 'နတ်တော်',
      MyanmarMonth.pyatho: 'ပြာသို',
      MyanmarMonth.tabodwe: 'တပေါင်း',
      MyanmarMonth.tabaung: 'တပေါင်း',
    };
    
    return monthNames[month] ?? '';
  }

  /// Get Myanmar month names in English
  static String getMonthNameEnglish(MyanmarMonth month) {
    const monthNames = {
      MyanmarMonth.tagu: 'Tagu',
      MyanmarMonth.kason: 'Kason',
      MyanmarMonth.nayon: 'Nayon',
      MyanmarMonth.waso: 'Waso',
      MyanmarMonth.wagaung: 'Wagaung',
      MyanmarMonth.tawthalin: 'Tawthalin',
      MyanmarMonth.thadingyut: 'Thadingyut',
      MyanmarMonth.tazaungmon: 'Tazaungmon',
      MyanmarMonth.natdaw: 'Natdaw',
      MyanmarMonth.pyatho: 'Pyatho',
      MyanmarMonth.tabodwe: 'Tabodwe',
      MyanmarMonth.tabaung: 'Tabaung',
    };
    
    return monthNames[month] ?? '';
  }

  /// Get Myanmar weekday names
  static String getWeekdayName(MyanmarWeekDay weekday) {
    const weekdayNames = {
      MyanmarWeekDay.sunday: 'တနင်္ဂနွေ',
      MyanmarWeekDay.monday: 'တနင်္လာ',
      MyanmarWeekDay.tuesday: 'အင်္ဂါ',
      MyanmarWeekDay.wednesday: 'ဗုဒ္ဓဟူး',
      MyanmarWeekDay.thursday: 'ကြာသပတေး',
      MyanmarWeekDay.friday: 'သောကြာ',
      MyanmarWeekDay.saturday: 'စနေ',
    };
    
    return weekdayNames[weekday] ?? '';
  }

  /// Get Myanmar weekday names in English
  static String getWeekdayNameEnglish(MyanmarWeekDay weekday) {
    const weekdayNames = {
      MyanmarWeekDay.sunday: 'Sunday',
      MyanmarWeekDay.monday: 'Monday',
      MyanmarWeekDay.tuesday: 'Tuesday',
      MyanmarWeekDay.wednesday: 'Wednesday',
      MyanmarWeekDay.thursday: 'Thursday',
      MyanmarWeekDay.friday: 'Friday',
      MyanmarWeekDay.saturday: 'Saturday',
    };
    
    return weekdayNames[weekday] ?? '';
  }

  /// Convert Gregorian weekday to Myanmar weekday
  MyanmarWeekDay _getMyanmarWeekday(int gregorianWeekday) {
    // Gregorian: Monday = 1, Sunday = 7
    // Convert to Myanmar weekday enum
    switch (gregorianWeekday) {
      case 1: return MyanmarWeekDay.monday;
      case 2: return MyanmarWeekDay.tuesday;
      case 3: return MyanmarWeekDay.wednesday;
      case 4: return MyanmarWeekDay.thursday;
      case 5: return MyanmarWeekDay.friday;
      case 6: return MyanmarWeekDay.saturday;
      case 7: return MyanmarWeekDay.sunday;
      default: return MyanmarWeekDay.sunday;
    }
  }

  /// Get approximate Myanmar month based on day of year
  MyanmarMonth _getApproximateMyanmarMonth(int dayOfYear) {
    // This is a simplified mapping - actual lunar months vary
    if (dayOfYear <= 31) return MyanmarMonth.pyatho;       // Jan
    if (dayOfYear <= 59) return MyanmarMonth.tabodwe;      // Feb
    if (dayOfYear <= 90) return MyanmarMonth.tabaung;      // Mar
    if (dayOfYear <= 120) return MyanmarMonth.tagu;        // Apr
    if (dayOfYear <= 151) return MyanmarMonth.kason;       // May
    if (dayOfYear <= 181) return MyanmarMonth.nayon;       // Jun
    if (dayOfYear <= 212) return MyanmarMonth.waso;        // Jul
    if (dayOfYear <= 243) return MyanmarMonth.wagaung;     // Aug
    if (dayOfYear <= 273) return MyanmarMonth.tawthalin;   // Sep
    if (dayOfYear <= 304) return MyanmarMonth.thadingyut;  // Oct
    if (dayOfYear <= 334) return MyanmarMonth.tazaungmon;  // Nov
    return MyanmarMonth.natdaw;                            // Dec
  }

  /// Calculate Myanmar day in month (simplified)
  int _calculateMyanmarDayInMonth(DateTime date, MyanmarMonth month) {
    // Simplified calculation - actual lunar calendar days vary
    return (date.day % 29) + 1; // Lunar months are approximately 29.5 days
  }

  /// Determine if moon is waxing (simplified)
  bool _isWaxingMoon(DateTime date) {
    // Simplified calculation based on day of month
    // In reality, this requires proper lunar phase calculations
    final dayInLunarCycle = date.day % 29;
    return dayInLunarCycle <= 14;
  }

  /// Get moon phase description
  String _getMoonPhase(DateTime date) {
    final dayInLunarCycle = date.day % 29;
    
    if (dayInLunarCycle == 1) return 'လသစ်'; // New Moon
    if (dayInLunarCycle <= 7) return 'လကြီးထွက်'; // Waxing Crescent
    if (dayInLunarCycle == 15) return 'လပြည့်'; // Full Moon
    if (dayInLunarCycle <= 22) return 'လကျဆုတ်'; // Waning Crescent
    return 'လသေး'; // Dark Moon
  }

  /// Format Myanmar date for display
  String formatMyanmarDate(MyanmarDate myanmarDate, {bool showWeekday = true, bool useEnglish = false}) {
    final monthName = useEnglish 
        ? getMonthNameEnglish(myanmarDate.month)
        : getMonthName(myanmarDate.month);
    
    final weekdayName = useEnglish
        ? getWeekdayNameEnglish(myanmarDate.weekday)
        : getWeekdayName(myanmarDate.weekday);
    
    final moonPhaseText = myanmarDate.isWaxing 
        ? (useEnglish ? 'Waxing' : 'လကြီးထွက်')
        : (useEnglish ? 'Waning' : 'လကျဆုတ်');
    
    String formatted = '$monthName ${myanmarDate.day} $moonPhaseText';
    
    if (showWeekday) {
      formatted = '$weekdayName, $formatted';
    }
    
    return formatted;
  }

  /// Get Myanmar New Year date for a given Gregorian year
  DateTime getMyanmarNewYearDate(int gregorianYear) {
    // Myanmar New Year (Thingyan) typically falls on April 13-16
    // This is a simplified calculation
    return DateTime(gregorianYear, 4, 13);
  }

  /// Check if a date is a Myanmar auspicious day
  bool isAuspiciousDay(DateTime date) {
    final myanmarDate = gregorianToMyanmarDate(date);
    
    // Full moon and new moon days are generally auspicious
    final dayInLunarCycle = date.day % 29;
    return dayInLunarCycle == 1 || dayInLunarCycle == 15;
  }

  /// Get Myanmar Buddhist calendar events for a date
  List<String> getBuddhistCalendarEvents(DateTime date) {
    final events = <String>[];
    final myanmarDate = gregorianToMyanmarDate(date);
    final dayInLunarCycle = date.day % 29;
    
    // Full moon day
    if (dayInLunarCycle == 15) {
      events.add(useEnglish ? 'Full Moon Day' : 'လပြည့်နေ့');
    }
    
    // New moon day
    if (dayInLunarCycle == 1) {
      events.add(useEnglish ? 'New Moon Day' : 'လသစ်နေ့');
    }
    
    // Uposatha days (Buddhist observance days)
    if ([1, 8, 15, 23].contains(dayInLunarCycle)) {
      events.add(useEnglish ? 'Uposatha Day' : 'ဥပုသ်နေ့');
    }
    
    return events;
  }

  /// Get Myanmar traditional day color
  Color getMyanmarDayColor(DateTime date) {
    final myanmarDate = gregorianToMyanmarDate(date);
    
    // Colors based on weekday (traditional Myanmar astrology)
    switch (myanmarDate.weekday) {
      case MyanmarWeekDay.sunday:
        return Colors.red.shade300;
      case MyanmarWeekDay.monday:
        return Colors.yellow.shade300;
      case MyanmarWeekDay.tuesday:
        return Colors.pink.shade300;
      case MyanmarWeekDay.wednesday:
        return Colors.green.shade300;
      case MyanmarWeekDay.thursday:
        return Colors.orange.shade300;
      case MyanmarWeekDay.friday:
        return Colors.blue.shade300;
      case MyanmarWeekDay.saturday:
        return Colors.purple.shade300;
    }
  }

  /// Get Myanmar numbers (traditional script)
  String getMyanmarNumber(int number) {
    const myanmarDigits = {
      0: '၀',
      1: '၁',
      2: '၂',
      3: '၃',
      4: '၄',
      5: '၅',
      6: '၆',
      7: '၇',
      8: '၈',
      9: '၉',
    };
    
    return number.toString().split('').map((digit) {
      return myanmarDigits[int.parse(digit)] ?? digit;
    }).join();
  }

  /// Get month name based on current language setting
  String getDisplayMonthName(MyanmarMonth month) {
    return useEnglish ? getMonthNameEnglish(month) : getMonthName(month);
  }

  /// Get weekday name based on current language setting
  String getDisplayWeekdayName(MyanmarWeekDay weekday) {
    return useEnglish ? getWeekdayNameEnglish(weekday) : getWeekdayName(weekday);
  }

  // Global setting for language preference
  static bool useEnglish = false;
  
  /// Toggle between Myanmar and English display
  static void setLanguage(bool english) {
    useEnglish = english;
  }
}// Commit 82: 2025-02-25T22:28:21
// Commit 113: 2025-03-07T01:40:13
// Commit 142: 2025-03-15T14:31:32
// Commit 151: 2025-03-18T06:09:06
// Commit 163: 2025-03-21T19:47:59
// Commit 175: 2025-03-25T08:43:00
// Commit 187: 2025-03-28T21:16:30
// Commit 26: 2025-02-09T09:28:05
// Commit 121: 2025-03-09T10:35:45
// Commit 187: 2025-03-28T21:18:50
// Commit 191: 2025-03-30T01:15:45
// Commit 199: 2025-04-01T10:37:38
// Commit 3: 2025-02-02T14:17:50
// Commit 28: 2025-02-09T23:35:12
// Commit 38: 2025-02-12T22:56:06
// Commit 39: 2025-02-13T05:06:21
// Commit 46: 2025-02-15T07:00:52
// Commit 51: 2025-02-16T18:00:25
// Commit 75: 2025-02-23T20:34:37
// Commit 79: 2025-02-25T01:13:24
// Commit 89: 2025-02-27T23:43:23
// Commit 92: 2025-02-28T20:23:39
// Commit 98: 2025-03-02T14:49:32
// Commit 108: 2025-03-05T13:47:53
// Commit 114: 2025-03-07T08:16:52
// Commit 117: 2025-03-08T05:38:59
// Commit 118: 2025-03-08T12:58:10
// Commit 119: 2025-03-08T20:08:10
// Commit 132: 2025-03-12T16:05:11
// Commit 134: 2025-03-13T06:13:44
// Commit 139: 2025-03-14T17:52:43
// Commit 148: 2025-03-17T08:46:08
// Commit 152: 2025-03-18T14:03:35
// Commit 164: 2025-03-22T02:31:44
// Commit 170: 2025-03-23T21:29:47
// Commit 184: 2025-03-27T23:55:37
// Commit 200: 2025-04-01T17:04:03
// Commit 8: 2025-02-04T02:14:09
// Commit 20: 2025-02-07T15:28:29
// Commit 54: 2025-02-17T15:39:40
// Commit 62: 2025-02-20T00:18:01
// Commit 71: 2025-02-22T16:07:32
// Commit 78: 2025-02-24T18:09:12
// Commit 85: 2025-02-26T19:06:11
// Commit 93: 2025-03-01T03:44:33
// Commit 97: 2025-03-02T08:08:09
// Commit 113: 2025-03-07T01:56:20
// Commit 116: 2025-03-07T22:45:02
// Commit 118: 2025-03-08T12:52:30
// Commit 121: 2025-03-09T09:44:40
// Commit 134: 2025-03-13T06:26:55
// Commit 153: 2025-03-18T21:06:29
// Commit 173: 2025-03-24T18:25:20
// Commit 187: 2025-03-28T21:26:33
// Commit 17: 2025-02-06T17:38:22
// Commit 26: 2025-02-09T09:40:06
// Commit 30: 2025-02-10T14:06:24
// Commit 45: 2025-02-14T23:53:06
// Commit 56: 2025-02-18T06:19:54
// Commit 60: 2025-02-19T09:44:55
// Commit 63: 2025-02-20T07:45:55
// Commit 65: 2025-02-20T21:31:06
// Commit 85: 2025-02-26T19:21:28
// Commit 97: 2025-03-02T08:00:13
// Commit 110: 2025-03-06T04:41:41
// Commit 119: 2025-03-08T19:33:46
// Commit 142: 2025-03-15T14:40:18
// Commit 148: 2025-03-17T09:39:40
// Commit 162: 2025-03-21T12:44:43
// Commit 182: 2025-03-27T10:24:48
// Commit 190: 2025-03-29T19:06:13
// Commit 199: 2025-04-01T10:07:46
// Commit 15: 2025-02-06T03:44:55
// Commit 18: 2025-02-07T00:55:03
// Commit 25: 2025-02-09T02:13:51
// Commit 30: 2025-02-10T14:03:15
// Commit 39: 2025-02-13T05:38:28
// Commit 61: 2025-02-19T17:26:28
// Commit 66: 2025-02-21T05:10:09
// Commit 88: 2025-02-27T16:18:22
// Commit 91: 2025-02-28T13:49:21
// Commit 106: 2025-03-05T00:17:20
// Commit 111: 2025-03-06T11:01:24
// Commit 125: 2025-03-10T14:26:54
// Commit 138: 2025-03-14T10:31:28
// Commit 140: 2025-03-15T00:15:34
// Commit 152: 2025-03-18T13:34:01
// Commit 177: 2025-03-25T22:07:29
// Commit 192: 2025-03-30T08:21:23
// Commit 195: 2025-03-31T06:01:23
// Commit 10: 2025-02-04T16:11:04
// Commit 13: 2025-02-05T13:50:19
// Commit 14: 2025-02-05T20:32:22
// Commit 20: 2025-02-07T15:01:11
// Commit 23: 2025-02-08T12:42:52
// Commit 24: 2025-02-08T19:06:02
