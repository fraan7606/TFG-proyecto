import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/admin/dashboard_screen.dart';
import '../screens/booking/booking_screen.dart';
import '../screens/appointments/my_appointments_screen.dart';
import '../screens/services/services_catalog_screen.dart';
import '../screens/admin/manage_specialists_screen.dart';
import '../screens/admin/manage_services_screen.dart';
import '../screens/admin/manage_products_screen.dart';
import '../screens/admin/manage_blocked_slots_screen.dart';
import '../screens/admin/sales_screen.dart';
import '../screens/admin/reports_screen.dart';

class AppRoutes {
  // Nombres de rutas
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String booking = '/booking';
  static const String myAppointments = '/my-appointments';
  static const String servicesCatalog = '/services-catalog';
  static const String manageSpecialists = '/manage-specialists';
  static const String manageServices = '/manage-services';
  static const String manageProducts = '/manage-products';
  static const String manageBlockedSlots = '/manage-blocked-slots';
  static const String sales = '/sales';
  static const String reports = '/reports';

  // Mapa de rutas
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    dashboard: (context) => const DashboardScreen(),
    booking: (context) => const BookingScreen(),
    myAppointments: (context) => const MyAppointmentsScreen(),
    servicesCatalog: (context) => const ServicesCatalogScreen(),
    manageSpecialists: (context) => const ManageSpecialistsScreen(),
    manageServices: (context) => const ManageServicesScreen(),
    manageProducts: (context) => const ManageProductsScreen(),
    manageBlockedSlots: (context) => const ManageBlockedSlotsScreen(),
    sales: (context) => const SalesScreen(),
    reports: (context) => const ReportsScreen(),
  };
}
