import '../entities/appointment.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAllAppointments();
  Future<List<Appointment>> getAppointmentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Appointment?> getAppointmentById(String id);
  Future<String> createAppointment(Appointment appointment);
  Future<void> updateAppointment(Appointment appointment);
  Future<void> deleteAppointment(String id);
  Future<List<Appointment>> searchAppointments(String query);
}