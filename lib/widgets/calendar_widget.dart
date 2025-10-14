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
}