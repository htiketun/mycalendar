import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/constants.dart';

class SearchAndFilterWidget extends StatefulWidget {
  final List<Event> events;
  final Function(List<Event>) onFilteredEvents;
  final VoidCallback onClearFilters;

  const SearchAndFilterWidget({
    Key? key,
    required this.events,
    required this.onFilteredEvents,
    required this.onClearFilters,
  }) : super(key: key);

  @override
  State<SearchAndFilterWidget> createState() => _SearchAndFilterWidgetState();
}

class _SearchAndFilterWidgetState extends State<SearchAndFilterWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  
  bool _isExpanded = false;
  EventCategory? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showCompletedOnly = false;
  bool _showUpcomingOnly = false;
  int _selectedPriority = 0; // 0 = all, 1-3 = specific priority

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _applyFilters() {
    List<Event> filteredEvents = List.from(widget.events);
    
    // Text search
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filteredEvents = filteredEvents.where((event) {
        return event.title.toLowerCase().contains(searchQuery) ||
               event.description.toLowerCase().contains(searchQuery) ||
               event.location?.toLowerCase().contains(searchQuery) == true ||
               event.notes?.toLowerCase().contains(searchQuery) == true ||
               event.tags.any((tag) => tag.toLowerCase().contains(searchQuery));
      }).toList();
    }
    
    // Category filter
    if (_selectedCategory != null) {
      filteredEvents = filteredEvents.where((event) =>
          event.category == _selectedCategory).toList();
    }
    
    // Date range filter
    if (_startDate != null && _endDate != null) {
      filteredEvents = filteredEvents.where((event) =>
          event.date.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
          event.date.isBefore(_endDate!.add(const Duration(days: 1)))).toList();
    }
    
    // Completion filter
    if (_showCompletedOnly) {
      filteredEvents = filteredEvents.where((event) => event.isCompleted).toList();
    }
    
    // Upcoming filter
    if (_showUpcomingOnly) {
      filteredEvents = filteredEvents.where((event) => event.isUpcoming).toList();
    }
    
    // Priority filter
    if (_selectedPriority > 0) {
      filteredEvents = filteredEvents.where((event) =>
          event.priority == _selectedPriority).toList();
    }
    
    widget.onFilteredEvents(filteredEvents);
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
      _startDate = null;
      _endDate = null;
      _showCompletedOnly = false;
      _showUpcomingOnly = false;
      _selectedPriority = 0;
    });
    widget.onClearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingMedium),
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
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSearchHeader(),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: _buildFilterOptions(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: AppTextStyles.bodyText,
              decoration: InputDecoration(
                hintText: AppStrings.searchEvents,
                hintStyle: AppTextStyles.caption,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryColor,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                        icon: const Icon(Icons.clear_rounded),
                        color: AppColors.textSecondary,
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceColor.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  borderSide: BorderSide(color: AppColors.primaryColor.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          IconButton(
            onPressed: _toggleExpanded,
            icon: AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.tune_rounded),
            ),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primaryColor.withOpacity(0.2),
              foregroundColor: AppColors.primaryColor,
            ),
            tooltip: AppStrings.filter,
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          IconButton(
            onPressed: _clearAllFilters,
            icon: const Icon(Icons.clear_all_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.errorColor.withOpacity(0.2),
              foregroundColor: AppColors.errorColor,
            ),
            tooltip: AppStrings.clear,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter
          _buildFilterSection(
            title: 'Filter by Category',
            child: Wrap(
              spacing: AppDimensions.paddingSmall,
              runSpacing: AppDimensions.paddingSmall,
              children: [
                _buildCategoryChip(null, 'All Categories'),
                ...EventCategory.values.map((category) =>
                    _buildCategoryChip(category, EventCategoryHelper.getName(category))),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Date Range Filter
          _buildFilterSection(
            title: 'Date Range',
            child: Row(
              children: [
                Expanded(child: _buildDateSelector('Start Date', _startDate, (date) {
                  setState(() => _startDate = date);
                  _applyFilters();
                })),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(child: _buildDateSelector('End Date', _endDate, (date) {
                  setState(() => _endDate = date);
                  _applyFilters();
                })),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Quick Filters
          _buildFilterSection(
            title: 'Quick Filters',
            child: Wrap(
              spacing: AppDimensions.paddingSmall,
              runSpacing: AppDimensions.paddingSmall,
              children: [
                _buildToggleChip('Completed Only', _showCompletedOnly, (value) {
                  setState(() => _showCompletedOnly = value);
                  _applyFilters();
                }),
                _buildToggleChip('Upcoming Only', _showUpcomingOnly, (value) {
                  setState(() => _showUpcomingOnly = value);
                  _applyFilters();
                }),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Priority Filter
          _buildFilterSection(
            title: 'Priority',
            child: Wrap(
              spacing: AppDimensions.paddingSmall,
              children: [
                _buildPriorityChip(0, 'All'),
                _buildPriorityChip(1, 'Low'),
                _buildPriorityChip(2, 'Medium'),
                _buildPriorityChip(3, 'High'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textAccent,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        child,
      ],
    );
  }

  Widget _buildCategoryChip(EventCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    final color = category != null
        ? EventCategoryHelper.getColor(category)
        : AppColors.textSecondary;
    
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
        _applyFilters();
      },
      backgroundColor: color.withOpacity(0.1),
      selectedColor: color.withOpacity(0.3),
      checkmarkColor: Colors.white,
      labelStyle: AppTextStyles.caption.copyWith(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      side: BorderSide(
        color: isSelected ? color : color.withOpacity(0.3),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, Function(DateTime) onDateSelected) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border: Border.all(
            color: AppColors.dividerColor.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 4),
            Text(
              date != null
                  ? '${date.day}/${date.month}/${date.year}'
                  : 'Select date',
              style: AppTextStyles.bodyText.copyWith(
                color: date != null ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleChip(String label, bool value, Function(bool) onChanged) {
    return FilterChip(
      selected: value,
      label: Text(label),
      onSelected: onChanged,
      backgroundColor: AppColors.surfaceColor.withOpacity(0.1),
      selectedColor: AppColors.successColor.withOpacity(0.3),
      checkmarkColor: Colors.white,
      labelStyle: AppTextStyles.caption.copyWith(
        color: value ? Colors.white : AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      side: BorderSide(
        color: value ? AppColors.successColor : AppColors.dividerColor.withOpacity(0.3),
      ),
    );
  }

  Widget _buildPriorityChip(int priority, String label) {
    final isSelected = _selectedPriority == priority;
    final colors = [
      AppColors.textSecondary,
      AppColors.neonGreen,
      AppColors.neonGreen,
      AppColors.neonRed,
    ];
    
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (selected) {
        setState(() {
          _selectedPriority = selected ? priority : 0;
        });
        _applyFilters();
      },
      backgroundColor: colors[priority].withOpacity(0.1),
      selectedColor: colors[priority].withOpacity(0.3),
      checkmarkColor: Colors.white,
      labelStyle: AppTextStyles.caption.copyWith(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      side: BorderSide(
        color: isSelected ? colors[priority] : colors[priority].withOpacity(0.3),
      ),
    );
  }
}
