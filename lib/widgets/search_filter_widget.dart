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
}// Commit 49: 2025-02-16T04:21:05
// Commit 63: 2025-02-20T07:38:15
// Commit 137: 2025-03-14T03:05:23
// Commit 6: 2025-02-03T11:41:40
// Commit 18: 2025-02-07T01:05:00
// Commit 148: 2025-03-17T09:08:45
// Commit 175: 2025-03-25T08:02:17
// Commit 3: 2025-02-02T14:17:50
// Commit 13: 2025-02-05T13:44:19
// Commit 17: 2025-02-06T17:29:27
// Commit 25: 2025-02-09T01:57:58
// Commit 45: 2025-02-14T23:47:20
// Commit 89: 2025-02-27T23:43:23
// Commit 106: 2025-03-05T00:06:09
// Commit 116: 2025-03-07T22:59:22
// Commit 130: 2025-03-12T01:44:29
// Commit 183: 2025-03-27T17:21:55
// Commit 185: 2025-03-28T07:12:25
// Commit 196: 2025-03-31T13:08:11
// Commit 41: 2025-02-13T20:03:34
// Commit 59: 2025-02-19T03:13:21
// Commit 62: 2025-02-20T00:18:01
// Commit 157: 2025-03-20T00:47:08
// Commit 8: 2025-02-04T01:47:36
// Commit 35: 2025-02-12T01:16:09
// Commit 43: 2025-02-14T10:02:59
// Commit 56: 2025-02-18T06:19:54
// Commit 72: 2025-02-22T23:38:03
// Commit 103: 2025-03-04T02:33:26
// Commit 109: 2025-03-05T20:54:07
// Commit 168: 2025-03-23T07:20:53
// Commit 171: 2025-03-24T03:58:57
// Commit 172: 2025-03-24T11:00:46
// Commit 11: 2025-02-04T23:46:57
// Commit 21: 2025-02-07T22:23:44
// Commit 23: 2025-02-08T12:31:34
// Commit 45: 2025-02-14T23:41:35
// Commit 48: 2025-02-15T21:07:58
// Commit 90: 2025-02-28T07:05:18
// Commit 105: 2025-03-04T17:04:58
// Commit 127: 2025-03-11T04:44:06
// Commit 159: 2025-03-20T15:31:55
// Commit 166: 2025-03-22T16:19:03
// Commit 180: 2025-03-26T19:26:18
// Commit 195: 2025-03-31T06:01:23
// Commit 198: 2025-04-01T03:28:06
// Commit 6: 2025-02-03T11:50:34
// Commit 104: 2025-03-04T09:31:54
// Commit 110: 2025-03-06T03:46:54
// Commit 115: 2025-03-07T15:47:23
// Commit 123: 2025-03-09T23:46:16
