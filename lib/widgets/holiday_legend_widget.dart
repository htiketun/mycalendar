import 'package:flutter/material.dart';
import '../services/myanmar_holiday_service.dart';
import '../utils/constants.dart';

class HolidayLegendWidget extends StatelessWidget {
  const HolidayLegendWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Text(
                'Myanmar Holiday Types',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          ...MyanmarHolidayType.values.map((type) => _buildLegendItem(type)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(MyanmarHolidayType type) {
    final color = MyanmarHolidayService.getHolidayTypeColors()[type]!;
    final name = MyanmarHolidayService.getHolidayTypeName(type);
    final icon = MyanmarHolidayService.getHolidayTypeIcon(type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 3,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          Icon(icon, color: color, size: 16),
          const SizedBox(width: AppDimensions.paddingSmall),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.caption.copyWith(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
