import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart' as app_date_utils;

class WeeklyView extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<Event> events;
  final Function(Event) onEventTap;

  const WeeklyView({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.events,
    required this.onEventTap,
  }) : super(key: key);

  @override
  State<WeeklyView> createState() => _WeeklyViewState();
}

class _WeeklyViewState extends State<WeeklyView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  late DateTime _currentWeek;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentWeek = _getStartOfWeek(widget.selectedDate);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  DateTime _getStartOfWeek(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  List<DateTime> _getWeekDays() {
    return List.generate(7, (index) => _currentWeek.add(Duration(days: index)));
  }

  List<Event> _getEventsForDate(DateTime date) {
    return widget.events.where((event) =>
        app_date_utils.DateUtils.isSameDay(event.date, date)).toList();
  }

  void _previousWeek() {
    setState(() {
      _currentWeek = _currentWeek.subtract(const Duration(days: 7));
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _nextWeek() {
    setState(() {
      _currentWeek = _currentWeek.add(const Duration(days: 7));
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getWeekDays();
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPurple.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildWeekHeader(),
            _buildWeekDaysHeader(weekDays),
            Expanded(child: _buildWeekGrid(weekDays)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
          topRight: Radius.circular(AppDimensions.borderRadiusLarge),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousWeek,
            icon: const Icon(Icons.chevron_left_rounded, size: 28),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
            ),
          ),
          
          Column(
            children: [
              Text(
                'WEEK VIEW',
                style: AppTextStyles.neonText.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '${app_date_utils.DateUtils.formatDateShort(_currentWeek)} - ${app_date_utils.DateUtils.formatDateShort(_currentWeek.add(const Duration(days: 6)))}',
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          
          IconButton(
            onPressed: _nextWeek,
            icon: const Icon(Icons.chevron_right_rounded, size: 28),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaysHeader(List<DateTime> weekDays) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
      child: Row(
        children: weekDays.map((day) {
          final isSelected = app_date_utils.DateUtils.isSameDay(day, widget.selectedDate);
          final isToday = app_date_utils.DateUtils.isToday(day);
          
          return Expanded(
            child: GestureDetector(
              onTap: () => widget.onDateSelected(day),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? AppColors.secondaryGradient
                      : isToday
                          ? AppColors.successGradient
                          : null,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  border: isToday && !isSelected
                      ? Border.all(color: AppColors.neonGreen, width: 2)
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'][day.weekday - 1],
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected || isToday
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${day.day}',
                      style: AppTextStyles.heading3.copyWith(
                        color: isSelected || isToday
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeekGrid(List<DateTime> weekDays) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingSmall),
      child: Row(
        children: weekDays.map((day) {
          final dayEvents = _getEventsForDate(day);
          return Expanded(child: _buildDayColumn(day, dayEvents));
        }).toList(),
      ),
    );
  }

  Widget _buildDayColumn(DateTime day, List<Event> dayEvents) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          Expanded(
            child: dayEvents.isEmpty
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      border: Border.all(
                        color: AppColors.dividerColor.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'No events',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: dayEvents.length,
                    itemBuilder: (context, index) {
                      final event = dayEvents[index];
                      return _buildEventCard(event);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onEventTap(event),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.getEventColor(event.color).withOpacity(0.8),
                  AppColors.getEventColor(event.color).withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getEventColor(event.color).withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      event.categoryIcon,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.title,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (!event.isAllDay && event.startTime != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${event.startTime!.hour.toString().padLeft(2, '0')}:${event.startTime!.minute.toString().padLeft(2, '0')}',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 10,
                    ),
                  ),
                ],
                if (event.isCompleted) ...[
                  const SizedBox(height: 2),
                  const Icon(
                    Icons.check_circle,
                    size: 12,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}// Commit 10: 2025-02-04T16:29:38
// Commit 86: 2025-02-27T01:55:10
// Commit 93: 2025-03-01T03:53:33
// Commit 122: 2025-03-09T16:52:09
// Commit 149: 2025-03-17T16:25:52
// Commit 128: 2025-03-11T11:22:58
// Commit 65: 2025-02-20T21:46:22
// Commit 76: 2025-02-24T03:57:18
// Commit 86: 2025-02-27T02:25:28
// Commit 97: 2025-03-02T07:58:40
// Commit 120: 2025-03-09T02:46:34
// Commit 131: 2025-03-12T09:12:15
// Commit 179: 2025-03-26T13:11:45
// Commit 180: 2025-03-26T20:02:13
// Commit 181: 2025-03-27T02:49:53
// Commit 186: 2025-03-28T14:27:15
// Commit 69: 2025-02-22T02:18:20
// Commit 96: 2025-03-02T01:33:53
// Commit 119: 2025-03-08T19:43:51
// Commit 146: 2025-03-16T19:12:56
// Commit 154: 2025-03-19T03:19:54
// Commit 160: 2025-03-20T22:36:27
// Commit 161: 2025-03-21T05:03:28
// Commit 181: 2025-03-27T03:07:39
// Commit 11: 2025-02-04T23:16:54
// Commit 13: 2025-02-05T13:17:00
// Commit 32: 2025-02-11T04:13:59
// Commit 75: 2025-02-23T20:20:04
// Commit 80: 2025-02-25T08:11:22
// Commit 82: 2025-02-25T21:52:44
// Commit 86: 2025-02-27T02:34:56
// Commit 87: 2025-02-27T09:34:30
// Commit 89: 2025-02-27T23:40:33
// Commit 127: 2025-03-11T04:29:45
// Commit 135: 2025-03-13T13:10:23
// Commit 153: 2025-03-18T20:41:11
// Commit 178: 2025-03-26T05:44:22
// Commit 183: 2025-03-27T16:40:46
// Commit 4: 2025-02-02T21:56:01
// Commit 22: 2025-02-08T05:02:23
// Commit 25: 2025-02-09T02:13:51
// Commit 36: 2025-02-12T08:43:04
// Commit 44: 2025-02-14T16:40:01
// Commit 53: 2025-02-17T08:48:56
// Commit 84: 2025-02-26T11:54:52
// Commit 142: 2025-03-15T14:20:08
// Commit 153: 2025-03-18T20:38:22
// Commit 48: 2025-02-15T21:20:48
// Commit 52: 2025-02-17T01:18:27
// Commit 71: 2025-02-22T16:31:13
// Commit 105: 2025-03-04T17:00:55
// Commit 111: 2025-03-06T11:17:35
// Commit 121: 2025-03-09T09:56:41
