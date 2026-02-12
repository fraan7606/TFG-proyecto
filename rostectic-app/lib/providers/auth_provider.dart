import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../config/api_config.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Inicializar
  Future<void> init() async {
    await _apiService.init();
    // TODO: Verificar si hay token válido y cargar usuario
  }

  // Registro con email
  Future<bool> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.post(ApiConfig.register, {
        'name': name,
        'email': email,
        'password': password,
        'role': 'CLIENT',
      });

      final data = _apiService.handleResponse(response);
      await _apiService.saveToken(data['token']);
      _user = User.fromJson(data['data']['user']);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: Error: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Registro con teléfono
  Future<bool> registerWithPhone({
    required String name,
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.post(ApiConfig.register, {
        'name': name,
        'phone': phone,
        'password': password,
        'role': 'CLIENT',
      });

      final data = _apiService.handleResponse(response);
      await _apiService.saveToken(data['token']);
      _user = User.fromJson(data['data']['user']);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: Error: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Login con email
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.post(ApiConfig.login, {
        'email': email,
        'password': password,
      });

      final data = _apiService.handleResponse(response);
      await _apiService.saveToken(data['token']);
      _user = User.fromJson(data['data']['user']);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: Error: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Login con teléfono
  Future<bool> loginWithPhone({
    required String phone,
    required String password,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.post(ApiConfig.login, {
        'phone': phone,
        'password': password,
      });

      final data = _apiService.handleResponse(response);
      await _apiService.saveToken(data['token']);
      _user = User.fromJson(data['data']['user']);
      
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: Error: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _apiService.removeToken();
    _user = null;
    notifyListeners();
  }

  // Helper para cambiar estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
