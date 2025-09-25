import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/date_utils.dart';
import '../../../domain/entities/appointment.dart';
import '../../providers/appointment_provider.dart';
import '../../widgets/appointment/appointment_card.dart';
import '../appointment_detail/appointment_detail_page.dart';

class AppointmentsListPage extends StatefulWidget {
  const AppointmentsListPage({super.key});

  @override
  State<AppointmentsListPage> createState() => _AppointmentsListPageState();
}

class _AppointmentsListPageState extends State<AppointmentsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search appointments...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                if (value.isEmpty) {
                  context.read<AppointmentProvider>().loadAppointments();
                } else {
                  context.read<AppointmentProvider>().searchAppointments(value);
                }
              },
            ),
          ),
        ),
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${provider.error}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.loadAppointments();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final appointments = provider.appointments;

          if (appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_note,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? 'No appointments yet'
                        : 'No appointments found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _searchQuery.isEmpty
                        ? 'Tap the + button to create your first appointment'
                        : 'Try a different search term',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Group appointments by date
          final groupedAppointments = _groupAppointmentsByDate(appointments);

          return RefreshIndicator(
            onRefresh: () => provider.loadAppointments(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedAppointments.length,
              itemBuilder: (context, index) {
                final entry = groupedAppointments.entries.elementAt(index);
                final date = entry.key;
                final dayAppointments = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index > 0) const SizedBox(height: 24),
                    _buildDateHeader(context, date),
                    const SizedBox(height: 12),
                    ...dayAppointments.map((appointment) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AppointmentCard(
                            appointment: appointment,
                            onTap: () => _navigateToDetail(context, appointment),
                          ),
                        )),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, DateTime date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        AppDateUtils.getRelativeDate(date),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Map<DateTime, List<Appointment>> _groupAppointmentsByDate(
      List<Appointment> appointments) {
    final Map<DateTime, List<Appointment>> grouped = {};

    for (final appointment in appointments) {
      final date = DateTime(
        appointment.dateTime.year,
        appointment.dateTime.month,
        appointment.dateTime.day,
      );

      if (grouped.containsKey(date)) {
        grouped[date]!.add(appointment);
      } else {
        grouped[date] = [appointment];
      }
    }

    // Sort appointments within each day
    for (final appointments in grouped.values) {
      appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    }

    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  void _navigateToDetail(BuildContext context, Appointment appointment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AppointmentDetailPage(appointment: appointment),
      ),
    );
  }
}