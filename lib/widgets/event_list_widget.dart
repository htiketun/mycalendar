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
}// Commit 12: 2025-02-05T06:15:45
// Commit 145: 2025-03-16T12:17:09
// Commit 84: 2025-02-26T11:52:09
// Commit 36: 2025-02-12T07:51:21
// Commit 42: 2025-02-14T02:22:10
// Commit 50: 2025-02-16T11:02:46
// Commit 51: 2025-02-16T18:00:25
// Commit 75: 2025-02-23T20:34:37
// Commit 121: 2025-03-09T10:21:23
// Commit 122: 2025-03-09T17:13:39
// Commit 149: 2025-03-17T16:38:56
// Commit 157: 2025-03-20T00:57:37
// Commit 184: 2025-03-27T23:55:37
// Commit 10: 2025-02-04T16:21:01
// Commit 22: 2025-02-08T05:09:55
// Commit 56: 2025-02-18T05:49:12
// Commit 92: 2025-02-28T21:13:09
// Commit 95: 2025-03-01T18:23:34
// Commit 144: 2025-03-16T05:23:41
// Commit 178: 2025-03-26T05:17:51
// Commit 186: 2025-03-28T14:28:29
// Commit 188: 2025-03-29T04:39:08
// Commit 196: 2025-03-31T13:22:02
// Commit 39: 2025-02-13T05:04:08
// Commit 46: 2025-02-15T07:11:29
// Commit 47: 2025-02-15T14:27:21
// Commit 100: 2025-03-03T05:43:22
// Commit 133: 2025-03-12T22:48:31
// Commit 151: 2025-03-18T06:21:08
// Commit 181: 2025-03-27T02:48:54
// Commit 191: 2025-03-30T02:03:31
// Commit 27: 2025-02-09T16:43:27
// Commit 49: 2025-02-16T04:16:31
// Commit 54: 2025-02-17T15:52:22
// Commit 79: 2025-02-25T00:47:41
// Commit 82: 2025-02-25T22:25:56
// Commit 89: 2025-02-27T23:44:59
// Commit 98: 2025-03-02T15:01:29
// Commit 112: 2025-03-06T18:01:44
// Commit 147: 2025-03-17T02:40:38
// Commit 167: 2025-03-22T23:50:30
// Commit 171: 2025-03-24T04:01:11
// Commit 47: 2025-02-15T14:07:52
// Commit 51: 2025-02-16T18:22:50
// Commit 54: 2025-02-17T16:04:45
