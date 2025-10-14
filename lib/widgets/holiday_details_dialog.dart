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
}
