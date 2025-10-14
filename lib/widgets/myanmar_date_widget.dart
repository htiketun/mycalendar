import 'package:flutter/material.dart';
import '../services/myanmar_lunar_calendar_service.dart';
import '../utils/constants.dart';

class MyanmarDateWidget extends StatelessWidget {
  final DateTime gregorianDate;
  final bool compact;
  final bool showMyanmarNumbers;
  final TextStyle? textStyle;

  const MyanmarDateWidget({
    Key? key,
    required this.gregorianDate,
    this.compact = true,
    this.showMyanmarNumbers = false,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('MyanmarDateWidget building for date: $gregorianDate'); // Debug log
    
    try {
      final lunarService = MyanmarLunarCalendarService();
      final myanmarDate = lunarService.gregorianToMyanmarDate(gregorianDate);
      print('Myanmar date calculated: $myanmarDate'); // Debug log
      
      if (compact) {
        final widget = _buildCompactView(myanmarDate, lunarService);
        print('Built compact Myanmar widget for day: ${myanmarDate.day}'); // Debug log
        return widget;
      } else {
        return _buildDetailedView(myanmarDate, lunarService);
      }
    } catch (e, stackTrace) {
      print('Error in MyanmarDateWidget build: $e'); // Debug log
      print('Stack trace: $stackTrace'); // Debug log
      // Return a fallback widget
      return Container(
        constraints: const BoxConstraints(minHeight: 16, minWidth: 20),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.3),
          borderRadius: BorderRadius.circular(3),
        ),
        child: const Center(
          child: Text(
            '?',
            style: TextStyle(fontSize: 10, color: Colors.red),
          ),
        ),
      );
    }
  }

  Widget _buildCompactView(MyanmarDate myanmarDate, MyanmarLunarCalendarService lunarService) {
    // Show both Myanmar and English numbers for better readability
    final myanmarNumber = lunarService.getMyanmarNumber(myanmarDate.day);
    final englishNumber = myanmarDate.day.toString();
    final dayText = showMyanmarNumbers 
        ? '$myanmarNumber'  // Show Myanmar number
        : englishNumber;     // Show English number
    
    print('Building compact Myanmar date widget - Day: ${myanmarDate.day}, Myanmar: $myanmarNumber, Display: $dayText'); // Debug log
    
    return Container(
      constraints: const BoxConstraints(minHeight: 20, minWidth: 24),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: myanmarDate.isWaxing 
            ? AppColors.primaryColor.withOpacity(0.8)
            : AppColors.secondaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Text(
          dayText,
          style: (textStyle ?? AppTextStyles.caption).copyWith(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            fontFamily: 'Myanmar3', // Use Myanmar font if available
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedView(MyanmarDate myanmarDate, MyanmarLunarCalendarService lunarService) {
    final monthName = lunarService.getDisplayMonthName(myanmarDate.month);
    
    final dayText = showMyanmarNumbers 
        ? lunarService.getMyanmarNumber(myanmarDate.day)
        : myanmarDate.day.toString();
    
    final moonPhaseText = myanmarDate.isWaxing 
        ? (MyanmarLunarCalendarService.useEnglish ? 'Waxing' : 'လကြီးထွက်')
        : (MyanmarLunarCalendarService.useEnglish ? 'Waning' : 'လကျဆုတ်');

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingSmall),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            lunarService.getMyanmarDayColor(gregorianDate).withOpacity(0.1),
            lunarService.getMyanmarDayColor(gregorianDate).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(
          color: lunarService.getMyanmarDayColor(gregorianDate).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Myanmar month and day
          Row(
            children: [
              Expanded(
                child: Text(
                  '$monthName $dayText',
                  style: (textStyle ?? AppTextStyles.caption).copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: myanmarDate.isWaxing 
                      ? AppColors.primaryColor.withOpacity(0.2)
                      : AppColors.secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  moonPhaseText,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 8,
                    color: myanmarDate.isWaxing 
                        ? AppColors.primaryColor
                        : AppColors.secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 2),
          
          // Buddhist calendar events
          ...lunarService.getBuddhistCalendarEvents(gregorianDate).map((event) => 
            Container(
              margin: const EdgeInsets.only(top: 1),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                event,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 7,
                  color: AppColors.accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyanmarCalendarToggle extends StatefulWidget {
  final Function(bool) onToggle;
  final bool initialValue;

  const MyanmarCalendarToggle({
    Key? key,
    required this.onToggle,
    this.initialValue = false,
  }) : super(key: key);

  @override
  State<MyanmarCalendarToggle> createState() => _MyanmarCalendarToggleState();
}

class _MyanmarCalendarToggleState extends State<MyanmarCalendarToggle> {
  late bool _showMyanmarCalendar;

  @override
  void initState() {
    super.initState();
    _showMyanmarCalendar = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            color: _showMyanmarCalendar ? AppColors.primaryColor : AppColors.textSecondary,
            size: 18,
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          Text(
            'Myanmar Calendar',
            style: AppTextStyles.caption.copyWith(
              color: _showMyanmarCalendar ? AppColors.primaryColor : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          Switch(
            value: _showMyanmarCalendar,
            onChanged: (value) {
              setState(() {
                _showMyanmarCalendar = value;
              });
              widget.onToggle(value);
            },
            activeColor: AppColors.primaryColor,
            inactiveTrackColor: AppColors.surfaceColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class MyanmarLanguageToggle extends StatefulWidget {
  final Function(bool) onToggle;
  final bool initialValue;

  const MyanmarLanguageToggle({
    Key? key,
    required this.onToggle,
    this.initialValue = false,
  }) : super(key: key);

  @override
  State<MyanmarLanguageToggle> createState() => _MyanmarLanguageToggleState();
}

class _MyanmarLanguageToggleState extends State<MyanmarLanguageToggle> {
  late bool _useEnglish;

  @override
  void initState() {
    super.initState();
    _useEnglish = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'မြန်မာ',
            style: AppTextStyles.caption.copyWith(
              color: !_useEnglish ? AppColors.primaryColor : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          Switch(
            value: _useEnglish,
            onChanged: (value) {
              setState(() {
                _useEnglish = value;
              });
              MyanmarLunarCalendarService.setLanguage(value);
              widget.onToggle(value);
            },
            activeColor: AppColors.primaryColor,
            inactiveTrackColor: AppColors.surfaceColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          Text(
            'ENG',
            style: AppTextStyles.caption.copyWith(
              color: _useEnglish ? AppColors.primaryColor : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
