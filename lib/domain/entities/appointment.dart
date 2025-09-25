import 'package:equatable/equatable.dart';

enum AppointmentStatus {
  scheduled,
  completed,
  cancelled,
  rescheduled,
}

class Appointment extends Equatable {
  final String id;
  final String title;
  final DateTime dateTime;
  final Duration duration;
  final String? description;
  final String? location;
  final AppointmentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Appointment({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.duration,
    this.description,
    this.location,
    this.status = AppointmentStatus.scheduled,
    required this.createdAt,
    required this.updatedAt,
  });

  DateTime get endDateTime => dateTime.add(duration);

  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  bool get isPast => dateTime.isBefore(DateTime.now());

  bool get isUpcoming => dateTime.isAfter(DateTime.now());

  Appointment copyWith({
    String? id,
    String? title,
    DateTime? dateTime,
    Duration? duration,
    String? description,
    String? location,
    AppointmentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      location: location ?? this.location,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        dateTime,
        duration,
        description,
        location,
        status,
        createdAt,
        updatedAt,
      ];
}