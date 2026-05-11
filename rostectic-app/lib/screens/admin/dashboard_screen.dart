import 'package:flutter/material.dart';
import '../../config/routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centro de Control'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.add_circle_outline,
                  title: 'Reservar Cita',
                  subtitle: 'Nueva reserva',
                  color: Colors.blue,
                  route: AppRoutes.booking,
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Citas',
                  subtitle: 'Ver todas',
                  color: Colors.green,
                  route: AppRoutes.myAppointments,
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.spa_outlined,
                  title: 'Servicios',
                  subtitle: 'Gestionar servicios',
                  color: Colors.purple,
                  route: AppRoutes.manageServices,
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.inventory_outlined,
                  title: 'Productos',
                  subtitle: 'Gestionar almacén',
                  color: Colors.orange,
                  route: AppRoutes.manageProducts,
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.people,
                  title: 'Especialistas',
                  subtitle: 'Gestionar especialistas',
                  color: Colors.teal,
                  route: AppRoutes.manageSpecialists,
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.block,
                  title: 'Horarios',
                  subtitle: 'Bloquear horarios',
                  color: Colors.red,
                  route: AppRoutes.manageBlockedSlots,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required String route,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
