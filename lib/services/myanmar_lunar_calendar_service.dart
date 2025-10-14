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
}
