import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/appointment_model.dart';

class AppointmentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Appointment> get appointments => _appointments;

  List<Appointment> get upcomingAppointments {
    return _appointments
        .where((a) => a.isUpcoming && a.status != 'CANCELLED')
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  List<Appointment> get pastAppointments {
    return _appointments
        .where((a) => a.isPast || a.status == 'CANCELLED')
        .toList()
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
  }

  bool get isLoading => _isLoading;
  String? get error => _error;

  // Cargar citas del usuario autenticado
  Future<void> fetchUserAppointments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(
        '/api/appointments/me',
        requiresAuth: true,
      );

      final data = _apiService.handleResponse(response);

      _appointments = (data['data']['appointments'] as List)
          .map((a) => Appointment.fromJson(a))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Recargar citas
  Future<void> refreshAppointments() async {
    await fetchUserAppointments();
  }

  // Cancelar cita
  Future<bool> cancelAppointment(String appointmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.put(
        '/api/appointments/$appointmentId',
        {'status': 'CANCELLED'},
        requiresAuth: true,
      );

      // Actualizar la lista local
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        final appointment = _appointments[index];
        _appointments[index] = Appointment(
          id: appointment.id,
          userId: appointment.userId,
          serviceId: appointment.serviceId,
          specialistId: appointment.specialistId,
          scheduledAt: appointment.scheduledAt,
          status: 'CANCELLED',
          notes: appointment.notes,
          serviceName: appointment.serviceName,
          specialistName: appointment.specialistName,
          price: appointment.price,
          createdAt: appointment.createdAt,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
