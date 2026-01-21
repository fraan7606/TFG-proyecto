class ApiConfig {
  // URL base del backend
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Endpoints de autenticación
  static const String registerEmail = '/auth/register/email';
  static const String registerPhone = '/auth/register/phone';
  static const String loginEmail = '/auth/login/email';
  static const String loginPhone = '/auth/login/phone';
  static const String verifyOtp = '/auth/verify-otp';
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
