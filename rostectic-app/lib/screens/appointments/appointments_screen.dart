import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/appointment_provider.dart';
import '../../config/routes.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      context.read<AppointmentProvider>().fetchUserAppointments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Citas'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.calendar_today), text: 'Próximas'),
            Tab(icon: Icon(Icons.history), text: 'Pasadas'),
          ],
        ),
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, appointmentProvider, _) {
          if (appointmentProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Próximas citas
              _buildUpcomingTab(context, appointmentProvider),
              // Tab 2: Citas pasadas
              _buildPastTab(context, appointmentProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUpcomingTab(BuildContext context, AppointmentProvider provider) {
    final upcoming = provider.upcomingAppointments;

    if (upcoming.isEmpty) {
      return _buildEmptyState(
        context,
        'No tienes citas próximas',
        Icons.event_note_outlined,
        onAction: () {
          Navigator.pushNamed(context, AppRoutes.booking);
        },
        actionLabel: 'Reservar Cita',
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.refreshAppointments(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: upcoming.length,
        itemBuilder: (context, index) {
          final appointment = upcoming[index];
          return _buildAppointmentCard(context, appointment, provider);
        },
      ),
    );
  }

  Widget _buildPastTab(BuildContext context, AppointmentProvider provider) {
    final past = provider.pastAppointments;

    if (past.isEmpty) {
      return _buildEmptyState(
        context,
        'No tienes citas pasadas',
        Icons.check_circle_outline,
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.refreshAppointments(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: past.length,
        itemBuilder: (context, index) {
          final appointment = past[index];
          return _buildAppointmentCard(context, appointment, provider);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(
      BuildContext context, appointment, AppointmentProvider provider) {
    final dateFormat = DateFormat('d MMM yyyy', 'es_ES');
    final timeFormat = DateFormat('HH:mm', 'es_ES');
    final date = dateFormat.format(appointment.scheduledAt);
    final time = timeFormat.format(appointment.scheduledAt);

    Color statusColor = Colors.blue;
    String statusLabel = appointment.status;

    switch (appointment.status) {
      case 'CONFIRMED':
        statusColor = Colors.green;
        statusLabel = 'Confirmada';
        break;
      case 'PENDING':
        statusColor = Colors.orange;
        statusLabel = 'Pendiente';
        break;
      case 'COMPLETED':
        statusColor = Colors.teal;
        statusLabel = 'Completada';
        break;
      case 'CANCELLED':
        statusColor = Colors.red;
        statusLabel = 'Cancelada';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado: Servicio y Estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.serviceName ?? 'Servicio',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (appointment.specialistName != null)
                        Text(
                          'Con ${appointment.specialistName}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Fecha y hora
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '$date • $time',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
              ],
            ),
            if (appointment.price != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.attach_money_outlined,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '\$${appointment.price?.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ],
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Notas: ${appointment.notes}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ],
            // Botones de acción
            if (appointment.isUpcoming && appointment.status != 'CANCELLED')
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Cancelar Cita'),
                            content: const Text(
                                '¿Estás seguro de que deseas cancelar esta cita?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Sí, cancelar'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true && context.mounted) {
                          final success =
                              await provider.cancelAppointment(appointment.id);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cita cancelada correctamente'),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Cancelar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String message,
    IconData icon, {
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
