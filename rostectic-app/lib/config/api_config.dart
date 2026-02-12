class ApiConfig {
  // URL base del backend
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Endpoints de autenticación
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  
  // Endpoints de servicios
  static const String services = '/services';
  
  // Endpoints de citas
  static const String appointments = '/appointments';
  
  // Endpoints de usuarios
  static const String users = '/users';
  static const String profile = '/users/profile';
  
  // Endpoints de reseñas
  static const String reviews = '/reviews';
  
  // Endpoints de productos
  static const String products = '/products';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
