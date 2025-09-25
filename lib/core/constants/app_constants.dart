class AppConstants {
  // App Info
  static const String appName = 'Appointment Booking';
  static const String appVersion = '1.0.0';

  // Routes
  static const String homeRoute = '/';
  static const String calendarRoute = '/calendar';
  static const String appointmentFormRoute = '/appointment/form';
  static const String appointmentDetailRoute = '/appointment/detail';

  // Database
  static const String databaseName = 'appointments.db';
  static const int databaseVersion = 1;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 48.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Default Values
  static const Duration defaultAppointmentDuration = Duration(hours: 1);
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxLocationLength = 200;
}