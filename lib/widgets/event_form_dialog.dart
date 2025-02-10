import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/constants.dart';
import '../services/notification_service.dart';

class EventFormDialog extends StatefulWidget {
  final Event? event;
  final DateTime selectedDate;

  const EventFormDialog({
    Key? key,
    this.event,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<EventFormDialog> createState() => _EventFormDialogState();
}

class _EventFormDialogState extends State<EventFormDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  late DateTime _selectedDate;
  late Color _selectedColor;
  late EventCategory _selectedCategory;
  late bool _isAllDay;
  late DateTime _startTime;
  late DateTime _endTime;
  late RecurrenceType _recurrence;
  late ReminderDuration _reminder;
  late int _priority;
  late List<String> _tags;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.event != null;
    _selectedDate = widget.event?.date ?? widget.selectedDate;
    _selectedColor = widget.event != null 
        ? AppColors.getEventColor(widget.event!.color)
        : AppColors.eventColors[0];
    _selectedCategory = widget.event?.category ?? EventCategory.personal;
    _isAllDay = widget.event?.isAllDay ?? true;
    _startTime = widget.event?.startTime ?? DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      9, 0,
    );
    _endTime = widget.event?.endTime ?? DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      10, 0,
    );
    _recurrence = widget.event?.recurrence ?? RecurrenceType.never;
    _reminder = widget.event?.reminder ?? ReminderDuration.never;
    _priority = widget.event?.priority ?? 1;
    _tags = List.from(widget.event?.tags ?? []);
    
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _locationController.text = widget.event!.location ?? '';
      _notesController.text = widget.event!.notes ?? '';
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final event = Event(
        id: widget.event?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _selectedDate,
        color: AppColors.colorToHex(_selectedColor),
        category: _selectedCategory,
        isAllDay: _isAllDay,
        startTime: _isAllDay ? null : _startTime,
        endTime: _isAllDay ? null : _endTime,
        location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        recurrence: _recurrence,
        reminder: _reminder,
        priority: _priority,
        tags: _tags,
      );
      
      Navigator.of(context).pop(event);
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
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
                BoxShadow(
                  color: AppColors.secondaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Header
                _buildHeader(),
                
                // Form Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                    child: _buildForm(),
                  ),
                ),
                
                // Action Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        gradient: _isEditing ? AppColors.secondaryGradient : AppColors.primaryGradient,
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
            child: Icon(
              _isEditing ? Icons.edit_rounded : Icons.add_rounded,
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
                  _isEditing ? AppStrings.editEvent : AppStrings.addEvent,
                  style: AppTextStyles.neonText.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Level up your productivity!',
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
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Field
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: AppStrings.eventTitle,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              prefixIcon: const Icon(Icons.title),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppStrings.eventTitleRequired;
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Description Field
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: AppStrings.eventDescription,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              prefixIcon: const Icon(Icons.description),
            ),
            maxLines: 3,
            textInputAction: TextInputAction.newline,
          ),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Date Selector
          _buildDateSelector(),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Category Selector
          _buildCategorySelector(),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Reminder Selector
          _buildReminderSelector(),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Recurrence Selector
          _buildRecurrenceSelector(),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Priority Selector
          _buildPrioritySelector(),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // All Day Toggle
          _buildAllDayToggle(),
          
          if (!_isAllDay) ...[
            const SizedBox(height: AppDimensions.paddingMedium),
            _buildTimeSelector(),
          ],
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Location Field
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Location (Optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              prefixIcon: const Icon(Icons.location_on),
            ),
            textInputAction: TextInputAction.next,
          ),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Notes Field
          TextFormField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Notes (Optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              prefixIcon: const Icon(Icons.note),
            ),
            maxLines: 2,
            textInputAction: TextInputAction.newline,
          ),
          
          const SizedBox(height: AppDimensions.paddingMedium),
          
          // Color Selector
          _buildColorSelector(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.dividerColor),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: AppColors.textSecondary),
            const SizedBox(width: AppDimensions.paddingMedium),
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: AppTextStyles.bodyText,
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Color',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Wrap(
          spacing: AppDimensions.paddingSmall,
          runSpacing: AppDimensions.paddingSmall,
          children: AppColors.eventColors.map((color) {
            final isSelected = color == _selectedColor;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: AppColors.textPrimary, width: 3)
                      : Border.all(color: AppColors.dividerColor),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.dividerColor),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<EventCategory>(
              value: _selectedCategory,
              isExpanded: true,
              onChanged: (EventCategory? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
              items: EventCategory.values.map<DropdownMenuItem<EventCategory>>((EventCategory category) {
                return DropdownMenuItem<EventCategory>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        AppColors.getCategoryIcon(category),
                        color: AppColors.getCategoryColor(category),
                        size: 20,
                      ),
                      const SizedBox(width: AppDimensions.paddingSmall),
                      Text(
                        AppColors.getCategoryName(category),
                        style: AppTextStyles.bodyText,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReminderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reminder',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: DropdownButton<ReminderDuration>(
            value: _reminder,
            isExpanded: true,
            underline: const SizedBox(),
            onChanged: (ReminderDuration? newValue) {
              setState(() {
                _reminder = newValue ?? ReminderDuration.never;
              });
            },
            items: ReminderDuration.values.map<DropdownMenuItem<ReminderDuration>>((ReminderDuration reminder) {
              return DropdownMenuItem<ReminderDuration>(
                value: reminder,
                child: Row(
                  children: [
                    Icon(
                      reminder == ReminderDuration.never 
                          ? Icons.notifications_off_rounded
                          : Icons.notifications_rounded,
                      color: reminder == ReminderDuration.never 
                          ? AppColors.textSecondary
                          : AppColors.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Text(
                      ReminderDurationHelper.getName(reminder),
                      style: AppTextStyles.bodyText,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurrenceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repeat',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.surfaceColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: DropdownButton<RecurrenceType>(
            value: _recurrence,
            isExpanded: true,
            underline: const SizedBox(),
            onChanged: (RecurrenceType? newValue) {
              setState(() {
                _recurrence = newValue ?? RecurrenceType.never;
              });
            },
            items: RecurrenceType.values.map<DropdownMenuItem<RecurrenceType>>((RecurrenceType recurrence) {
              IconData icon;
              String name;
              
              switch (recurrence) {
                case RecurrenceType.never:
                  icon = Icons.event_rounded;
                  name = 'Never';
                  break;
                case RecurrenceType.daily:
                  icon = Icons.today_rounded;
                  name = 'Daily';
                  break;
                case RecurrenceType.weekly:
                  icon = Icons.view_week_rounded;
                  name = 'Weekly';
                  break;
                case RecurrenceType.monthly:
                  icon = Icons.calendar_month_rounded;
                  name = 'Monthly';
                  break;
                case RecurrenceType.yearly:
                  icon = Icons.calendar_today_rounded;
                  name = 'Yearly';
                  break;
              }
              
              return DropdownMenuItem<RecurrenceType>(
                value: recurrence,
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: recurrence == RecurrenceType.never 
                          ? AppColors.textSecondary
                          : AppColors.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppDimensions.paddingSmall),
                    Text(
                      name,
                      style: AppTextStyles.bodyText,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        Row(
          children: [1, 2, 3].map((priority) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: GestureDetector(
                  onTap: () => setState(() => _priority = priority),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                    decoration: BoxDecoration(
                      color: _priority == priority 
                          ? AppColors.primaryColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                      border: Border.all(
                        color: _priority == priority 
                            ? AppColors.primaryColor 
                            : AppColors.dividerColor,
                        width: _priority == priority ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          priority == 1 ? Icons.flag : priority == 2 ? Icons.outlined_flag : Icons.flag,
                          color: priority == 1 
                              ? Colors.green 
                              : priority == 2 
                                  ? Colors.orange 
                                  : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          priority == 1 ? 'Low' : priority == 2 ? 'Medium' : 'High',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: _priority == priority ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAllDayToggle() {
    return Row(
      children: [
        Icon(Icons.access_time, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: AppDimensions.paddingSmall),
        Text(
          'All Day',
          style: AppTextStyles.bodyText,
        ),
        const Spacer(),
        Switch(
          value: _isAllDay,
          onChanged: (value) {
            setState(() {
              _isAllDay = value;
            });
          },
          activeColor: AppColors.primaryColor,
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start Time',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_startTime),
                  );
                  if (time != null) {
                    setState(() {
                      _startTime = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        time.hour,
                        time.minute,
                      );
                      if (_startTime.isAfter(_endTime)) {
                        _endTime = _startTime.add(const Duration(hours: 1));
                      }
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.dividerColor),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  ),
                  child: Text(
                    TimeOfDay.fromDateTime(_startTime).format(context),
                    style: AppTextStyles.bodyText,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'End Time',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSmall),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_endTime),
                  );
                  if (time != null) {
                    setState(() {
                      _endTime = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.dividerColor),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  ),
                  child: Text(
                    TimeOfDay.fromDateTime(_endTime).format(context),
                    style: AppTextStyles.bodyText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.cancel),
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          ElevatedButton(
            onPressed: _saveEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
            ),
            child: Text(_isEditing ? AppStrings.save : AppStrings.addEvent),
          ),
        ],
      ),
    );
  }
}// Commit 66: 2025-02-21T04:37:29
// Commit 12: 2025-02-05T06:25:09
// Commit 27: 2025-02-09T16:15:49
// Commit 35: 2025-02-12T00:50:20
// Commit 38: 2025-02-12T22:56:06
// Commit 44: 2025-02-14T17:16:30
// Commit 78: 2025-02-24T17:17:00
// Commit 107: 2025-03-05T06:52:41
// Commit 150: 2025-03-17T23:43:52
// Commit 163: 2025-03-21T19:54:05
// Commit 166: 2025-03-22T16:59:15
// Commit 170: 2025-03-23T21:29:47
// Commit 58: 2025-02-18T20:01:21
// Commit 109: 2025-03-05T20:48:24
// Commit 115: 2025-03-07T15:53:51
// Commit 117: 2025-03-08T05:28:55
// Commit 139: 2025-03-14T17:06:30
// Commit 147: 2025-03-17T02:10:17
// Commit 151: 2025-03-18T06:05:20
// Commit 1: 2025-02-02T00:05:00
// Commit 10: 2025-02-04T16:33:23
// Commit 83: 2025-02-26T04:34:20
// Commit 122: 2025-03-09T16:42:12
// Commit 126: 2025-03-10T21:28:26
// Commit 156: 2025-03-19T18:16:37
// Commit 184: 2025-03-28T00:21:38
// Commit 186: 2025-03-28T13:54:18
// Commit 198: 2025-04-01T03:08:38
// Commit 199: 2025-04-01T10:07:46
// Commit 200: 2025-04-01T17:04:35
// Commit 20: 2025-02-07T15:13:59
// Commit 70: 2025-02-22T08:39:38
// Commit 91: 2025-02-28T13:49:21
// Commit 113: 2025-03-07T01:50:21
// Commit 129: 2025-03-11T19:05:11
// Commit 151: 2025-03-18T06:17:45
// Commit 178: 2025-03-26T06:04:43
// Commit 5: 2025-02-03T05:00:17
// Commit 30: 2025-02-10T14:16:33
