import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/api_config.dart';
import '../../models/appointment_model.dart';
import '../../services/api_service.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Appointment>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = _fetchAppointments();
  }

  Future<List<Appointment>> _fetchAppointments() async {
    final response = await _apiService.get('${ApiConfig.appointments}/me');
    final data = _apiService.handleResponse(response);
    return (data['data']['appointments'] as List)
        .map((item) => Appointment.fromJson(item))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Citas')),
      body: FutureBuilder<List<Appointment>>(
        future: _appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _StateMessage(
              icon: Icons.cloud_off_outlined,
              title: 'No se pudieron cargar tus citas',
              message: snapshot.error.toString(),
            );
          }

          final appointments = snapshot.data ?? [];
          if (appointments.isEmpty) {
            return const _StateMessage(
              icon: Icons.event_available_outlined,
              title: 'Aún no tienes citas',
              message: 'Reserva tu primer tratamiento desde Nueva Cita.',
            );
          }

          final upcoming = appointments
              .where((item) => item.scheduledAt.isAfter(DateTime.now()))
              .toList();
          final past = appointments
              .where((item) => !item.scheduledAt.isAfter(DateTime.now()))
              .toList();

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _AppointmentsSummary(total: appointments.length, upcoming: upcoming.length),
              const SizedBox(height: 24),
              if (upcoming.isNotEmpty) ...[
                const _SectionTitle('Próximas citas'),
                ...upcoming.map((item) => _AppointmentCard(appointment: item)),
              ],
              if (past.isNotEmpty) ...[
                const SizedBox(height: 24),
                const _SectionTitle('Historial'),
                ...past.map((item) => _AppointmentCard(appointment: item)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AppointmentsSummary extends StatelessWidget {
  final int total;
  final int upcoming;

  const _AppointmentsSummary({required this.total, required this.upcoming});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$upcoming citas próximas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '$total reservas registradas en tu historial',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const _AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEEE d MMMM · HH:mm', 'es_ES');
    final isUpcoming = appointment.scheduledAt.isAfter(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUpcoming ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isUpcoming ? Icons.schedule_outlined : Icons.history_outlined,
                color: isUpcoming ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.service.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(formatter.format(appointment.scheduledAt)),
                  const SizedBox(height: 6),
                  Text('${appointment.service.durationMinutes} min · ${appointment.service.price.toStringAsFixed(2)} €'),
                ],
              ),
            ),
            Chip(label: Text(appointment.status)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _StateMessage({required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
