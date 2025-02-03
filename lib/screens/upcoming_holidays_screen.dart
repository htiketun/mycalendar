import 'package:flutter/material.dart';
import '../services/myanmar_holiday_service.dart';
import '../widgets/upcoming_holidays_widget.dart';
import '../widgets/holiday_legend_widget.dart';
import '../utils/constants.dart';

class UpcomingHolidaysScreen extends StatefulWidget {
  const UpcomingHolidaysScreen({Key? key}) : super(key: key);

  @override
  State<UpcomingHolidaysScreen> createState() => _UpcomingHolidaysScreenState();
}

class _UpcomingHolidaysScreenState extends State<UpcomingHolidaysScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _selectedPeriod = 30; // Days to look ahead
  List<MyanmarHoliday> _holidaysInPeriod = [];

  @override
  void initState() {
    super.initState();
    _loadHolidays();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadHolidays() {
    setState(() {
      _holidaysInPeriod = MyanmarHolidayService.getHolidaysInNextDays(_selectedPeriod);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              fixedSize: const Size(48, 48),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Holidays',
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Myanmar celebrations & festivals ahead',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: const Icon(
              Icons.celebration_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Selector
          _buildPeriodSelector(),
          
          const SizedBox(height: AppDimensions.paddingLarge),
          
          // Quick Upcoming Holidays Card
          const UpcomingHolidaysWidget(),
          
          const SizedBox(height: AppDimensions.paddingLarge),
          
          // Holidays in Selected Period
          _buildHolidaysInPeriod(),
          
          const SizedBox(height: AppDimensions.paddingLarge),
          
          // Holiday Legend
          const HolidayLegendWidget(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = [7, 30, 90, 365];
    final periodNames = ['Week', 'Month', '3 Months', 'Year'];
    
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Look ahead',
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Row(
            children: periods.asMap().entries.map((entry) {
              final index = entry.key;
              final days = entry.value;
              final name = periodNames[index];
              final isSelected = _selectedPeriod == days;
              
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < periods.length - 1 ? 8.0 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPeriod = days;
                      });
                      _loadHolidays();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : AppColors.dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        name,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? AppColors.primaryColor : AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidaysInPeriod() {
    if (_holidaysInPeriod.isEmpty) {
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
              Icons.event_busy_rounded,
              color: AppColors.textSecondary,
              size: 48,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              'No holidays in the next ${_selectedPeriod == 7 ? "week" : _selectedPeriod == 30 ? "month" : _selectedPeriod == 90 ? "3 months" : "year"}',
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: AppDimensions.paddingSmall),
                Text(
                  'Holidays in ${_selectedPeriod == 7 ? "Next Week" : _selectedPeriod == 30 ? "Next Month" : _selectedPeriod == 90 ? "Next 3 Months" : "Next Year"}',
                  style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_holidaysInPeriod.length}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Holiday List
          ..._holidaysInPeriod.asMap().entries.map((entry) {
            final index = entry.key;
            final holiday = entry.value;
            final isLast = index == _holidaysInPeriod.length - 1;
            final daysUntil = MyanmarHolidayService.daysUntilHoliday(holiday);
            final daysText = MyanmarHolidayService.formatDaysUntil(daysUntil);
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLarge,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    decoration: BoxDecoration(
                      color: holiday.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      border: Border.all(
                        color: holiday.color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: holiday.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            MyanmarHolidayService.getHolidayTypeIcon(holiday.type),
                            color: holiday.color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.paddingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                holiday.name,
                                style: AppTextStyles.bodyText.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                holiday.nameMyanmar,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${holiday.date.day}/${holiday.date.month}',
                              style: AppTextStyles.bodyText.copyWith(
                                fontWeight: FontWeight.w600,
                                color: holiday.color,
                              ),
                            ),
                            Text(
                              daysText,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast) 
                  const SizedBox(height: AppDimensions.paddingSmall),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingLarge,
                    ),
                    child: Divider(
                      color: AppColors.dividerColor.withOpacity(0.3),
                      height: 1,
                    ),
                  ),
                if (!isLast) 
                  const SizedBox(height: AppDimensions.paddingSmall),
              ],
            );
          }).toList(),
          
          const SizedBox(height: AppDimensions.paddingLarge),
        ],
      ),
    );
  }
}// Commit 18: 2025-02-07T01:20:01
// Commit 25: 2025-02-09T02:18:28
// Commit 92: 2025-02-28T20:34:29
// Commit 96: 2025-03-02T01:08:55
// Commit 154: 2025-03-19T04:13:36
// Commit 199: 2025-04-01T10:19:25
// Commit 16: 2025-02-06T10:52:57
// Commit 21: 2025-02-07T22:16:04
// Commit 73: 2025-02-23T06:08:01
// Commit 153: 2025-03-18T20:49:40
// Commit 10: 2025-02-04T15:50:57
// Commit 12: 2025-02-05T06:25:09
// Commit 18: 2025-02-07T01:14:40
// Commit 22: 2025-02-08T05:29:44
// Commit 27: 2025-02-09T16:15:49
// Commit 28: 2025-02-09T23:35:12
// Commit 61: 2025-02-19T16:50:50
// Commit 63: 2025-02-20T07:12:36
// Commit 67: 2025-02-21T11:40:22
// Commit 75: 2025-02-23T20:34:37
// Commit 81: 2025-02-25T15:21:47
// Commit 88: 2025-02-27T16:44:23
// Commit 95: 2025-03-01T17:39:30
// Commit 101: 2025-03-03T12:09:15
// Commit 102: 2025-03-03T20:03:03
// Commit 104: 2025-03-04T09:26:48
// Commit 109: 2025-03-05T20:49:47
// Commit 121: 2025-03-09T10:21:23
// Commit 122: 2025-03-09T17:13:39
// Commit 123: 2025-03-10T00:15:38
// Commit 135: 2025-03-13T13:00:08
// Commit 159: 2025-03-20T15:36:24
// Commit 161: 2025-03-21T05:40:51
// Commit 162: 2025-03-21T11:57:29
// Commit 165: 2025-03-22T10:02:17
// Commit 166: 2025-03-22T16:59:15
// Commit 169: 2025-03-23T13:54:49
// Commit 183: 2025-03-27T17:21:55
// Commit 187: 2025-03-28T21:06:55
// Commit 189: 2025-03-29T11:44:24
// Commit 1: 2025-02-02T00:29:36
// Commit 6: 2025-02-03T12:03:28
// Commit 12: 2025-02-05T06:12:31
// Commit 22: 2025-02-08T05:09:55
// Commit 28: 2025-02-09T23:38:56
// Commit 36: 2025-02-12T08:02:07
// Commit 38: 2025-02-12T22:44:20
// Commit 42: 2025-02-14T03:05:38
// Commit 52: 2025-02-17T01:19:20
// Commit 61: 2025-02-19T17:26:41
// Commit 65: 2025-02-20T21:08:52
// Commit 97: 2025-03-02T08:08:09
// Commit 100: 2025-03-03T05:49:09
// Commit 105: 2025-03-04T17:16:32
// Commit 107: 2025-03-05T07:01:14
// Commit 118: 2025-03-08T12:52:30
// Commit 120: 2025-03-09T03:30:50
// Commit 126: 2025-03-10T21:36:05
// Commit 127: 2025-03-11T04:30:44
// Commit 129: 2025-03-11T18:47:42
// Commit 152: 2025-03-18T13:57:25
// Commit 191: 2025-03-30T01:49:02
// Commit 195: 2025-03-31T06:13:43
// Commit 13: 2025-02-05T13:17:00
// Commit 20: 2025-02-07T14:40:59
// Commit 24: 2025-02-08T19:24:09
// Commit 34: 2025-02-11T18:21:18
// Commit 40: 2025-02-13T13:01:01
// Commit 44: 2025-02-14T17:26:15
// Commit 46: 2025-02-15T07:11:29
// Commit 56: 2025-02-18T06:19:54
// Commit 59: 2025-02-19T03:23:41
// Commit 71: 2025-02-22T16:03:18
// Commit 88: 2025-02-27T16:35:26
// Commit 107: 2025-03-05T07:17:37
// Commit 108: 2025-03-05T13:59:46
// Commit 131: 2025-03-12T08:57:59
// Commit 135: 2025-03-13T13:10:23
// Commit 143: 2025-03-15T21:42:50
// Commit 145: 2025-03-16T11:55:29
// Commit 146: 2025-03-16T19:33:24
// Commit 153: 2025-03-18T20:41:11
// Commit 163: 2025-03-21T19:15:06
// Commit 172: 2025-03-24T11:00:46
// Commit 182: 2025-03-27T10:24:48
// Commit 184: 2025-03-28T00:21:38
// Commit 186: 2025-03-28T13:54:18
// Commit 188: 2025-03-29T04:18:42
// Commit 196: 2025-03-31T12:38:26
// Commit 3: 2025-02-02T14:31:20
// Commit 10: 2025-02-04T16:00:44
// Commit 16: 2025-02-06T10:56:03
// Commit 24: 2025-02-08T19:21:47
// Commit 34: 2025-02-11T18:16:22
// Commit 39: 2025-02-13T05:38:28
// Commit 41: 2025-02-13T19:23:09
// Commit 49: 2025-02-16T04:16:31
// Commit 55: 2025-02-17T23:16:21
// Commit 66: 2025-02-21T05:10:09
// Commit 72: 2025-02-22T23:35:26
// Commit 99: 2025-03-02T22:34:16
// Commit 104: 2025-03-04T09:53:29
// Commit 109: 2025-03-05T21:37:24
// Commit 110: 2025-03-06T04:36:15
// Commit 114: 2025-03-07T08:44:03
// Commit 115: 2025-03-07T15:49:57
// Commit 124: 2025-03-10T07:13:11
// Commit 126: 2025-03-10T21:29:18
// Commit 130: 2025-03-12T01:30:57
// Commit 145: 2025-03-16T11:38:50
// Commit 157: 2025-03-20T00:39:22
// Commit 174: 2025-03-25T01:47:24
// Commit 175: 2025-03-25T08:45:36
// Commit 188: 2025-03-29T04:56:41
// Commit 198: 2025-04-01T03:28:06
// Commit 5: 2025-02-03T05:00:17
