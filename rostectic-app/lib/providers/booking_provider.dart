import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/service_model.dart';
import '../config/api_config.dart';

class Specialist {
  final String id;
  final String name;
  final String? imageUrl;
  final String? role;

  Specialist({required this.id, required this.name, this.imageUrl, this.role});
}

class BookingProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Service> _services = [];
  Service? _selectedService;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  List<String> _availableSlots = [];
  bool _isLoading = false;
  String? _error;

  // Especialistas (Simplificado por el usuario)
  List<Specialist> _specialists = [];
  Specialist? _selectedSpecialist;

  BookingProvider() {
    _fetchInitialSpecialists();
  }

  void _fetchInitialSpecialists() async {
    // Inicializar con "Cualquiera" siempre disponible
    _specialists = [Specialist(id: '0', name: 'Cualquiera', role: 'Disponible')];
    _selectedSpecialist = _specialists[0];
    await fetchSpecialists();
  }

  // Getters
  List<Service> get services => _services;
  Service? get selectedService => _selectedService;
  DateTime get selectedDate => _selectedDate;
  String? get selectedTime => _selectedTime;
  List<String> get availableSlots => _availableSlots;
  List<Specialist> get specialists => _specialists;
  Specialist? get selectedSpecialist => _selectedSpecialist;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Cargar especialistas desde API
  Future<void> fetchSpecialists() async {
    try {
      final response = await _apiService.get('/api/specialists', requiresAuth: false);
      final data = _apiService.handleResponse(response);
      
      final List<Specialist> apiSpecialists = (data['data']['specialists'] as List)
          .map((s) => Specialist(
                id: s['id'],
                name: s['name'],
                role: s['role'],
                imageUrl: s['imageUrl'],
              ))
          .toList();
      
      // Combinar "Cualquiera" con los de la API
      _specialists = [
        Specialist(id: '0', name: 'Cualquiera', role: 'Disponible'),
        ...apiSpecialists,
      ];
      
      notifyListeners();
    } catch (e) {
      print('Error cargando especialistas: $e');
    }
  }

  // Getters categorizados
  List<String> get morningSlots => _availableSlots.where((s) {
    final hour = int.parse(s.split(':')[0]);
    return hour < 12;
  }).toList();

  List<String> get noonSlots => _availableSlots.where((s) {
    final hour = int.parse(s.split(':')[0]);
    return hour >= 12 && hour < 15;
  }).toList();

  List<String> get afternoonSlots => _availableSlots.where((s) {
    final hour = int.parse(s.split(':')[0]);
    return hour >= 15;
  }).toList();

  // Cargar servicios
  Future<void> fetchServices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get(ApiConfig.services, requiresAuth: false);
      final data = _apiService.handleResponse(response);
      
      _services = (data['data']['services'] as List)
          .map((s) => Service.fromJson(s))
          .toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Seleccionar servicio
  void selectService(Service service) {
    _selectedService = service;
    _selectedTime = null;
    _availableSlots = [];
    notifyListeners();
  }

  // Seleccionar especialista
  void selectSpecialist(Specialist specialist) {
    _selectedSpecialist = specialist;
    _selectedTime = null;
    fetchAvailableSlots(); // Recargar slots al cambiar especialista
    notifyListeners();
  }

  // Seleccionar fecha y cargar slots
  Future<void> selectDate(DateTime date) async {
    _selectedDate = date;
    _selectedTime = null;
    _availableSlots = [];
    notifyListeners();

    if (_selectedService != null) {
      await fetchAvailableSlots();
    }
  }

  // Cargar slots disponibles
  Future<void> fetchAvailableSlots() async {
    if (_selectedService == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      // Por ahora el backend ignora el especialista, pero lo preparamos
      final response = await _apiService.get(
        '${ApiConfig.appointments}/slots?date=$dateStr&serviceId=${_selectedService!.id}'
      );
      
      final data = _apiService.handleResponse(response);
      _availableSlots = List<String>.from(data['data']['slots']);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Seleccionar hora
  void selectTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  // Crear cita
  Future<bool> bookAppointment() async {
    if (_selectedService == null || _selectedTime == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final scheduledAt = DateTime.parse('${dateStr}T$_selectedTime:00Z');

      await _apiService.post(ApiConfig.appointments, {
        'serviceId': _selectedService!.id,
        'scheduledAt': scheduledAt.toIso8601String(),
        'notes': 'Especialista: ${_selectedSpecialist?.name ?? "Cualquiera"}',
      }, requiresAuth: true);
      
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
