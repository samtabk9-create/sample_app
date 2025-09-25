import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../../domain/entities/appointment.dart';
import '../../providers/appointment_provider.dart';

class AppointmentFormPage extends StatefulWidget {
  final Appointment? appointment;

  const AppointmentFormPage({
    super.key,
    this.appointment,
  });

  @override
  State<AppointmentFormPage> createState() => _AppointmentFormPageState();
}

class _AppointmentFormPageState extends State<AppointmentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  Duration _duration = AppConstants.defaultAppointmentDuration;
  AppointmentStatus _status = AppointmentStatus.scheduled;

  bool get _isEditing => widget.appointment != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _initializeWithExistingAppointment();
    } else {
      _initializeWithDefaults();
    }
  }

  void _initializeWithExistingAppointment() {
    final appointment = widget.appointment!;
    _titleController.text = appointment.title;
    _descriptionController.text = appointment.description ?? '';
    _locationController.text = appointment.location ?? '';
    _selectedDate = appointment.dateTime;
    _selectedTime = TimeOfDay.fromDateTime(appointment.dateTime);
    _duration = appointment.duration;
    _status = appointment.status;
  }

  void _initializeWithDefaults() {
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _selectedTime = TimeOfDay(hour: now.hour + 1, minute: 0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Appointment' : 'New Appointment'),
        actions: [
          TextButton(
            onPressed: _saveAppointment,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    hintText: 'Enter appointment title',
                  ),
                  maxLength: AppConstants.maxTitleLength,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter appointment description',
                  ),
                  maxLines: 3,
                  maxLength: AppConstants.maxDescriptionLength,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    hintText: 'Enter appointment location',
                  ),
                  maxLength: AppConstants.maxLocationLength,
                ),
                const SizedBox(height: 24),
                _buildDateTimeSection(),
                const SizedBox(height: 24),
                _buildDurationSection(),
                if (_isEditing) ...[
                  const SizedBox(height: 24),
                  _buildStatusSection(),
                ],
                const SizedBox(height: 32),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _saveAppointment,
                    child: Text(_isEditing ? 'Update Appointment' : 'Create Appointment'),
                  ),
                if (provider.error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            provider.error!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date & Time',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date'),
                    subtitle: Text(AppDateUtils.formatDate(_selectedDate)),
                    onTap: _selectDate,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Time'),
                    subtitle: Text(_selectedTime.format(context)),
                    onTap: _selectTime,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Duration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildDurationChip(const Duration(minutes: 30)),
                _buildDurationChip(const Duration(hours: 1)),
                _buildDurationChip(const Duration(hours: 1, minutes: 30)),
                _buildDurationChip(const Duration(hours: 2)),
                _buildDurationChip(const Duration(hours: 3)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Selected: ${AppDateUtils.formatDuration(_duration)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationChip(Duration duration) {
    final isSelected = _duration == duration;
    return FilterChip(
      label: Text(AppDateUtils.formatDuration(duration)),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _duration = duration;
          });
        }
      },
    );
  }

  Widget _buildStatusSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AppointmentStatus>(
              value: _status,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: AppointmentStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(_getStatusDisplayName(status)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _status = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusDisplayName(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.rescheduled:
        return 'Rescheduled';
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<AppointmentProvider>();
    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    try {
      if (_isEditing) {
        final updatedAppointment = widget.appointment!.copyWith(
          title: _titleController.text.trim(),
          dateTime: dateTime,
          duration: _duration,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          status: _status,
        );
        await provider.updateAppointment(updatedAppointment);
      } else {
        await provider.addAppointment(
          title: _titleController.text.trim(),
          dateTime: dateTime,
          duration: _duration,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
        );
      }

      if (mounted && provider.error == null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Appointment updated successfully'
                  : 'Appointment created successfully',
            ),
          ),
        );
      }
    } catch (e) {
      // Error is handled by the provider
    }
  }
}