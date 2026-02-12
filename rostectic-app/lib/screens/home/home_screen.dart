import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RosTectic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Abrir notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final user = auth.user;
          final isAdmin = user?.isAdmin ?? false;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bienvenida
                    Text(
                      isAdmin ? 'Panel de Control' : '¡Hola!',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAdmin
                          ? 'Bienvenido, Administrador ${user?.name}'
                          : 'Bienvenido ${user?.name}, a RosTectic',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey[700],
                            fontSize: 18,
                          ),
                    ),
                    const SizedBox(height: 40),

                    if (isAdmin) ...[
                      // VISTA ADMINISTRADOR
                      _buildAdminDashboard(context),
                    ] else ...[
                      // VISTA CLIENTE
                      _buildClientDashboard(context),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClientDashboard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.1,
              children: [
                _QuickActionCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Nueva Cita',
                  color: Theme.of(context).colorScheme.primary,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.booking);
                  },
                ),
                _QuickActionCard(
                  icon: Icons.history_outlined,
                  title: 'Mis Citas',
                  color: Theme.of(context).colorScheme.secondary,
                  onTap: () {},
                ),
                _QuickActionCard(
                  icon: Icons.spa_outlined,
                  title: 'Servicios',
                  color: Colors.teal,
                  onTap: () {},
                ),
                _QuickActionCard(
                  icon: Icons.person_outline,
                  title: 'Mi Perfil',
                  color: Colors.orange,
                  onTap: () {},
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Próximas Citas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Ver todas'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildEmptyState(context, 'No tienes citas programadas'),
      ],
    );
  }

  Widget _buildAdminDashboard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gestión del Salón',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.1,
              children: [
                _QuickActionCard(
                  icon: Icons.people_outline,
                  title: 'Gestionar Perfiles',
                  color: Colors.blue,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.manageSpecialists),
                ),
                _QuickActionCard(
                  icon: Icons.event_note_outlined,
                  title: 'Todas las Citas',
                  color: Colors.purple,
                  onTap: () {},
                ),
                _QuickActionCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Productos',
                  color: Colors.orange,
                  onTap: () {},
                ),
                _QuickActionCard(
                  icon: Icons.analytics_outlined,
                  title: 'Reportes',
                  color: Colors.green,
                  onTap: () {},
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 48),
        Text(
          'Citas para Hoy',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildEmptyState(context, 'No hay citas para hoy'),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.event_note_outlined,
                size: 64,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
