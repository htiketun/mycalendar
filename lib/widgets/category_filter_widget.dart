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
}