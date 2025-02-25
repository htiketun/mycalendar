import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../services/myanmar_lunar_calendar_service.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/event_list_widget.dart';
import '../widgets/event_form_dialog.dart';
import '../widgets/weekly_view.dart';
import '../widgets/daily_view.dart';
import '../widgets/search_filter_widget.dart';
import '../widgets/statistics_widget.dart';
import '../widgets/holiday_legend_widget.dart';
import '../widgets/myanmar_date_widget.dart';
import '../widgets/category_filter_widget.dart';
import '../screens/statistics_screen.dart';
import '../screens/create_event_screen.dart';
import '../screens/upcoming_holidays_screen.dart';
import '../utils/constants.dart';

enum CalendarView { month, week, day, agenda }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  bool _isLoading = true;
  bool _showSearch = false;
  bool _showCategoryFilter = false;
  List<EventCategory> _selectedCategories = EventCategory.values;
  CalendarView _currentView = CalendarView.month;
  
  late AnimationController _appBarController;
  late AnimationController _fabController;
  late Animation<double> _appBarAnimation;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    
    _appBarController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _appBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _appBarController, curve: Curves.easeOutBack),
    );
    
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );
    
    _appBarController.forward();
    _fabController.forward();
  }

  @override
  void dispose() {
    _appBarController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    try {
      final events = await EventService.instance.getEvents();
      setState(() {
        _events = events;
        _isLoading = false;
      });
      _applyFilters(); // Apply initial filters
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorMessage('Failed to load events');
    }
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
  }

  void _onFilteredEvents(List<Event> filtered) {
    // Apply category filter on top of search filter
    final categoryFiltered = _selectedCategories.isEmpty 
        ? filtered
        : filtered.where((event) => _selectedCategories.contains(event.category)).toList();
    
    setState(() {
      _filteredEvents = categoryFiltered;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedCategories = EventCategory.values;
      _filteredEvents = _events;
    });
  }

  void _onCategoriesChanged(List<EventCategory> categories) {
    setState(() {
      _selectedCategories = categories;
      // Re-apply current search with new category filter
      _applyFilters();
    });
  }

  void _applyFilters() {
    var filtered = _events;
    
    // Apply category filter
    if (_selectedCategories.isNotEmpty && _selectedCategories.length < EventCategory.values.length) {
      filtered = filtered.where((event) => _selectedCategories.contains(event.category)).toList();
    }
    
    setState(() {
      _filteredEvents = filtered;
    });
  }

  void _toggleCategoryFilter() {
    setState(() {
      _showCategoryFilter = !_showCategoryFilter;
    });
  }

  void _switchView(CalendarView view) {
    setState(() {
      _currentView = view;
    });
  }

  Future<void> _addEvent() async {
    final result = await Navigator.of(context).push<Event>(
      MaterialPageRoute(
        builder: (context) => CreateEventScreen(selectedDate: _selectedDate),
      ),
    );

    if (result != null) {
      try {
        await EventService.instance.addEvent(result);
        await _loadEvents();
        _showSuccessMessage('Event added successfully');
      } catch (e) {
        _showErrorMessage('Failed to add event');
      }
    }
  }

  Future<void> _editEvent(Event event) async {
    final result = await Navigator.of(context).push<Event>(
      MaterialPageRoute(
        builder: (context) => CreateEventScreen(
          event: event,
          selectedDate: event.date,
        ),
      ),
    );

    if (result != null) {
      try {
        await EventService.instance.updateEvent(result);
        await _loadEvents();
        _showSuccessMessage('Event updated successfully');
      } catch (e) {
        _showErrorMessage('Failed to update event');
      }
    }
  }

  Future<void> _deleteEvent(Event event) async {
    final confirmed = await _showDeleteConfirmation();
    if (confirmed == true) {
      try {
        await EventService.instance.deleteEvent(event.id);
        await _loadEvents();
        _showSuccessMessage('Event deleted successfully');
      } catch (e) {
        _showErrorMessage('Failed to delete event');
      }
    }
  }

  Future<bool?> _showDeleteConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteEvent),
        content: const Text(AppStrings.confirmDelete),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  void _showEventOptions(Event event) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusLarge),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            
            // Event details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.getEventColor(event.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingSmall),
                      Expanded(
                        child: Text(
                          event.title,
                          style: AppTextStyles.heading3,
                        ),
                      ),
                    ],
                  ),
                  if (event.description.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.paddingSmall),
                    Text(
                      event.description,
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingLarge),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _editEvent(event);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text(AppStrings.editEvent),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteEvent(event);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text(AppStrings.deleteEvent),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.eventColors[1], // Green
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(_appBarAnimation),
            child: _buildAppBar(),
          ),
        ),
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    ),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Text(
                      'Loading your events...',
                      style: AppTextStyles.bodyText.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  if (_showSearch) 
                    SearchAndFilterWidget(
                      events: _events,
                      onFilteredEvents: _onFilteredEvents,
                      onClearFilters: _clearFilters,
                    ),
                  if (_showCategoryFilter)
                    Padding(
                      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                      child: CategoryFilterWidget(
                        selectedCategories: _selectedCategories,
                        onCategoriesChanged: _onCategoriesChanged,
                      ),
                    ),
                  Expanded(child: _buildCurrentView()),
                ],
              ),
        floatingActionButton: ScaleTransition(
          scale: _fabAnimation,
          child: FloatingActionButton.extended(
            onPressed: _addEvent,
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.backgroundColor,
            elevation: 8,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Event'),
            extendedTextStyle: AppTextStyles.button.copyWith(
              color: AppColors.backgroundColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            children: [
              // Top row with title and actions
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.appName,
                          style: AppTextStyles.arcadeTitle.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              AppStrings.appSubtitle,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleSearch,
                    icon: Icon(_showSearch ? Icons.search_off_rounded : Icons.search_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  IconButton(
                    onPressed: _toggleCategoryFilter,
                    icon: Icon(_showCategoryFilter ? Icons.filter_list_off_rounded : Icons.filter_list_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'stats') {
                        _showStatistics();
                      } else if (value == 'holidays') {
                        _showHolidayLegend();
                      } else if (value == 'upcoming') {
                        _showUpcomingHolidays();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'stats',
                        child: ListTile(
                          leading: Icon(Icons.analytics_rounded),
                          title: Text('Statistics'),
                          dense: true,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'holidays',
                        child: ListTile(
                          leading: Icon(Icons.celebration_rounded),
                          title: Text('Myanmar Holidays'),
                          dense: true,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'upcoming',
                        child: ListTile(
                          leading: Icon(Icons.upcoming_rounded),
                          title: Text('Upcoming Holidays'),
                          dense: true,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: AppDimensions.paddingMedium),
              
              // View switcher
              Row(
                children: [
                  Expanded(child: _buildViewSwitcher()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Row(
        children: CalendarView.values.map((view) {
          final isSelected = _currentView == view;
          final labels = {
            CalendarView.month: AppStrings.monthView,
            CalendarView.week: AppStrings.weekView,
            CalendarView.day: AppStrings.dayView,
            CalendarView.agenda: AppStrings.agenda,
          };
          
          return Expanded(
            child: GestureDetector(
              onTap: () => _switchView(view),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSmall),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: Text(
                  labels[view]!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: isSelected ? AppColors.primaryColor : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case CalendarView.month:
        return CalendarWidget(
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          events: _filteredEvents,
        );
      case CalendarView.week:
        return WeeklyView(
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          events: _filteredEvents,
          onEventTap: _showEventOptions,
        );
      case CalendarView.day:
        return DailyView(
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          events: _filteredEvents,
          onEventTap: _showEventOptions,
          onAddEvent: _addEvent,
        );
      case CalendarView.agenda:
        return EventListWidget(
          selectedDate: _selectedDate,
          events: _filteredEvents,
          onEventTap: _showEventOptions,
          onAddEvent: _addEvent,
        );
    }
  }

  void _showStatistics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StatisticsScreen(events: _events),
      ),
    );
  }

  void _showUpcomingHolidays() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UpcomingHolidaysScreen(),
      ),
    );
  }



  void _showHolidayLegend() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            gradient: AppColors.backgroundGradient,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
                    topRight: Radius.circular(AppDimensions.borderRadiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      ),
                      child: const Icon(
                        Icons.celebration_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Myanmar Holidays',
                            style: AppTextStyles.heading3.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Holiday types and meanings',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, size: 28),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  children: [
                    const HolidayLegendWidget(),
                    const SizedBox(height: AppDimensions.paddingMedium),
                    Text(
                      'Tap on any highlighted date to see holiday details!',
                      style: AppTextStyles.caption.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}// Commit 11: 2025-02-04T22:57:28
// Commit 30: 2025-02-10T14:05:34
// Commit 58: 2025-02-18T20:15:08
// Commit 132: 2025-03-12T15:39:10
// Commit 171: 2025-03-24T04:06:58
// Commit 178: 2025-03-26T05:20:01
// Commit 30: 2025-02-10T14:06:49
// Commit 54: 2025-02-17T15:29:36
// Commit 173: 2025-03-24T18:42:47
// Commit 181: 2025-03-27T03:00:17
// Commit 189: 2025-03-29T11:15:32
// Commit 6: 2025-02-03T12:19:13
// Commit 8: 2025-02-04T02:16:47
// Commit 21: 2025-02-07T21:51:55
// Commit 30: 2025-02-10T13:40:16
// Commit 31: 2025-02-10T21:12:19
// Commit 40: 2025-02-13T12:20:12
// Commit 46: 2025-02-15T07:00:52
// Commit 57: 2025-02-18T12:44:10
// Commit 73: 2025-02-23T05:57:59
// Commit 78: 2025-02-24T17:17:00
// Commit 80: 2025-02-25T08:07:12
// Commit 83: 2025-02-26T05:02:21
// Commit 85: 2025-02-26T19:39:25
// Commit 94: 2025-03-01T10:54:42
// Commit 100: 2025-03-03T05:19:45
// Commit 105: 2025-03-04T16:59:00
// Commit 114: 2025-03-07T08:16:52
// Commit 126: 2025-03-10T21:40:24
// Commit 131: 2025-03-12T09:12:15
// Commit 132: 2025-03-12T16:05:11
// Commit 140: 2025-03-15T01:03:05
// Commit 160: 2025-03-20T22:06:17
// Commit 175: 2025-03-25T08:09:43
// Commit 176: 2025-03-25T15:25:06
// Commit 186: 2025-03-28T14:27:15
// Commit 194: 2025-03-30T22:51:22
// Commit 3: 2025-02-02T14:37:35
// Commit 16: 2025-02-06T10:34:47
// Commit 27: 2025-02-09T16:43:21
// Commit 33: 2025-02-11T10:54:56
// Commit 40: 2025-02-13T12:55:26
// Commit 49: 2025-02-16T04:00:09
// Commit 57: 2025-02-18T13:01:45
// Commit 79: 2025-02-25T00:14:48
// Commit 81: 2025-02-25T14:58:39
// Commit 82: 2025-02-25T22:08:51
// Commit 87: 2025-02-27T09:23:04
// Commit 89: 2025-02-27T23:21:26
// Commit 96: 2025-03-02T01:33:53
// Commit 99: 2025-03-02T22:14:23
// Commit 109: 2025-03-05T20:48:24
// Commit 114: 2025-03-07T08:16:13
// Commit 119: 2025-03-08T19:43:51
// Commit 122: 2025-03-09T17:29:29
// Commit 140: 2025-03-15T01:00:15
// Commit 155: 2025-03-19T10:23:26
// Commit 165: 2025-03-22T09:14:39
// Commit 171: 2025-03-24T03:43:43
// Commit 175: 2025-03-25T08:53:11
// Commit 188: 2025-03-29T04:39:08
// Commit 192: 2025-03-30T08:19:11
// Commit 198: 2025-04-01T02:57:04
// Commit 200: 2025-04-01T17:14:53
// Commit 3: 2025-02-02T14:53:53
// Commit 6: 2025-02-03T12:01:12
// Commit 22: 2025-02-08T04:56:36
// Commit 32: 2025-02-11T04:13:59
// Commit 50: 2025-02-16T11:44:48
// Commit 52: 2025-02-17T01:12:05
// Commit 57: 2025-02-18T13:06:02
// Commit 60: 2025-02-19T09:44:55
// Commit 61: 2025-02-19T17:44:32
// Commit 99: 2025-03-02T22:10:28
// Commit 113: 2025-03-07T01:07:24
// Commit 114: 2025-03-07T08:28:20
// Commit 116: 2025-03-07T22:55:58
// Commit 130: 2025-03-12T01:38:10
// Commit 134: 2025-03-13T06:34:17
// Commit 136: 2025-03-13T20:05:24
// Commit 137: 2025-03-14T03:38:56
// Commit 147: 2025-03-17T01:43:32
// Commit 150: 2025-03-17T23:36:23
// Commit 160: 2025-03-20T22:00:00
// Commit 174: 2025-03-25T00:56:32
// Commit 177: 2025-03-25T22:35:50
// Commit 189: 2025-03-29T11:18:10
// Commit 190: 2025-03-29T19:06:13
// Commit 192: 2025-03-30T08:27:36
// Commit 5: 2025-02-03T05:03:06
// Commit 9: 2025-02-04T08:46:05
// Commit 42: 2025-02-14T02:25:36
// Commit 50: 2025-02-16T11:00:14
// Commit 52: 2025-02-17T01:12:59
// Commit 57: 2025-02-18T13:12:25
// Commit 68: 2025-02-21T18:35:43
// Commit 69: 2025-02-22T02:08:52
// Commit 78: 2025-02-24T17:38:04
// Commit 90: 2025-02-28T07:05:18
// Commit 92: 2025-02-28T21:02:35
// Commit 95: 2025-03-01T18:14:10
// Commit 103: 2025-03-04T02:47:23
// Commit 113: 2025-03-07T01:50:21
// Commit 120: 2025-03-09T02:39:45
// Commit 131: 2025-03-12T09:18:38
// Commit 133: 2025-03-12T22:52:28
// Commit 147: 2025-03-17T02:40:38
// Commit 153: 2025-03-18T20:38:22
// Commit 168: 2025-03-23T06:38:21
// Commit 169: 2025-03-23T14:06:34
// Commit 171: 2025-03-24T04:01:11
// Commit 177: 2025-03-25T22:07:29
// Commit 182: 2025-03-27T10:11:41
// Commit 184: 2025-03-28T00:04:12
// Commit 190: 2025-03-29T18:09:52
// Commit 14: 2025-02-05T20:32:22
// Commit 15: 2025-02-06T03:50:54
// Commit 17: 2025-02-06T17:56:57
// Commit 19: 2025-02-07T07:37:19
// Commit 24: 2025-02-08T19:06:02
// Commit 41: 2025-02-13T20:06:22
// Commit 49: 2025-02-16T04:33:26
// Commit 55: 2025-02-17T22:20:24
// Commit 70: 2025-02-22T08:49:14
// Commit 76: 2025-02-24T03:54:35
// Commit 78: 2025-02-24T17:59:30
// Commit 82: 2025-02-25T21:36:33
