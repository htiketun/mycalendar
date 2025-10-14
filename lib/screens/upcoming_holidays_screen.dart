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
}
