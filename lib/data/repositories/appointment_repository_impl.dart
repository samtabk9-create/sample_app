import '../../domain/entities/appointment.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../datasources/local/database_service.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final DatabaseService _databaseService;

  AppointmentRepositoryImpl(this._databaseService);

  @override
  Future<List<Appointment>> getAllAppointments() async {
    try {
      final appointmentModels = await _databaseService.getAllAppointments();
      return appointmentModels.cast<Appointment>();
    } catch (e) {
      throw Exception('Failed to get appointments: $e');
    }
  }

  @override
  Future<List<Appointment>> getAppointmentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final appointmentModels = await _databaseService.getAppointmentsByDateRange(
        startDate,
        endDate,
      );
      return appointmentModels.cast<Appointment>();
    } catch (e) {
      throw Exception('Failed to get appointments by date range: $e');
    }
  }

  @override
  Future<Appointment?> getAppointmentById(String id) async {
    try {
      final appointmentModel = await _databaseService.getAppointmentById(id);
      return appointmentModel;
    } catch (e) {
      throw Exception('Failed to get appointment by id: $e');
    }
  }

  @override
  Future<String> createAppointment(Appointment appointment) async {
    try {
      final appointmentModel = AppointmentModel.fromEntity(appointment);
      return await _databaseService.insertAppointment(appointmentModel);
    } catch (e) {
      throw Exception('Failed to create appointment: $e');
    }
  }

  @override
  Future<void> updateAppointment(Appointment appointment) async {
    try {
      final appointmentModel = AppointmentModel.fromEntity(appointment);
      await _databaseService.updateAppointment(appointmentModel);
    } catch (e) {
      throw Exception('Failed to update appointment: $e');
    }
  }

  @override
  Future<void> deleteAppointment(String id) async {
    try {
      await _databaseService.deleteAppointment(id);
    } catch (e) {
      throw Exception('Failed to delete appointment: $e');
    }
  }

  @override
  Future<List<Appointment>> searchAppointments(String query) async {
    try {
      final appointmentModels = await _databaseService.searchAppointments(query);
      return appointmentModels.cast<Appointment>();
    } catch (e) {
      throw Exception('Failed to search appointments: $e');
    }
  }
}