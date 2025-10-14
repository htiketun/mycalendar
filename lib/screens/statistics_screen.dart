import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/statistics_widget.dart';
import '../utils/constants.dart';

class StatisticsScreen extends StatefulWidget {
  final List<Event> events;

  const StatisticsScreen({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
              _buildAppBar(context),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildResponsiveContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
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
                  'Analytics Dashboard',
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Your productivity insights & achievements',
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
              Icons.analytics_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we're on a large screen (tablet/desktop)
        final isLargeScreen = constraints.maxWidth > 600;
        
        if (isLargeScreen) {
          return _buildLargeScreenLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: AppDimensions.paddingLarge),
          StatisticsWidget(events: widget.events),
        ],
      ),
    );
  }

  Widget _buildLargeScreenLayout() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left sidebar with welcome card
          SizedBox(
            width: 300,
            child: Column(
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: AppDimensions.paddingLarge),
                _buildQuickStats(),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.paddingLarge),
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              child: StatisticsWidget(events: widget.events),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final completedEvents = widget.events.where((e) => e.isCompleted).length;
    final totalEvents = widget.events.length;
    final completionRate = totalEvents > 0 ? (completedEvents / totalEvents) : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Text(
                  'Productivity Score',
                  style: AppTextStyles.heading3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          Text(
            '${(completionRate * 100).toInt()}%',
            style: AppTextStyles.arcadeTitle.copyWith(
              color: Colors.white,
              fontSize: 48,
            ),
          ),
          Text(
            '$completedEvents of $totalEvents events completed',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          LinearProgressIndicator(
            value: completionRate,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final upcomingEvents = widget.events.where((e) => 
      e.date.isAfter(DateTime.now()) && !e.isCompleted
    ).length;
    
    final todayEvents = widget.events.where((e) => 
      e.date.day == DateTime.now().day &&
      e.date.month == DateTime.now().month &&
      e.date.year == DateTime.now().year
    ).length;

    return Column(
      children: [
        _buildQuickStatCard(
          'Today\'s Events',
          todayEvents.toString(),
          Icons.today_rounded,
          AppColors.neonGreen,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        _buildQuickStatCard(
          'Upcoming Events',
          upcomingEvents.toString(),
          Icons.schedule_rounded,
          AppColors.neonPurple,
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.heading3.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
