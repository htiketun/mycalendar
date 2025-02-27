import 'package:flutter/material.dart';
import '../services/myanmar_holiday_service.dart';
import '../widgets/holiday_details_dialog.dart';
import '../utils/constants.dart';

class UpcomingHolidaysWidget extends StatelessWidget {
  const UpcomingHolidaysWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final upcomingHolidays = MyanmarHolidayService.getUpcomingHolidays(count: 5);
    
    if (upcomingHolidays.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: AppColors.cardColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.celebration_outlined,
              color: AppColors.textSecondary,
              size: 48,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              'No upcoming holidays found',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildHolidayList(context, upcomingHolidays),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
          topRight: Radius.circular(AppDimensions.borderRadiusLarge),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: const Icon(
              Icons.upcoming_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Myanmar Holidays',
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Next celebrations to look forward to',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSmall,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${MyanmarHolidayService.getUpcomingHolidays(count: 5).length}',
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidayList(BuildContext context, List<MyanmarHoliday> holidays) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        children: holidays.asMap().entries.map((entry) {
          final index = entry.key;
          final holiday = entry.value;
          final isLast = index == holidays.length - 1;
          
          return Column(
            children: [
              _buildHolidayItem(context, holiday, index == 0),
              if (!isLast) 
                const SizedBox(height: AppDimensions.paddingMedium),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHolidayItem(BuildContext context, MyanmarHoliday holiday, bool isNext) {
    final daysUntil = MyanmarHolidayService.daysUntilHoliday(holiday);
    final daysText = MyanmarHolidayService.formatDaysUntil(daysUntil);
    
    return GestureDetector(
      onTap: () => _showHolidayDetails(context, holiday),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: isNext 
              ? holiday.color.withOpacity(0.1)
              : AppColors.cardColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border: Border.all(
            color: isNext 
                ? holiday.color.withOpacity(0.5)
                : holiday.color.withOpacity(0.3),
            width: isNext ? 2 : 1,
          ),
          boxShadow: isNext ? [
            BoxShadow(
              color: holiday.color.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ] : null,
        ),
        child: Row(
          children: [
            // Holiday Type Icon
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingSmall),
              decoration: BoxDecoration(
                color: holiday.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              child: Icon(
                MyanmarHolidayService.getHolidayTypeIcon(holiday.type),
                color: holiday.color,
                size: 20,
              ),
            ),
            
            const SizedBox(width: AppDimensions.paddingMedium),
            
            // Holiday Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          holiday.name,
                          style: AppTextStyles.bodyText.copyWith(
                            fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
                            color: isNext ? holiday.color : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isNext)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: holiday.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'NEXT',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    holiday.nameMyanmar,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: holiday.color,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${holiday.date.day}/${holiday.date.month}/${holiday.date.year}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: holiday.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          daysText,
                          style: AppTextStyles.caption.copyWith(
                            color: holiday.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: AppDimensions.paddingSmall),
            
            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: holiday.color.withOpacity(0.7),
              size: 16,
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
}// Commit 19: 2025-02-07T08:21:38
// Commit 90: 2025-02-28T06:59:27
// Commit 104: 2025-03-04T09:26:48
// Commit 133: 2025-03-12T23:33:25
// Commit 142: 2025-03-15T14:22:22
// Commit 146: 2025-03-16T18:52:31
// Commit 151: 2025-03-18T06:58:11
// Commit 165: 2025-03-22T10:02:17
// Commit 168: 2025-03-23T06:28:20
// Commit 173: 2025-03-24T17:50:22
// Commit 188: 2025-03-29T04:24:09
// Commit 1: 2025-02-02T00:29:36
// Commit 132: 2025-03-12T16:00:02
// Commit 135: 2025-03-13T13:12:40
// Commit 153: 2025-03-18T21:06:29
// Commit 180: 2025-03-26T19:43:19
// Commit 9: 2025-02-04T08:48:16
// Commit 49: 2025-02-16T04:33:46
// Commit 53: 2025-02-17T08:54:07
// Commit 54: 2025-02-17T15:33:47
// Commit 92: 2025-02-28T20:33:46
// Commit 118: 2025-03-08T12:35:58
// Commit 121: 2025-03-09T09:51:25
// Commit 131: 2025-03-12T08:57:59
// Commit 147: 2025-03-17T01:43:32
// Commit 162: 2025-03-21T12:44:43
// Commit 187: 2025-03-28T21:09:04
// Commit 57: 2025-02-18T13:12:25
// Commit 58: 2025-02-18T19:53:07
// Commit 83: 2025-02-26T04:45:21
// Commit 125: 2025-03-10T14:26:54
// Commit 154: 2025-03-19T03:56:41
// Commit 174: 2025-03-25T01:47:24
// Commit 8: 2025-02-04T02:07:51
// Commit 28: 2025-02-09T23:37:06
// Commit 73: 2025-02-23T05:57:41
// Commit 88: 2025-02-27T16:51:45
