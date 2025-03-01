import 'package:flutter/material.dart';
import '../services/myanmar_holiday_service.dart';
import '../utils/constants.dart';

class HolidayDetailsDialog extends StatelessWidget {
  final MyanmarHoliday holiday;

  const HolidayDetailsDialog({
    Key? key,
    required this.holiday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          border: Border.all(
            color: holiday.color.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: holiday.color.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(context),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: _buildContent(),
            ),
            
            // Action Button
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [holiday.color, holiday.color.withOpacity(0.7)],
        ),
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
            child: Icon(
              MyanmarHolidayService.getHolidayTypeIcon(holiday.type),
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
                  'Myanmar Holiday',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Text(
                  holiday.name,
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, size: 28),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Myanmar Name
        _buildInfoRow(
          'Myanmar Name',
          holiday.nameMyanmar,
          Icons.translate_rounded,
        ),
        
        const SizedBox(height: AppDimensions.paddingMedium),
        
        // Date
        _buildInfoRow(
          'Date',
          '${holiday.date.day}/${holiday.date.month}/${holiday.date.year}',
          Icons.calendar_today_rounded,
        ),
        
        const SizedBox(height: AppDimensions.paddingMedium),
        
        // Holiday Type
        _buildInfoRow(
          'Type',
          MyanmarHolidayService.getHolidayTypeName(holiday.type),
          MyanmarHolidayService.getHolidayTypeIcon(holiday.type),
        ),
        
        const SizedBox(height: AppDimensions.paddingMedium),
        
        // Description
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            border: Border.all(
              color: holiday.color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: holiday.color,
                    size: 20,
                  ),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Text(
                    'Description',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: holiday.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                holiday.description,
                style: AppTextStyles.bodyText.copyWith(
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingSmall),
          decoration: BoxDecoration(
            color: holiday.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: Icon(icon, color: holiday.color, size: 18),
        ),
        const SizedBox(width: AppDimensions.paddingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: holiday.color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingMedium,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
          ),
          child: const Text('Got it!'),
        ),
      ),
    );
  }
}// Commit 10: 2025-02-04T15:48:09
// Commit 20: 2025-02-07T15:09:24
// Commit 133: 2025-03-12T23:17:01
// Commit 24: 2025-02-08T19:36:22
// Commit 53: 2025-02-17T08:21:46
// Commit 56: 2025-02-18T05:37:00
// Commit 105: 2025-03-04T16:59:00
// Commit 128: 2025-03-11T11:23:15
// Commit 17: 2025-02-06T17:37:36
// Commit 50: 2025-02-16T11:09:48
// Commit 63: 2025-02-20T07:16:33
// Commit 72: 2025-02-22T23:08:34
// Commit 75: 2025-02-23T20:07:44
// Commit 78: 2025-02-24T18:09:12
// Commit 82: 2025-02-25T22:08:51
// Commit 110: 2025-03-06T04:12:59
// Commit 143: 2025-03-15T21:52:57
// Commit 173: 2025-03-24T18:25:20
// Commit 182: 2025-03-27T10:07:01
// Commit 12: 2025-02-05T06:26:19
// Commit 19: 2025-02-07T07:46:24
// Commit 67: 2025-02-21T11:35:49
// Commit 93: 2025-03-01T04:09:07
// Commit 105: 2025-03-04T16:57:41
// Commit 149: 2025-03-17T16:30:57
// Commit 193: 2025-03-30T15:47:13
// Commit 196: 2025-03-31T12:38:26
// Commit 56: 2025-02-18T06:21:39
// Commit 116: 2025-03-07T22:36:55
// Commit 122: 2025-03-09T16:53:15
// Commit 135: 2025-03-13T13:21:51
// Commit 152: 2025-03-18T13:34:01
// Commit 160: 2025-03-20T22:16:44
// Commit 164: 2025-03-22T02:39:25
// Commit 179: 2025-03-26T12:52:02
// Commit 188: 2025-03-29T04:56:41
// Commit 42: 2025-02-14T02:43:51
// Commit 44: 2025-02-14T17:19:11
// Commit 86: 2025-02-27T02:41:09
// Commit 93: 2025-03-01T03:53:41
