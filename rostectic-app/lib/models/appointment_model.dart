class Appointment {
  final String id;
  final String userId;
  final String serviceId;
  final String specialistId;
  final DateTime scheduledAt;
  final String status; // PENDING, CONFIRMED, COMPLETED, CANCELLED
  final String? notes;
  final String? serviceName;
  final String? specialistName;
  final double? price;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.specialistId,
    required this.scheduledAt,
    required this.status,
    this.notes,
    this.serviceName,
    this.specialistName,
    this.price,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      serviceId: json['serviceId'] as String,
      specialistId: json['specialistId'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      serviceName: json['service']?['name'] as String?,
      specialistName: json['specialist']?['name'] as String?,
      price: (json['service']?['price'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'serviceId': serviceId,
        'specialistId': specialistId,
        'scheduledAt': scheduledAt.toIso8601String(),
        'status': status,
        'notes': notes,
        'serviceName': serviceName,
        'specialistName': specialistName,
        'price': price,
        'createdAt': createdAt.toIso8601String(),
      };

  bool get isUpcoming => scheduledAt.isAfter(DateTime.now());
  bool get isPast => scheduledAt.isBefore(DateTime.now());
  bool get isCompleted => status == 'COMPLETED';
  bool get isCancelled => status == 'CANCELLED';
}
