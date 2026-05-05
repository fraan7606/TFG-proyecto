import 'service_model.dart';

class Appointment {
  final String id;
  final String status;
  final DateTime scheduledAt;
  final String? notes;
  final Service service;

  Appointment({
    required this.id,
    required this.status,
    required this.scheduledAt,
    this.notes,
    required this.service,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      status: json['status'],
      scheduledAt: DateTime.parse(json['scheduledAt']).toLocal(),
      notes: json['notes'],
      service: Service.fromJson(json['service']),
    );
  }
}
