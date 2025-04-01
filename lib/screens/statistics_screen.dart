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
}// Commit 31: 2025-02-10T21:15:51
// Commit 37: 2025-02-12T14:57:23
// Commit 57: 2025-02-18T12:51:54
// Commit 140: 2025-03-15T00:55:14
// Commit 177: 2025-03-25T22:17:20
// Commit 1: 2025-02-02T00:45:50
// Commit 14: 2025-02-05T20:58:38
// Commit 35: 2025-02-12T01:22:49
// Commit 60: 2025-02-19T10:20:00
// Commit 81: 2025-02-25T14:29:15
// Commit 90: 2025-02-28T06:48:09
// Commit 118: 2025-03-08T12:47:06
// Commit 152: 2025-03-18T13:33:26
// Commit 5: 2025-02-03T05:01:17
// Commit 14: 2025-02-05T20:19:33
// Commit 26: 2025-02-09T09:54:52
// Commit 29: 2025-02-10T06:59:08
// Commit 34: 2025-02-11T17:58:04
// Commit 43: 2025-02-14T09:40:26
// Commit 52: 2025-02-17T01:54:08
// Commit 53: 2025-02-17T08:21:46
// Commit 62: 2025-02-20T00:01:02
// Commit 68: 2025-02-21T19:13:29
// Commit 76: 2025-02-24T03:57:18
// Commit 91: 2025-02-28T14:02:34
// Commit 99: 2025-03-02T22:17:08
// Commit 107: 2025-03-05T06:52:41
// Commit 108: 2025-03-05T13:47:53
// Commit 111: 2025-03-06T10:54:58
// Commit 112: 2025-03-06T18:22:24
// Commit 113: 2025-03-07T01:38:54
// Commit 117: 2025-03-08T05:38:59
// Commit 136: 2025-03-13T20:00:36
// Commit 142: 2025-03-15T14:22:22
// Commit 144: 2025-03-16T05:24:50
// Commit 157: 2025-03-20T00:57:37
// Commit 168: 2025-03-23T06:28:20
// Commit 171: 2025-03-24T04:12:46
// Commit 173: 2025-03-24T17:50:22
// Commit 188: 2025-03-29T04:24:09
// Commit 196: 2025-03-31T13:08:11
// Commit 24: 2025-02-08T19:30:15
// Commit 25: 2025-02-09T02:01:47
// Commit 26: 2025-02-09T09:31:38
// Commit 46: 2025-02-15T06:46:41
// Commit 50: 2025-02-16T11:09:48
// Commit 64: 2025-02-20T14:21:23
// Commit 66: 2025-02-21T05:09:11
// Commit 75: 2025-02-23T20:07:44
// Commit 83: 2025-02-26T05:25:41
// Commit 88: 2025-02-27T16:26:53
// Commit 91: 2025-02-28T13:50:15
// Commit 93: 2025-03-01T03:44:33
// Commit 95: 2025-03-01T18:23:34
// Commit 110: 2025-03-06T04:12:59
// Commit 124: 2025-03-10T07:07:51
// Commit 144: 2025-03-16T05:23:41
// Commit 154: 2025-03-19T03:19:54
// Commit 166: 2025-03-22T16:37:37
// Commit 168: 2025-03-23T06:21:40
// Commit 180: 2025-03-26T19:43:19
// Commit 184: 2025-03-27T23:52:43
// Commit 185: 2025-03-28T06:47:20
// Commit 186: 2025-03-28T14:28:29
// Commit 187: 2025-03-28T21:26:33
// Commit 197: 2025-03-31T20:13:41
// Commit 14: 2025-02-05T20:33:47
// Commit 47: 2025-02-15T14:27:21
// Commit 54: 2025-02-17T15:33:47
// Commit 55: 2025-02-17T22:35:52
// Commit 66: 2025-02-21T04:55:07
// Commit 69: 2025-02-22T02:25:54
// Commit 70: 2025-02-22T08:49:20
// Commit 90: 2025-02-28T06:18:13
// Commit 103: 2025-03-04T02:33:26
// Commit 124: 2025-03-10T07:21:25
// Commit 140: 2025-03-15T01:03:51
// Commit 148: 2025-03-17T09:39:40
// Commit 152: 2025-03-18T13:51:18
// Commit 173: 2025-03-24T17:46:30
// Commit 6: 2025-02-03T11:34:45
// Commit 8: 2025-02-04T02:11:36
// Commit 25: 2025-02-09T02:13:51
// Commit 27: 2025-02-09T16:43:27
// Commit 28: 2025-02-09T23:21:43
// Commit 29: 2025-02-10T06:53:26
// Commit 38: 2025-02-12T22:05:29
// Commit 45: 2025-02-14T23:41:35
// Commit 56: 2025-02-18T06:21:39
// Commit 62: 2025-02-20T00:51:18
// Commit 76: 2025-02-24T03:48:31
// Commit 82: 2025-02-25T22:25:56
// Commit 93: 2025-03-01T04:15:37
// Commit 98: 2025-03-02T15:01:29
// Commit 100: 2025-03-03T05:38:32
// Commit 101: 2025-03-03T12:49:53
// Commit 107: 2025-03-05T06:44:40
// Commit 125: 2025-03-10T14:26:54
// Commit 127: 2025-03-11T04:44:06
// Commit 128: 2025-03-11T11:23:59
// Commit 137: 2025-03-14T03:00:44
// Commit 143: 2025-03-15T21:56:08
// Commit 150: 2025-03-17T23:47:57
// Commit 155: 2025-03-19T11:18:15
// Commit 167: 2025-03-22T23:50:30
// Commit 7: 2025-02-03T18:31:22
// Commit 11: 2025-02-04T23:23:13
// Commit 12: 2025-02-05T06:40:07
// Commit 34: 2025-02-11T17:44:56
// Commit 45: 2025-02-14T23:50:08
// Commit 64: 2025-02-20T14:31:52
// Commit 65: 2025-02-20T22:05:56
// Commit 94: 2025-03-01T10:46:03
// Commit 96: 2025-03-02T01:13:51
// Commit 118: 2025-03-08T13:11:20
// Commit 133: 2025-03-12T22:56:46
// Commit 136: 2025-03-13T20:21:47
// Commit 153: 2025-03-18T20:16:48
// Commit 165: 2025-03-22T09:10:24
// Commit 167: 2025-03-22T23:37:16
// Commit 175: 2025-03-25T08:18:34
// Commit 177: 2025-03-25T22:15:51
// Commit 179: 2025-03-26T13:11:52
// Commit 199: 2025-04-01T10:40:05
// Commit 200: 2025-04-01T17:10:27
