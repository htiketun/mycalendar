import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/myanmar_holiday_service.dart';
import '../widgets/holiday_details_dialog.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart' as app_date_utils;

class CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<Event> events;

  const CalendarWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.events,
  }) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = app_date_utils.DateUtils.getPreviousMonth(_currentMonth);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = app_date_utils.DateUtils.getNextMonth(_currentMonth);
    });
  }

  void _goToToday() {
    final today = DateTime.now();
    setState(() {
      _currentMonth = DateTime(today.year, today.month, 1);
    });
    widget.onDateSelected(today);
  }

  List<Event> _getEventsForDate(DateTime date) {
    return widget.events.where((event) => 
      app_date_utils.DateUtils.isSameDay(event.date, date)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final calendarDays = app_date_utils.DateUtils.getCalendarDays(_currentMonth);
    final weekDays = app_date_utils.DateUtils.getWeekDays();

    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          children: [
            // Calendar Header
            _buildCalendarHeader(),
            const SizedBox(height: AppDimensions.paddingMedium),
            
            // Week Days Header
            _buildWeekDaysHeader(weekDays),
            const SizedBox(height: AppDimensions.paddingSmall),
            
            // Calendar Grid
            _buildCalendarGrid(calendarDays),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _previousMonth,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Previous Month',
        ),
        
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: _goToToday,
              child: Text(
                app_date_utils.DateUtils.formatMonthYear(_currentMonth),
                style: AppTextStyles.heading2,
              ),
            ),
          ),
        ),
        
        IconButton(
          onPressed: _nextMonth,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Next Month',
        ),
      ],
    );
  }

  Widget _buildWeekDaysHeader(List<String> weekDays) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.secondaryColor.withOpacity(0.1),
            AppColors.primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: weekDays.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          final isWeekend = index == 0 || index == 6; // Sunday or Saturday
          
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isWeekend 
                      ? AppColors.secondaryColor
                      : AppColors.textSecondary,
                  shadows: isWeekend ? [
                    Shadow(
                      color: AppColors.secondaryColor.withOpacity(0.5),
                      blurRadius: 3,
                    ),
                  ] : null,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(List<DateTime> calendarDays) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        // Arcade-style background with subtle neon glow
        color: AppColors.surfaceColor.withOpacity(0.3),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.0, // Square cells for clean grid layout
        ),
        itemCount: calendarDays.length,
        itemBuilder: (context, index) {
          final date = calendarDays[index];
          final weekIndex = index ~/ 7; // Get the week row (0, 1, 2, etc.)
          return _buildCalendarDay(date, weekIndex);
        },
      ),
    );
  }

  Widget _buildCalendarDay(DateTime date, int weekIndex) {
    final isSelected = app_date_utils.DateUtils.isSameDay(date, widget.selectedDate);
    final isToday = app_date_utils.DateUtils.isToday(date);
    final isCurrentMonth = app_date_utils.DateUtils.isInCurrentMonth(date, _currentMonth);
    final dayEvents = _getEventsForDate(date);
    final hasEvents = dayEvents.isNotEmpty;
    final isEvenWeek = weekIndex % 2 == 0;
    final myanmarHoliday = MyanmarHolidayService.getHolidayForDate(date);
    final isHoliday = myanmarHoliday != null;

    return GestureDetector(
      onTap: () {
        widget.onDateSelected(date);
        if (isHoliday) {
          _showHolidayDetails(context, myanmarHoliday!);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor
              : isHoliday
                  ? myanmarHoliday!.color.withOpacity(0.3)
                  : isToday
                      ? AppColors.primaryColor.withOpacity(0.2)
                      : isEvenWeek
                          ? AppColors.cardColor.withOpacity(0.3)
                          : AppColors.surfaceColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.primaryColor, width: 2)
              : isHoliday && !isSelected
                  ? Border.all(color: myanmarHoliday!.color, width: 1.5)
                  : Border.all(
                      color: isEvenWeek 
                          ? AppColors.primaryColor.withOpacity(0.1)
                          : AppColors.secondaryColor.withOpacity(0.1),
                      width: 0.5,
                    ),
          // Add subtle gradient for arcade effect
          gradient: !isSelected && (hasEvents || isHoliday)
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.transparent,
                    isHoliday 
                        ? myanmarHoliday!.color.withOpacity(0.2)
                        : AppColors.getEventColor(dayEvents.first.color).withOpacity(0.1),
                  ],
                )
              : null,
        ),
        child: Stack(
          children: [
            // Day number
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected || isToday || isHoliday ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Colors.white
                          : isHoliday
                              ? myanmarHoliday!.color
                              : isCurrentMonth
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary.withOpacity(0.5),
                    ),
                  ),
                  // Myanmar calendar removed per user request
                ],
              ),
            ),
            
            // Holiday indicator (top-right corner)
            if (isHoliday)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : myanmarHoliday!.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: myanmarHoliday!.color.withOpacity(0.5),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            
            // Event indicator (bottom)
            if (hasEvents)
              Positioned(
                bottom: 4,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...dayEvents.take(3).map((event) => Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.white 
                            : event.categoryColor,
                        shape: BoxShape.circle,
                      ),
                    )),
                    if (dayEvents.length > 3)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.white.withOpacity(0.7)
                              : AppColors.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showHolidayDetails(BuildContext context, MyanmarHoliday holiday) {
    showDialog(
      context: context,
      builder: (context) => HolidayDetailsDialog(holiday: holiday),
    );
  }
}// Commit 83: 2025-02-26T04:48:25
// Commit 136: 2025-03-13T20:41:01
// Commit 159: 2025-03-20T15:17:16
// Commit 8: 2025-02-04T02:16:47
// Commit 54: 2025-02-17T16:04:57
// Commit 61: 2025-02-19T16:50:50
// Commit 64: 2025-02-20T14:57:00
// Commit 66: 2025-02-21T04:30:24
// Commit 68: 2025-02-21T19:13:29
// Commit 72: 2025-02-22T22:53:56
// Commit 156: 2025-03-19T17:33:03
// Commit 172: 2025-03-24T10:55:12
// Commit 177: 2025-03-25T22:13:50
// Commit 178: 2025-03-26T05:10:42
// Commit 77: 2025-02-24T10:16:55
// Commit 102: 2025-03-03T19:41:39
// Commit 106: 2025-03-05T00:14:46
// Commit 163: 2025-03-21T19:34:26
// Commit 164: 2025-03-22T02:17:12
// Commit 184: 2025-03-27T23:52:43
// Commit 197: 2025-03-31T20:13:41
// Commit 23: 2025-02-08T11:58:09
// Commit 37: 2025-02-12T15:06:35
// Commit 79: 2025-02-25T00:45:24
// Commit 81: 2025-02-25T14:44:25
// Commit 96: 2025-03-02T01:29:15
// Commit 130: 2025-03-12T01:38:10
// Commit 139: 2025-03-14T17:36:40
// Commit 174: 2025-03-25T00:56:32
// Commit 71: 2025-02-22T16:10:05
// Commit 119: 2025-03-08T20:15:07
// Commit 137: 2025-03-14T03:00:44
// Commit 146: 2025-03-16T18:49:19
// Commit 161: 2025-03-21T05:41:56
// Commit 163: 2025-03-21T19:53:06
// Commit 177: 2025-03-25T22:07:29
// Commit 181: 2025-03-27T02:55:07
// Commit 193: 2025-03-30T15:50:40
// Commit 196: 2025-03-31T13:04:05
