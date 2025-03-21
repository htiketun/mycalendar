import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/constants.dart';

class CategoryFilterWidget extends StatefulWidget {
  final List<EventCategory> selectedCategories;
  final Function(List<EventCategory>) onCategoriesChanged;

  const CategoryFilterWidget({
    Key? key,
    required this.selectedCategories,
    required this.onCategoriesChanged,
  }) : super(key: key);

  @override
  State<CategoryFilterWidget> createState() => _CategoryFilterWidgetState();
}

class _CategoryFilterWidgetState extends State<CategoryFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list_rounded,
                color: AppColors.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Text(
                'Filter by Category',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (widget.selectedCategories.isNotEmpty)
                TextButton(
                  onPressed: () => widget.onCategoriesChanged([]),
                  child: Text(
                    'Clear All',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Category chips
          Wrap(
            spacing: AppDimensions.paddingSmall,
            runSpacing: AppDimensions.paddingSmall,
            children: EventCategory.values.map((category) {
              final isSelected = widget.selectedCategories.contains(category);
              final categoryColor = AppColors.getCategoryColor(category);
              
              return GestureDetector(
                onTap: () => _toggleCategory(category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMedium,
                    vertical: AppDimensions.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? categoryColor.withOpacity(0.2)
                        : AppColors.surfaceColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                    border: Border.all(
                      color: isSelected 
                          ? categoryColor 
                          : AppColors.dividerColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        AppColors.getCategoryIcon(category),
                        color: isSelected 
                            ? categoryColor 
                            : AppColors.textSecondary,
                        size: 16,
                      ),
                      const SizedBox(width: AppDimensions.paddingSmall),
                      Text(
                        AppColors.getCategoryName(category),
                        style: AppTextStyles.caption.copyWith(
                          color: isSelected 
                              ? categoryColor 
                              : AppColors.textSecondary,
                          fontWeight: isSelected 
                              ? FontWeight.w600 
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Quick filter buttons
          Row(
            children: [
              Expanded(
                child: _buildQuickFilterButton(
                  'All',
                  Icons.select_all_rounded,
                  widget.selectedCategories.length == EventCategory.values.length,
                  () => widget.onCategoriesChanged(EventCategory.values),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: _buildQuickFilterButton(
                  'None',
                  Icons.deselect_rounded,
                  widget.selectedCategories.isEmpty,
                  () => widget.onCategoriesChanged([]),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: _buildQuickFilterButton(
                  'Work',
                  Icons.work_rounded,
                  widget.selectedCategories.length == 1 && widget.selectedCategories.contains(EventCategory.work),
                  () => widget.onCategoriesChanged([EventCategory.work]),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: _buildQuickFilterButton(
                  'Personal',
                  Icons.person_rounded,
                  widget.selectedCategories.length == 1 && widget.selectedCategories.contains(EventCategory.personal),
                  () => widget.onCategoriesChanged([EventCategory.personal]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterButton(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isActive 
              ? AppColors.primaryColor.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border: Border.all(
            color: isActive 
                ? AppColors.primaryColor 
                : AppColors.dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive 
                  ? AppColors.primaryColor
                  : AppColors.textSecondary,
              size: 18,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
                color: isActive 
                    ? AppColors.primaryColor
                    : AppColors.textSecondary,
                fontWeight: isActive 
                    ? FontWeight.w600 
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCategory(EventCategory category) {
    final updatedCategories = List<EventCategory>.from(widget.selectedCategories);
    
    if (updatedCategories.contains(category)) {
      updatedCategories.remove(category);
    } else {
      updatedCategories.add(category);
    }
    
    widget.onCategoriesChanged(updatedCategories);
  }
}// Commit 75: 2025-02-23T20:05:37
// Commit 97: 2025-03-02T07:49:36
// Commit 71: 2025-02-22T16:32:13
// Commit 94: 2025-03-01T11:07:14
// Commit 122: 2025-03-09T17:23:45
// Commit 20: 2025-02-07T14:56:11
// Commit 23: 2025-02-08T11:49:40
// Commit 30: 2025-02-10T13:40:16
// Commit 34: 2025-02-11T17:58:04
// Commit 37: 2025-02-12T15:06:14
// Commit 67: 2025-02-21T11:40:22
// Commit 80: 2025-02-25T08:07:12
// Commit 92: 2025-02-28T20:23:39
// Commit 145: 2025-03-16T11:32:30
// Commit 190: 2025-03-29T18:38:08
// Commit 15: 2025-02-06T03:46:56
// Commit 18: 2025-02-07T00:27:25
// Commit 30: 2025-02-10T13:30:10
// Commit 42: 2025-02-14T03:05:38
// Commit 114: 2025-03-07T08:16:13
// Commit 170: 2025-03-23T20:33:30
// Commit 24: 2025-02-08T19:24:09
// Commit 63: 2025-02-20T07:45:55
// Commit 78: 2025-02-24T18:01:11
// Commit 150: 2025-03-17T23:36:23
// Commit 158: 2025-03-20T07:41:12
// Commit 31: 2025-02-10T21:22:45
// Commit 38: 2025-02-12T22:05:29
// Commit 42: 2025-02-14T02:25:36
// Commit 43: 2025-02-14T10:10:24
// Commit 47: 2025-02-15T14:38:47
// Commit 50: 2025-02-16T11:00:14
// Commit 95: 2025-03-01T18:14:10
// Commit 96: 2025-03-02T01:08:55
// Commit 97: 2025-03-02T08:08:54
// Commit 103: 2025-03-04T02:47:23
// Commit 120: 2025-03-09T02:39:45
// Commit 192: 2025-03-30T08:21:23
// Commit 194: 2025-03-30T22:26:54
// Commit 199: 2025-04-01T10:43:34
// Commit 9: 2025-02-04T09:08:22
// Commit 23: 2025-02-08T12:42:52
// Commit 26: 2025-02-09T09:20:28
// Commit 27: 2025-02-09T16:25:55
// Commit 46: 2025-02-15T06:46:10
// Commit 90: 2025-02-28T06:21:25
// Commit 119: 2025-03-08T20:12:05
// Commit 122: 2025-03-09T16:59:09
// Commit 163: 2025-03-21T19:25:05
