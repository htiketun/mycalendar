import 'package:flutter/material.dart';
import '../models/event.dart';
import '../utils/constants.dart';

class CreateEventScreen extends StatefulWidget {
  final Event? event;
  final DateTime selectedDate;

  const CreateEventScreen({
    Key? key,
    this.event,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  late DateTime _selectedDate;
  late Color _selectedColor;
  late EventCategory _selectedCategory;
  late bool _isAllDay;
  late DateTime _startTime;
  late DateTime _endTime;
  late RecurrenceType _recurrence;
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
                    child: _buildResponsiveForm(),
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
        gradient: _isEditing ? AppColors.secondaryGradient : AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: (_isEditing ? AppColors.secondaryColor : AppColors.primaryColor).withOpacity(0.3),
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
                  _isEditing ? 'Edit Event' : 'Create New Event',
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  _isEditing ? 'Update your event details' : 'Level up your productivity!',
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
            child: Icon(
              _isEditing ? Icons.edit_rounded : Icons.add_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveForm() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 800;
        
        if (isLargeScreen) {
          return _buildLargeScreenLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildFormFields(),
              ),
            ),
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildLargeScreenLayout() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBasicInfoCard(),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        _buildDateTimeCard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingLarge),
                  // Right column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCategoryPriorityCard(),
                        const SizedBox(height: AppDimensions.paddingLarge),
                        _buildAdditionalDetailsCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  List<Widget> _buildFormFields() {
    return [
      _buildBasicInfoCard(),
      const SizedBox(height: AppDimensions.paddingLarge),
      _buildDateTimeCard(),
      const SizedBox(height: AppDimensions.paddingLarge),
      _buildCategoryPriorityCard(),
      const SizedBox(height: AppDimensions.paddingLarge),
      _buildAdditionalDetailsCard(),
    ];
  }

  Widget _buildBasicInfoCard() {
    return _buildCard(
      title: 'Basic Information',
      icon: Icons.info_rounded,
      children: [
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Event Title',
            prefixIcon: const Icon(Icons.title),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Event title is required';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            prefixIcon: const Icon(Icons.description),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
          ),
          maxLines: 3,
          textInputAction: TextInputAction.newline,
        ),
      ],
    );
  }

  Widget _buildDateTimeCard() {
    return _buildCard(
      title: 'Date & Time',
      icon: Icons.schedule_rounded,
      children: [
        _buildDateSelector(),
        const SizedBox(height: AppDimensions.paddingMedium),
        _buildAllDayToggle(),
        if (!_isAllDay) ...[
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildTimeSelector(),
        ],
      ],
    );
  }

  Widget _buildCategoryPriorityCard() {
    return _buildCard(
      title: 'Category & Priority',
      icon: Icons.category_rounded,
      children: [
        _buildCategorySelector(),
        const SizedBox(height: AppDimensions.paddingMedium),
        _buildPrioritySelector(),
        const SizedBox(height: AppDimensions.paddingMedium),
        _buildColorSelector(),
      ],
    );
  }

  Widget _buildAdditionalDetailsCard() {
    return _buildCard(
      title: 'Additional Details',
      icon: Icons.more_horiz_rounded,
      children: [
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Location (Optional)',
            prefixIcon: const Icon(Icons.location_on),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        TextFormField(
          controller: _notesController,
          decoration: InputDecoration(
            labelText: 'Notes (Optional)',
            prefixIcon: const Icon(Icons.note),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
          ),
          maxLines: 3,
          textInputAction: TextInputAction.newline,
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  color: AppColors.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 20),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              Text(
                title,
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLarge),
          ...children,
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

  Widget _buildAllDayToggle() {
    return Row(
      children: [
        Icon(Icons.access_time, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: AppDimensions.paddingSmall),
        Text('All Day', style: AppTextStyles.bodyText),
        const Spacer(),
        Switch(
          value: _isAllDay,
          onChanged: (value) => setState(() => _isAllDay = value),
          activeColor: AppColors.primaryColor,
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return Row(
      children: [
        Expanded(child: _buildTimeField('Start Time', _startTime, (time) => _startTime = time)),
        const SizedBox(width: AppDimensions.paddingMedium),
        Expanded(child: _buildTimeField('End Time', _endTime, (time) => _endTime = time)),
      ],
    );
  }

  Widget _buildTimeField(String label, DateTime time, Function(DateTime) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppDimensions.paddingSmall),
        InkWell(
          onTap: () async {
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(time),
            );
            if (selectedTime != null) {
              setState(() {
                onChanged(DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  _selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                ));
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
              TimeOfDay.fromDateTime(time).format(context),
              style: AppTextStyles.bodyText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
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
                if (newValue != null) setState(() => _selectedCategory = newValue);
              },
              items: EventCategory.values.map<DropdownMenuItem<EventCategory>>((category) {
                return DropdownMenuItem<EventCategory>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(AppColors.getCategoryIcon(category), 
                           color: AppColors.getCategoryColor(category), size: 20),
                      const SizedBox(width: AppDimensions.paddingSmall),
                      Text(AppColors.getCategoryName(category), style: AppTextStyles.bodyText),
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

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Priority', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
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
                          ? AppColors.primaryColor.withOpacity(0.2)
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
                          color: priority == 1 ? Colors.green : priority == 2 ? Colors.orange : Colors.red,
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

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Event Color', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
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
                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _saveEvent,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                ),
              ),
              child: Text(_isEditing ? 'Update Event' : 'Create Event'),
            ),
          ),
        ],
      ),
    );
  }
}// Commit 39: 2025-02-13T05:14:00
// Commit 108: 2025-03-05T14:18:06
// Commit 127: 2025-03-11T05:03:24
// Commit 131: 2025-03-12T08:52:43
// Commit 157: 2025-03-20T01:05:16
// Commit 190: 2025-03-29T18:17:24
// Commit 198: 2025-04-01T03:31:16
// Commit 200: 2025-04-01T17:18:57
// Commit 5: 2025-02-03T04:56:29
// Commit 13: 2025-02-05T13:02:47
// Commit 31: 2025-02-10T21:13:53
// Commit 65: 2025-02-20T21:36:47
// Commit 134: 2025-03-13T06:03:35
// Commit 154: 2025-03-19T03:49:51
// Commit 195: 2025-03-31T05:47:17
// Commit 20: 2025-02-07T14:56:11
// Commit 33: 2025-02-11T11:21:59
// Commit 39: 2025-02-13T05:06:21
// Commit 51: 2025-02-16T18:00:25
// Commit 60: 2025-02-19T10:14:02
// Commit 74: 2025-02-23T13:02:14
// Commit 77: 2025-02-24T10:14:00
// Commit 82: 2025-02-25T21:53:57
// Commit 86: 2025-02-27T02:25:28
// Commit 93: 2025-03-01T04:12:33
// Commit 97: 2025-03-02T07:58:40
// Commit 120: 2025-03-09T02:46:34
// Commit 125: 2025-03-10T14:49:32
// Commit 129: 2025-03-11T19:01:49
// Commit 139: 2025-03-14T17:52:43
// Commit 147: 2025-03-17T02:31:35
// Commit 158: 2025-03-20T08:27:27
// Commit 167: 2025-03-22T23:47:22
// Commit 199: 2025-04-01T10:10:30
// Commit 7: 2025-02-03T18:54:45
// Commit 17: 2025-02-06T17:37:36
// Commit 21: 2025-02-07T21:49:19
// Commit 23: 2025-02-08T12:34:06
// Commit 31: 2025-02-10T20:40:32
// Commit 48: 2025-02-15T21:22:59
// Commit 51: 2025-02-16T18:14:32
// Commit 53: 2025-02-17T08:11:47
// Commit 54: 2025-02-17T15:39:40
// Commit 67: 2025-02-21T11:43:13
// Commit 68: 2025-02-21T19:18:14
// Commit 69: 2025-02-22T02:18:20
// Commit 70: 2025-02-22T09:25:57
// Commit 74: 2025-02-23T13:37:32
// Commit 77: 2025-02-24T10:16:55
// Commit 84: 2025-02-26T12:31:25
// Commit 92: 2025-02-28T21:13:09
// Commit 94: 2025-03-01T11:14:40
// Commit 98: 2025-03-02T15:34:10
// Commit 103: 2025-03-04T02:32:34
// Commit 111: 2025-03-06T11:44:21
// Commit 121: 2025-03-09T09:44:40
// Commit 123: 2025-03-10T00:19:46
// Commit 130: 2025-03-12T01:49:03
// Commit 134: 2025-03-13T06:26:55
// Commit 135: 2025-03-13T13:12:40
// Commit 137: 2025-03-14T03:20:33
// Commit 146: 2025-03-16T19:12:56
// Commit 151: 2025-03-18T06:05:20
// Commit 153: 2025-03-18T21:06:29
// Commit 162: 2025-03-21T12:34:42
// Commit 176: 2025-03-25T15:14:30
// Commit 193: 2025-03-30T15:22:15
// Commit 4: 2025-02-02T21:42:45
// Commit 12: 2025-02-05T06:26:19
// Commit 18: 2025-02-07T00:54:37
// Commit 23: 2025-02-08T11:58:09
// Commit 42: 2025-02-14T02:57:00
// Commit 74: 2025-02-23T13:47:20
// Commit 79: 2025-02-25T00:45:24
// Commit 83: 2025-02-26T04:34:20
// Commit 85: 2025-02-26T19:21:28
// Commit 87: 2025-02-27T09:34:30
// Commit 94: 2025-03-01T11:09:42
// Commit 96: 2025-03-02T01:29:15
// Commit 97: 2025-03-02T08:00:13
// Commit 111: 2025-03-06T11:20:45
// Commit 118: 2025-03-08T12:35:58
// Commit 119: 2025-03-08T19:33:46
// Commit 123: 2025-03-09T23:55:56
// Commit 141: 2025-03-15T07:50:04
// Commit 159: 2025-03-20T15:37:17
// Commit 167: 2025-03-23T00:07:51
// Commit 168: 2025-03-23T07:20:53
// Commit 171: 2025-03-24T03:58:57
// Commit 180: 2025-03-26T19:31:15
// Commit 193: 2025-03-30T15:47:13
// Commit 195: 2025-03-31T05:45:01
// Commit 18: 2025-02-07T00:55:03
// Commit 26: 2025-02-09T09:40:38
// Commit 30: 2025-02-10T14:03:15
// Commit 40: 2025-02-13T12:25:13
// Commit 61: 2025-02-19T17:26:28
// Commit 63: 2025-02-20T07:23:54
// Commit 65: 2025-02-20T21:27:56
// Commit 67: 2025-02-21T11:30:53
// Commit 75: 2025-02-23T20:07:47
// Commit 80: 2025-02-25T07:44:54
// Commit 123: 2025-03-09T23:51:22
// Commit 139: 2025-03-14T17:38:54
// Commit 154: 2025-03-19T03:56:41
// Commit 160: 2025-03-20T22:16:44
// Commit 176: 2025-03-25T15:07:57
// Commit 179: 2025-03-26T12:52:02
// Commit 183: 2025-03-27T17:08:09
// Commit 185: 2025-03-28T07:01:25
// Commit 187: 2025-03-28T21:47:22
// Commit 192: 2025-03-30T08:21:23
// Commit 9: 2025-02-04T09:08:22
// Commit 18: 2025-02-07T00:24:48
// Commit 21: 2025-02-07T22:35:49
// Commit 35: 2025-02-12T01:33:03
// Commit 36: 2025-02-12T07:51:46
// Commit 43: 2025-02-14T10:10:36
// Commit 46: 2025-02-15T06:46:10
// Commit 47: 2025-02-15T14:07:52
// Commit 59: 2025-02-19T03:10:46
// Commit 60: 2025-02-19T10:03:55
// Commit 61: 2025-02-19T17:17:04
// Commit 66: 2025-02-21T04:31:37
// Commit 75: 2025-02-23T20:11:53
// Commit 102: 2025-03-03T20:03:24
// Commit 105: 2025-03-04T17:00:55
// Commit 112: 2025-03-06T18:43:07
// Commit 113: 2025-03-07T01:52:25
// Commit 116: 2025-03-07T22:54:08
// Commit 119: 2025-03-08T20:12:05
