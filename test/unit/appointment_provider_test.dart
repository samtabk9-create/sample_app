import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:appointment_booking_app/domain/entities/appointment.dart';
import 'package:appointment_booking_app/domain/repositories/appointment_repository.dart';
import 'package:appointment_booking_app/presentation/providers/appointment_provider.dart';

import 'appointment_provider_test.mocks.dart';

@GenerateMocks([AppointmentRepository])
void main() {
  group('AppointmentProvider Tests', () {
    late AppointmentProvider provider;
    late MockAppointmentRepository mockRepository;
    late List<Appointment> testAppointments;

    setUp(() {
      mockRepository = MockAppointmentRepository();
      provider = AppointmentProvider(mockRepository);
      
      testAppointments = [
        Appointment(
          id: '1',
          title: 'Meeting 1',
          dateTime: DateTime(2024, 1, 15, 10, 0),
          duration: const Duration(hours: 1),
          status: AppointmentStatus.scheduled,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Appointment(
          id: '2',
          title: 'Meeting 2',
          dateTime: DateTime(2024, 1, 16, 14, 0),
          duration: const Duration(minutes: 30),
          status: AppointmentStatus.completed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    });

    test('should load appointments successfully', () async {
      // Arrange
      when(mockRepository.getAllAppointments())
          .thenAnswer((_) async => testAppointments);

      // Act
      await provider.loadAppointments();

      // Assert
      expect(provider.appointments, testAppointments);
      expect(provider.isLoading, false);
      expect(provider.error, null);
      verify(mockRepository.getAllAppointments()).called(1);
    });

    test('should handle error when loading appointments fails', () async {
      // Arrange
      const errorMessage = 'Failed to load appointments';
      when(mockRepository.getAllAppointments())
          .thenThrow(Exception(errorMessage));

      // Act
      await provider.loadAppointments();

      // Assert
      expect(provider.appointments, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.error, contains(errorMessage));
      verify(mockRepository.getAllAppointments()).called(1);
    });

    test('should add appointment successfully', () async {
      // Arrange
      final newAppointment = testAppointments.first;
      when(mockRepository.createAppointment(any))
          .thenAnswer((_) async => newAppointment.id);
      when(mockRepository.getAllAppointments())
          .thenAnswer((_) async => [newAppointment]);

      // Act
      await provider.addAppointment(
        title: newAppointment.title,
        dateTime: newAppointment.dateTime,
        duration: newAppointment.duration,
      );

      // Assert
      expect(provider.appointments, contains(newAppointment));
      expect(provider.error, null);
      verify(mockRepository.createAppointment(any)).called(1);
      verify(mockRepository.getAllAppointments()).called(1);
    });

    test('should update appointment successfully', () async {
      // Arrange
      provider.appointments.addAll(testAppointments);
      final updatedAppointment = testAppointments.first.copyWith(
        title: 'Updated Meeting',
      );
      when(mockRepository.updateAppointment(updatedAppointment))
          .thenAnswer((_) async => updatedAppointment);
      when(mockRepository.getAllAppointments())
          .thenAnswer((_) async => [updatedAppointment, testAppointments.last]);

      // Act
      await provider.updateAppointment(updatedAppointment);

      // Assert
      expect(provider.appointments.first.title, 'Updated Meeting');
      expect(provider.error, null);
      verify(mockRepository.updateAppointment(any)).called(1);
      verify(mockRepository.getAllAppointments()).called(1);
    });

    test('should delete appointment successfully', () async {
      // Arrange
      provider.appointments.addAll(testAppointments);
      const appointmentId = '1';
      when(mockRepository.deleteAppointment(appointmentId))
          .thenAnswer((_) async {});
      when(mockRepository.getAllAppointments())
          .thenAnswer((_) async => [testAppointments.last]);

      // Act
      await provider.deleteAppointment(appointmentId);

      // Assert
      expect(provider.appointments.length, 1);
      expect(provider.appointments.first.id, '2');
      expect(provider.error, null);
      verify(mockRepository.deleteAppointment(any)).called(1);
      verify(mockRepository.getAllAppointments()).called(1);
    });

    test('should search appointments by title', () async {
      // Arrange
      when(mockRepository.searchAppointments('Meeting 1'))
          .thenAnswer((_) async => [testAppointments.first]);

      // Act
      await provider.searchAppointments('Meeting 1');

      // Assert
      expect(provider.appointments.length, 1);
      expect(provider.appointments.first.title, 'Meeting 1');
      verify(mockRepository.searchAppointments('Meeting 1')).called(1);
    });

    test('should get appointments for specific date', () {
      // Arrange
      provider.appointments.addAll(testAppointments);
      final targetDate = DateTime(2024, 1, 15);

      // Act
      final result = provider.getAppointmentsForDate(targetDate);

      // Assert
      expect(result.length, 1);
      expect(result.first.title, 'Meeting 1');
    });

    test('should clear error', () async {
      // Arrange - cause an error first
      when(mockRepository.getAllAppointments())
          .thenThrow(Exception('Test error'));
      await provider.loadAppointments();
      expect(provider.error, isNotNull);

      // Act
      provider.clearError();

      // Assert
      expect(provider.error, null);
    });
  });
}