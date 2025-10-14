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
}
