import 'package:flutter/material.dart';
import '../../config/api_config.dart';
import '../../models/service_model.dart';
import '../../services/api_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Service>> _servicesFuture;

  @override
  void initState() {
    super.initState();
    _servicesFuture = _fetchServices();
  }

  Future<List<Service>> _fetchServices() async {
    final response = await _apiService.get(ApiConfig.services, requiresAuth: false);
    final data = _apiService.handleResponse(response);
    return (data['data']['services'] as List)
        .map((item) => Service.fromJson(item))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      body: FutureBuilder<List<Service>>(
        future: _servicesFuture,
        builder: (context, snapshot) {
          final services = snapshot.data ?? [];
          final averagePrice = services.isEmpty
              ? 0.0
              : services.map((item) => item.price).reduce((a, b) => a + b) / services.length;
          final totalPotential = services.fold<double>(0, (sum, item) => sum + item.price * 8);

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Resumen del salón',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Indicadores preparados para presentar gestión, demanda y potencial de ingresos.'),
              const SizedBox(height: 24),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.35,
                children: [
                  _MetricCard(title: 'Servicios activos', value: '${services.length}', icon: Icons.spa_outlined, color: Colors.pink),
                  _MetricCard(title: 'Ticket medio', value: '${averagePrice.toStringAsFixed(0)} €', icon: Icons.payments_outlined, color: Colors.green),
                  const _MetricCard(title: 'Ocupación demo', value: '78%', icon: Icons.event_available_outlined, color: Colors.purple),
                  _MetricCard(title: 'Potencial diario', value: '${totalPotential.toStringAsFixed(0)} €', icon: Icons.trending_up_outlined, color: Colors.orange),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Servicios con mayor potencial',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...services.map((service) => _ServicePerformanceRow(service: service)),
              const SizedBox(height: 32),
              Text(
                'Insights para la demo',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const _InsightCard(text: 'La agenda evita solapamientos y muestra huecos disponibles en tiempo real.'),
              const _InsightCard(text: 'El panel permite separar experiencia de cliente y administración.'),
              const _InsightCard(text: 'La arquitectura API permite ampliar a notificaciones, inventario y reseñas.'),
            ],
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                Text(title),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicePerformanceRow extends StatelessWidget {
  final Service service;

  const _ServicePerformanceRow({required this.service});

  @override
  Widget build(BuildContext context) {
    final score = (service.price / 60).clamp(0.25, 1.0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                Text('${service.price.toStringAsFixed(2)} €'),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: score, minHeight: 8),
            const SizedBox(height: 8),
            Text('${service.durationMinutes} min · demanda estimada alta'),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String text;

  const _InsightCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.lightbulb_outline, color: Theme.of(context).colorScheme.primary),
        title: Text(text),
      ),
    );
  }
}
