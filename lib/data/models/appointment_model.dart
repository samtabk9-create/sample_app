import '../../domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.title,
    required super.dateTime,
    required super.duration,
    super.description,
    super.location,
    super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] as String,
      title: map['title'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['date_time'] as int),
      duration: Duration(minutes: map['duration'] as int),
      description: map['description'] as String?,
      location: map['location'] as String?,
      status: AppointmentStatus.values.firstWhere(
        (status) => status.name == map['status'],
        orElse: () => AppointmentStatus.scheduled,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  factory AppointmentModel.fromEntity(Appointment appointment) {
    return AppointmentModel(
      id: appointment.id,
      title: appointment.title,
      dateTime: appointment.dateTime,
      duration: appointment.duration,
      description: appointment.description,
      location: appointment.location,
      status: appointment.status,
      createdAt: appointment.createdAt,
      updatedAt: appointment.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date_time': dateTime.millisecondsSinceEpoch,
      'duration': duration.inMinutes,
      'description': description,
      'location': location,
      'status': status.name,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  @override
  AppointmentModel copyWith({
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
    return AppointmentModel(
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
}