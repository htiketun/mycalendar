import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart' as app_date_utils;

class DailyView extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final List<Event> events;
  final Function(Event) onEventTap;
  final VoidCallback onAddEvent;

  const DailyView({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.events,
    required this.onEventTap,
    required this.onAddEvent,
  }) : super(key: key);

  @override
  State<DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
    
    // Auto-scroll to current time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentTime() {
    if (app_date_utils.DateUtils.isToday(widget.selectedDate)) {
      final currentHour = DateTime.now().hour;
      final scrollOffset = (currentHour - 6) * 80.0; // 80px per hour
      if (scrollOffset > 0) {
        _scrollController.animateTo(
          scrollOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  List<Event> _getEventsForDate() {
    return widget.events.where((event) =>
        app_date_utils.DateUtils.isSameDay(event.date, widget.selectedDate)).toList()
      ..sort((a, b) {
        if (a.isAllDay && !b.isAllDay) return -1;
        if (!a.isAllDay && b.isAllDay) return 1;
        if (a.startTime != null && b.startTime != null) {
          return a.startTime!.compareTo(b.startTime!);
        }
        return a.title.compareTo(b.title);
      });
  }

  void _previousDay() {
    final previousDay = widget.selectedDate.subtract(const Duration(days: 1));
    widget.onDateSelected(previousDay);
    _animationController.reset();
    _animationController.forward();
  }

  void _nextDay() {
    final nextDay = widget.selectedDate.add(const Duration(days: 1));
    widget.onDateSelected(nextDay);
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final dayEvents = _getEventsForDate();
    final isToday = app_date_utils.DateUtils.isToday(widget.selectedDate);
    
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPink.withOpacity(0.3),
              blurRadius: 25,
              spreadRadius: 3,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildDayHeader(isToday),
            _buildAllDayEvents(dayEvents.where((e) => e.isAllDay).toList()),
            Expanded(child: _buildHourlyTimeline(dayEvents.where((e) => !e.isAllDay).toList())),
          ],
        ),
      ),
    );
  }

  Widget _buildDayHeader(bool isToday) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: isToday ? AppColors.successGradient : AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
          topRight: Radius.circular(AppDimensions.borderRadiusLarge),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousDay,
            icon: const Icon(Icons.chevron_left_rounded, size: 32),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
            ),
          ),
          
          Expanded(
            child: Column(
              children: [
                Text(
                  'DAY VIEW',
                  style: AppTextStyles.neonText.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  app_date_utils.DateUtils.formatDateLong(widget.selectedDate),
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                if (isToday)
                  Text(
                    'TODAY',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          
          Column(
            children: [
              IconButton(
                onPressed: _nextDay,
                icon: const Icon(Icons.chevron_right_rounded, size: 32),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: widget.onAddEvent,
                icon: const Icon(Icons.add_rounded, size: 24),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.neonGreen,
                  foregroundColor: AppColors.backgroundColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAllDayEvents(List<Event> allDayEvents) {
    if (allDayEvents.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.dividerColor.withOpacity(0.3),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ALL DAY EVENTS',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textAccent,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Wrap(
            spacing: AppDimensions.paddingSmall,
            runSpacing: AppDimensions.paddingSmall,
            children: allDayEvents.map((event) => _buildAllDayEventChip(event)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAllDayEventChip(Event event) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onEventTap(event),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
            vertical: AppDimensions.paddingSmall,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.getEventColor(event.color),
                AppColors.getEventColor(event.color).withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.getEventColor(event.color).withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                event.categoryIcon,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                event.title,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (event.isCompleted) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHourlyTimeline(List<Event> timedEvents) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Row(
        children: [
          // Time labels
          SizedBox(
            width: 60,
            child: Column(
              children: List.generate(24, (hour) {
                return SizedBox(
                  height: 80,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Timeline
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 24,
              itemBuilder: (context, hour) {
                final hourEvents = timedEvents.where((event) =>
                    event.startTime?.hour == hour).toList();
                final isCurrentHour = app_date_utils.DateUtils.isToday(widget.selectedDate) &&
                    DateTime.now().hour == hour;
                
                return _buildHourSlot(hour, hourEvents, isCurrentHour);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourSlot(int hour, List<Event> hourEvents, bool isCurrentHour) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.dividerColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        color: isCurrentHour
            ? AppColors.neonPurple.withOpacity(0.1)
            : Colors.transparent,
      ),
      child: Stack(
        children: [
          // Current time indicator
          if (isCurrentHour && app_date_utils.DateUtils.isToday(widget.selectedDate))
            Positioned(
              top: (DateTime.now().minute / 60) * 80,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.neonRed,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonRed,
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          
          // Events for this hour
          ...hourEvents.asMap().entries.map((entry) {
            final index = entry.key;
            final event = entry.value;
            return Positioned(
              left: index * 10.0,
              top: 8,
              right: 8,
              child: _buildTimedEventCard(event),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimedEventCard(Event event) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onEventTap(event),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingSmall),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.getEventColor(event.color),
                AppColors.getEventColor(event.color).withOpacity(0.8),
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
                  if (event.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.white,
                    ),
                ],
              ),
              if (event.startTime != null && event.endTime != null) ...[
                const SizedBox(height: 2),
                Text(
                  '${event.startTime!.hour.toString().padLeft(2, '0')}:${event.startTime!.minute.toString().padLeft(2, '0')} - ${event.endTime!.hour.toString().padLeft(2, '0')}:${event.endTime!.minute.toString().padLeft(2, '0')}',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 10,
                  ),
                ),
              ],
              if (event.location?.isNotEmpty == true) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 10,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        event.location!,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}// Commit 147: 2025-03-17T01:42:38
// Commit 155: 2025-03-19T11:02:40
// Commit 50: 2025-02-16T11:49:23
// Commit 67: 2025-02-21T11:25:51
// Commit 70: 2025-02-22T09:20:04
// Commit 48: 2025-02-15T21:02:38
// Commit 94: 2025-03-01T10:54:42
// Commit 103: 2025-03-04T03:08:22
// Commit 118: 2025-03-08T12:58:10
// Commit 136: 2025-03-13T20:00:36
// Commit 174: 2025-03-25T01:20:17
// Commit 195: 2025-03-31T05:54:55
// Commit 200: 2025-04-01T17:04:03
// Commit 24: 2025-02-08T19:30:15
// Commit 28: 2025-02-09T23:38:56
// Commit 40: 2025-02-13T12:55:26
// Commit 107: 2025-03-05T07:01:14
// Commit 168: 2025-03-23T06:21:40
// Commit 4: 2025-02-02T21:42:45
// Commit 25: 2025-02-09T02:32:44
// Commit 62: 2025-02-20T00:31:52
// Commit 112: 2025-03-06T18:35:06
// Commit 136: 2025-03-13T20:05:24
// Commit 165: 2025-03-22T09:52:53
// Commit 185: 2025-03-28T07:18:03
// Commit 73: 2025-02-23T06:25:44
// Commit 86: 2025-02-27T02:45:15
// Commit 101: 2025-03-03T12:49:53
// Commit 124: 2025-03-10T07:13:11
// Commit 144: 2025-03-16T05:15:19
// Commit 145: 2025-03-16T11:38:50
// Commit 150: 2025-03-17T23:47:57
// Commit 172: 2025-03-24T10:44:29
// Commit 183: 2025-03-27T17:08:09
// Commit 184: 2025-03-28T00:04:12
// Commit 1: 2025-02-02T00:57:40
// Commit 13: 2025-02-05T13:50:19
// Commit 22: 2025-02-08T05:04:28
// Commit 56: 2025-02-18T05:34:42
