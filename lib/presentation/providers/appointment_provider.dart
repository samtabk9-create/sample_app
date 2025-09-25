import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _repository;
  final Uuid _uuid = const Uuid();

  AppointmentProvider(this._repository);

  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _error;
  DateTime _selectedDate = DateTime.now();

  // Getters
  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;

  List<Appointment> get todayAppointments {
    final today = DateTime.now();
    return _appointments.where((appointment) {
      return appointment.dateTime.year == today.year &&
          appointment.dateTime.month == today.month &&
          appointment.dateTime.day == today.day;
    }).toList();
  }

  List<Appointment> get upcomingAppointments {
    final now = DateTime.now();
    return _appointments.where((appointment) {
      return appointment.dateTime.isAfter(now);
    }).toList();
  }

  List<Appointment> getAppointmentsForDate(DateTime date) {
    return _appointments.where((appointment) {
      return appointment.dateTime.year == date.year &&
          appointment.dateTime.month == date.month &&
          appointment.dateTime.day == date.day;
    }).toList();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> loadAppointments() async {
    _setLoading(true);
    _clearError();

    try {
      _appointments = await _repository.getAllAppointments();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load appointments: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addAppointment({
    required String title,
    required DateTime dateTime,
    required Duration duration,
    String? description,
    String? location,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final now = DateTime.now();
      final appointment = Appointment(
        id: _uuid.v4(),
        title: title,
        dateTime: dateTime,
        duration: duration,
        description: description,
        location: location,
        status: AppointmentStatus.scheduled,
        createdAt: now,
        updatedAt: now,
      );

      await _repository.createAppointment(appointment);
      await loadAppointments(); // Refresh the list
    } catch (e) {
      _setError('Failed to add appointment: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedAppointment = appointment.copyWith(
        updatedAt: DateTime.now(),
      );
      
      await _repository.updateAppointment(updatedAppointment);
      await loadAppointments(); // Refresh the list
    } catch (e) {
      _setError('Failed to update appointment: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAppointment(String id) async {
    _setLoading(true);
    _clearError();

    try {
      await _repository.deleteAppointment(id);
      await loadAppointments(); // Refresh the list
    } catch (e) {
      _setError('Failed to delete appointment: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Appointment?> getAppointmentById(String id) async {
    try {
      return await _repository.getAppointmentById(id);
    } catch (e) {
      _setError('Failed to get appointment: $e');
      return null;
    }
  }

  Future<void> searchAppointments(String query) async {
    if (query.isEmpty) {
      await loadAppointments();
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      _appointments = await _repository.searchAppointments(query);
      notifyListeners();
    } catch (e) {
      _setError('Failed to search appointments: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}