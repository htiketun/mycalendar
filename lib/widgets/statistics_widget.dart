import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/event.dart';
import '../utils/constants.dart';

class StatisticsWidget extends StatelessWidget {
  final List<Event> events;

  const StatisticsWidget({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(
          color: AppColors.neonPurple.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPurple.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppDimensions.paddingLarge),
          _buildStatsGrid(),
          const SizedBox(height: AppDimensions.paddingLarge),
          _buildCategoryBreakdown(),
          const SizedBox(height: AppDimensions.paddingLarge),
          _buildProductivityScore(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: const Icon(
            Icons.analytics_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PRODUCTIVITY STATS',
                style: AppTextStyles.neonText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Level up your productivity!',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    final totalEvents = events.length;
    final completedEvents = events.where((e) => e.isCompleted).length;
    final thisWeekEvents = events.where((e) => _isThisWeek(e.date)).length;
    final thisMonthEvents = events.where((e) => _isThisMonth(e.date)).length;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: AppDimensions.paddingMedium,
      mainAxisSpacing: AppDimensions.paddingMedium,
      children: [
        _buildStatCard(
          'Total Events',
          totalEvents.toString(),
          Icons.event_rounded,
          AppColors.neonPurple,
        ),
        _buildStatCard(
          'Completed',
          completedEvents.toString(),
          Icons.check_circle_rounded,
          AppColors.neonGreen,
        ),
        _buildStatCard(
          'This Week',
          thisWeekEvents.toString(),
          Icons.date_range_rounded,
          AppColors.neonPink,
        ),
        _buildStatCard(
          'This Month',
          thisMonthEvents.toString(),
          Icons.calendar_month_rounded,
          AppColors.neonPurple,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          Text(
            value,
            style: AppTextStyles.heading1.copyWith(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    final categoryStats = <EventCategory, int>{};
    for (final category in EventCategory.values) {
      categoryStats[category] = events.where((e) => e.category == category).length;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORY BREAKDOWN',
          style: AppTextStyles.neonText.copyWith(
            fontSize: 18,
            color: AppColors.textAccent,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        ...categoryStats.entries.map((entry) {
          final category = entry.key;
          final count = entry.value;
          final percentage = events.isNotEmpty ? (count / events.length) : 0.0;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
            child: _buildCategoryBar(category, count, percentage),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCategoryBar(EventCategory category, int count, double percentage) {
    final color = EventCategoryHelper.getColor(category);
    
    return Row(
      children: [
        Icon(
          EventCategoryHelper.getIcon(category),
          color: color,
          size: 20,
        ),
        const SizedBox(width: AppDimensions.paddingSmall),
        SizedBox(
          width: 80,
          child: Text(
            EventCategoryHelper.getName(category),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSmall),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.dividerColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSmall),
        SizedBox(
          width: 30,
          child: Text(
            count.toString(),
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildProductivityScore() {
    final totalEvents = events.length;
    final completedEvents = events.where((e) => e.isCompleted).length;
    final upcomingEvents = events.where((e) => e.isUpcoming).length;
    
    // Calculate productivity score (0-100)
    double score = 0;
    if (totalEvents > 0) {
      final completionRate = completedEvents / totalEvents;
      final activityBonus = math.min(totalEvents / 50.0, 1.0); // Bonus for being active
      final upcomingRatio = upcomingEvents / math.max(totalEvents, 1);
      
      score = (completionRate * 70 + activityBonus * 20 + upcomingRatio * 10) * 100;
      score = math.min(score, 100);
    }

    final scoreColor = score >= 80
        ? AppColors.neonGreen
        : score >= 60
            ? AppColors.neonGreen
            : score >= 40
                ? AppColors.neonOrange
                : AppColors.neonRed;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scoreColor.withOpacity(0.1),
            scoreColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(
          color: scoreColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRODUCTIVITY SCORE',
                  style: AppTextStyles.neonText.copyWith(
                    color: scoreColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSmall),
                Text(
                  '${score.toInt()}/100',
                  style: AppTextStyles.heading1.copyWith(
                    color: scoreColor,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  _getScoreMessage(score),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              children: [
                // Background circle
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.dividerColor.withOpacity(0.3),
                      width: 8,
                    ),
                  ),
                ),
                // Progress circle
                CustomPaint(
                  size: const Size(100, 100),
                  painter: CircularProgressPainter(
                    progress: score / 100,
                    color: scoreColor,
                  ),
                ),
                // Center icon
                Center(
                  child: Icon(
                    score >= 80
                        ? Icons.emoji_events_rounded
                        : score >= 60
                            ? Icons.trending_up_rounded
                            : score >= 40
                                ? Icons.trending_flat_rounded
                                : Icons.trending_down_rounded,
                    color: scoreColor,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getScoreMessage(double score) {
    if (score >= 90) return 'Legendary! 🏆';
    if (score >= 80) return 'Amazing work! 🔥';
    if (score >= 70) return 'Great job! ⭐';
    if (score >= 60) return 'Good progress! 👍';
    if (score >= 40) return 'Keep going! 💪';
    return 'Time to level up! 🚀';
  }

  bool _isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  bool _isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
