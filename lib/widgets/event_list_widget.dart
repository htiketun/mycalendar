import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/constants.dart';
import '../utils/date_utils.dart' as app_date_utils;

class EventListWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<Event> events;
  final Function(Event) onEventTap;
  final VoidCallback onAddEvent;

  const EventListWidget({
    Key? key,
    required this.selectedDate,
    required this.events,
    required this.onEventTap,
    required this.onAddEvent,
  }) : super(key: key);

  List<Event> get _eventsForSelectedDate {
    return events.where((event) => 
      app_date_utils.DateUtils.isSameDay(event.date, selectedDate)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dayEvents = _eventsForSelectedDate;

    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and add button
            _buildHeader(context),
            const SizedBox(height: AppDimensions.paddingMedium),
            
            // Events list or empty state
            if (dayEvents.isEmpty)
              _buildEmptyState()
            else
              _buildEventsList(dayEvents),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                app_date_utils.DateUtils.formatDateShort(selectedDate),
                style: AppTextStyles.heading3,
              ),
              if (app_date_utils.DateUtils.isToday(selectedDate))
                Text(
                  AppStrings.today,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        
        ElevatedButton.icon(
          onPressed: onAddEvent,
          icon: const Icon(Icons.add, size: 18),
          label: const Text(AppStrings.addEvent),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingSmall,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            AppStrings.noEvents,
            style: AppTextStyles.bodyText.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<Event> dayEvents) {
    return Column(
      children: dayEvents.map((event) => _buildEventTile(event)).toList(),
    );
  }

  Widget _buildEventTile(Event event) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onEventTap(event),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              border: Border.all(
                color: AppColors.dividerColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                // Event color indicator
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.getEventColor(event.color),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                const SizedBox(width: AppDimensions.paddingMedium),
                
                // Event details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: AppTextStyles.heading3.copyWith(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      if (event.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          event.description,
                          style: AppTextStyles.caption,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Arrow icon
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
