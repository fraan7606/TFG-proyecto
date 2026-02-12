import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/admin/manage_specialists_screen.dart';

class AppRoutes {
  // Nombres de rutas
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String booking = '/booking';
  static const String manageSpecialists = '/manage-specialists';
  
  // Mapa de rutas
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    booking: (context) => const BookingScreen(),
    manageSpecialists: (context) => const ManageSpecialistsScreen(),
  };
}
