import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/date_utils.dart';
import '../../../domain/entities/appointment.dart';
import '../../providers/appointment_provider.dart';
import '../appointment_form/appointment_form_page.dart';

class AppointmentDetailPage extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailPage({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        appointment.title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildStatusChip(context),
                  ],
                ),
                const SizedBox(height: 24),

                // Date and Time Card
                _buildInfoCard(
                  context,
                  title: 'Date & Time',
                  icon: Icons.schedule,
                  children: [
                    _buildInfoRow(
                      context,
                      'Date',
                      AppDateUtils.getRelativeDate(appointment.dateTime),
                    ),
                    _buildInfoRow(
                      context,
                      'Time',
                      '${AppDateUtils.formatTime(appointment.dateTime)} - ${AppDateUtils.formatTime(appointment.endDateTime)}',
                    ),
                    _buildInfoRow(
                      context,
                      'Duration',
                      AppDateUtils.formatDuration(appointment.duration),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Location Card (if available)
                if (appointment.location != null) ...[
                  _buildInfoCard(
                    context,
                    title: 'Location',
                    icon: Icons.location_on,
                    children: [
                      Text(
                        appointment.location!,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Description Card (if available)
                if (appointment.description != null &&
                    appointment.description!.isNotEmpty) ...[
                  _buildInfoCard(
                    context,
                    title: 'Description',
                    icon: Icons.description,
                    children: [
                      Text(
                        appointment.description!,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Metadata Card
                _buildInfoCard(
                  context,
                  title: 'Details',
                  icon: Icons.info_outline,
                  children: [
                    _buildInfoRow(
                      context,
                      'Created',
                      AppDateUtils.formatDateTime(appointment.createdAt),
                    ),
                    _buildInfoRow(
                      context,
                      'Last Updated',
                      AppDateUtils.formatDateTime(appointment.updatedAt),
                    ),
                    _buildInfoRow(
                      context,
                      'ID',
                      appointment.id,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editAppointment(context),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _deleteAppointment(context),
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    Color backgroundColor;
    Color textColor;
    String label;

    switch (appointment.status) {
      case AppointmentStatus.scheduled:
        backgroundColor = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        label = 'Scheduled';
        break;
      case AppointmentStatus.completed:
        backgroundColor = const Color(0xFFE8F5E8);
        textColor = const Color(0xFF2E7D32);
        label = 'Completed';
        break;
      case AppointmentStatus.cancelled:
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        label = 'Cancelled';
        break;
      case AppointmentStatus.rescheduled:
        backgroundColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFE65100);
        label = 'Rescheduled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'edit':
        _editAppointment(context);
        break;
      case 'delete':
        _deleteAppointment(context);
        break;
    }
  }

  void _editAppointment(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AppointmentFormPage(appointment: appointment),
      ),
    );
  }

  void _deleteAppointment(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment'),
        content: Text(
          'Are you sure you want to delete "${appointment.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              
              final provider = context.read<AppointmentProvider>();
              await provider.deleteAppointment(appointment.id);
              
              if (context.mounted && provider.error == null) {
                Navigator.of(context).pop(); // Go back to previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment deleted successfully'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}