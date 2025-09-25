import 'package:flutter_test/flutter_test.dart';
import 'package:appointment_booking_app/domain/entities/appointment.dart';

void main() {
  group('Appointment Entity Tests', () {
    late Appointment testAppointment;
    late DateTime testDateTime;
    late Duration testDuration;

    setUp(() {
      testDateTime = DateTime(2024, 1, 15, 10, 0);
      testDuration = const Duration(hours: 1);
      testAppointment = Appointment(
        id: 'test-id',
        title: 'Test Appointment',
        dateTime: testDateTime,
        duration: testDuration,
        description: 'Test description',
        location: 'Test location',
        status: AppointmentStatus.scheduled,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );
    });

    test('should create appointment with required fields', () {
      expect(testAppointment.id, 'test-id');
      expect(testAppointment.title, 'Test Appointment');
      expect(testAppointment.dateTime, testDateTime);
      expect(testAppointment.duration, testDuration);
      expect(testAppointment.status, AppointmentStatus.scheduled);
    });

    test('should calculate end date time correctly', () {
      final expectedEndTime = testDateTime.add(testDuration);
      expect(testAppointment.endDateTime, expectedEndTime);
    });

    test('should identify if appointment is today', () {
      final todayAppointment = testAppointment.copyWith(
        dateTime: DateTime.now(),
      );
      expect(todayAppointment.isToday, true);
      expect(testAppointment.isToday, false);
    });

    test('should identify if appointment is in the past', () {
      final pastAppointment = testAppointment.copyWith(
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(pastAppointment.isPast, true);
      expect(testAppointment.isPast, true); // 2024 date is in the past
    });

    test('should identify if appointment is upcoming', () {
      final futureAppointment = testAppointment.copyWith(
        dateTime: DateTime.now().add(const Duration(days: 1)),
      );
      expect(futureAppointment.isUpcoming, true);
      expect(testAppointment.isUpcoming, false);
    });

    test('should create copy with updated fields', () {
      final updatedAppointment = testAppointment.copyWith(
        title: 'Updated Title',
        status: AppointmentStatus.completed,
      );

      expect(updatedAppointment.title, 'Updated Title');
      expect(updatedAppointment.status, AppointmentStatus.completed);
      expect(updatedAppointment.id, testAppointment.id); // Unchanged
      expect(updatedAppointment.dateTime, testAppointment.dateTime); // Unchanged
    });

    test('should support equality comparison', () {
      final sameAppointment = Appointment(
        id: testAppointment.id,
        title: testAppointment.title,
        dateTime: testAppointment.dateTime,
        duration: testAppointment.duration,
        description: testAppointment.description,
        location: testAppointment.location,
        status: testAppointment.status,
        createdAt: testAppointment.createdAt,
        updatedAt: testAppointment.updatedAt,
      );

      final differentAppointment = testAppointment.copyWith(title: 'Different');

      expect(testAppointment, equals(sameAppointment));
      expect(testAppointment, isNot(equals(differentAppointment)));
    });
  });
}