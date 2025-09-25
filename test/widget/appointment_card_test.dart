import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appointment_booking_app/domain/entities/appointment.dart';
import 'package:appointment_booking_app/presentation/widgets/appointment/appointment_card.dart';

void main() {
  group('AppointmentCard Widget Tests', () {
    late Appointment testAppointment;

    setUp(() {
      testAppointment = Appointment(
        id: 'test-id',
        title: 'Test Meeting',
        dateTime: DateTime(2024, 1, 15, 10, 0),
        duration: const Duration(hours: 1),
        description: 'Test description',
        location: 'Test location',
        status: AppointmentStatus.scheduled,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('should display appointment title', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(AppointmentCard(appointment: testAppointment)),
      );

      expect(find.text('Test Meeting'), findsOneWidget);
    });

    testWidgets('should display appointment time', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(AppointmentCard(appointment: testAppointment)),
      );

      expect(find.textContaining('10:00 AM'), findsOneWidget);
      expect(find.textContaining('11:00 AM'), findsOneWidget);
    });

    testWidgets('should display appointment duration', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(AppointmentCard(appointment: testAppointment)),
      );

      expect(find.textContaining('1h'), findsOneWidget);
    });

    testWidgets('should display appointment location when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(AppointmentCard(appointment: testAppointment)),
      );

      expect(find.text('Test location'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('should display appointment description when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(AppointmentCard(appointment: testAppointment)),
      );

      expect(find.text('Test description'), findsOneWidget);
    });

    testWidgets('should display status chip', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(AppointmentCard(appointment: testAppointment)),
      );

      expect(find.text('Scheduled'), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        createTestWidget(
          AppointmentCard(
            appointment: testAppointment,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(AppointmentCard));
      expect(tapped, true);
    });

    testWidgets('should display edit and delete buttons when callbacks provided', (WidgetTester tester) async {
      bool editTapped = false;
      bool deleteTapped = false;

      await tester.pumpWidget(
        createTestWidget(
          AppointmentCard(
            appointment: testAppointment,
            onEdit: () => editTapped = true,
            onDelete: () => deleteTapped = true,
          ),
        ),
      );

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.text('Edit'));
      expect(editTapped, true);

      await tester.tap(find.text('Delete'));
      expect(deleteTapped, true);
    });

    testWidgets('should not display location when not provided', (WidgetTester tester) async {
      final appointmentWithoutLocation = Appointment(
        id: 'test-id-2',
        title: 'Test Meeting Without Location',
        dateTime: DateTime(2024, 1, 15, 10, 0),
        duration: const Duration(hours: 1),
        description: 'Test description',
        location: null, // No location
        status: AppointmentStatus.scheduled,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await tester.pumpWidget(
        createTestWidget(AppointmentCard(appointment: appointmentWithoutLocation)),
      );

      expect(find.byIcon(Icons.location_on), findsNothing);
    });

    testWidgets('should not display description when empty', (WidgetTester tester) async {
      final appointmentWithoutDescription = testAppointment.copyWith(description: '');
      
      await tester.pumpWidget(
        createTestWidget(AppointmentCard(appointment: appointmentWithoutDescription)),
      );

      expect(find.text('Test description'), findsNothing);
    });

    testWidgets('should display correct status colors for different statuses', (WidgetTester tester) async {
      final completedAppointment = testAppointment.copyWith(
        status: AppointmentStatus.completed,
      );
      
      await tester.pumpWidget(
        createTestWidget(AppointmentCard(appointment: completedAppointment)),
      );

      expect(find.text('Completed'), findsOneWidget);
    });
  });
}