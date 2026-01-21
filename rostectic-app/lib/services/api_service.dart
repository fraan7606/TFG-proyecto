import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final _storage = const FlutterSecureStorage();
  String? _token;

  // Getters
  String get baseUrl => ApiConfig.baseUrl;
  bool get isAuthenticated => _token != null;

  // Inicializar token desde storage
  Future<void> init() async {
    _token = await _storage.read(key: 'auth_token');
  }

  // Guardar token
  Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: 'auth_token', value: token);
  }

  // Eliminar token
  Future<void> removeToken() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
  }

  // Headers comunes
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  // GET request
  Future<http.Response> get(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(
      url,
      headers: _getHeaders(includeAuth: requiresAuth),
    );
  }

  // POST request
  Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: _getHeaders(includeAuth: requiresAuth),
      body: jsonEncode(body),
    );
  }

  // PUT request
  Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.put(
      url,
      headers: _getHeaders(includeAuth: requiresAuth),
      body: jsonEncode(body),
    );
  }

  // DELETE request
  Future<http.Response> delete(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.delete(
      url,
      headers: _getHeaders(includeAuth: requiresAuth),
    );
  }

  // Manejar respuesta
  Map<String, dynamic> handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }
}
