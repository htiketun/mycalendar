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
}// Commit 70: 2025-02-22T09:25:21
// Commit 115: 2025-03-07T15:25:51
// Commit 9: 2025-02-04T09:38:21
// Commit 11: 2025-02-04T23:39:16
// Commit 22: 2025-02-08T05:29:44
// Commit 40: 2025-02-13T12:20:12
// Commit 49: 2025-02-16T04:29:13
// Commit 60: 2025-02-19T10:14:02
// Commit 87: 2025-02-27T09:52:03
// Commit 96: 2025-03-02T01:29:23
// Commit 138: 2025-03-14T09:59:44
// Commit 141: 2025-03-15T07:15:34
// Commit 148: 2025-03-17T08:46:08
// Commit 159: 2025-03-20T15:36:24
// Commit 182: 2025-03-27T09:55:16
// Commit 39: 2025-02-13T05:04:54
// Commit 51: 2025-02-16T18:14:32
// Commit 90: 2025-02-28T06:24:06
// Commit 120: 2025-03-09T03:30:50
// Commit 136: 2025-03-13T20:10:56
// Commit 159: 2025-03-20T14:55:50
// Commit 199: 2025-04-01T10:20:55
// Commit 7: 2025-02-03T18:37:29
// Commit 20: 2025-02-07T14:40:59
// Commit 64: 2025-02-20T14:46:39
// Commit 101: 2025-03-03T12:07:41
// Commit 108: 2025-03-05T13:59:46
// Commit 132: 2025-03-12T16:11:22
// Commit 141: 2025-03-15T07:50:04
// Commit 155: 2025-03-19T10:39:43
// Commit 169: 2025-03-23T14:17:59
// Commit 1: 2025-02-02T00:52:58
// Commit 13: 2025-02-05T13:56:58
// Commit 60: 2025-02-19T10:26:23
// Commit 75: 2025-02-23T20:07:47
// Commit 77: 2025-02-24T10:52:24
// Commit 99: 2025-03-02T22:34:16
// Commit 121: 2025-03-09T09:51:31
// Commit 156: 2025-03-19T18:10:15
// Commit 158: 2025-03-20T07:59:33
// Commit 61: 2025-02-19T17:17:04
// Commit 77: 2025-02-24T11:03:29
// Commit 83: 2025-02-26T05:19:58
