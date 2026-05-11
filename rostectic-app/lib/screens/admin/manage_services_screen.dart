import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../config/api_config.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      final response = await _apiService.get(ApiConfig.services);
      final data = _apiService.handleResponse(response);
      setState(() {
        _services = List<Map<String, dynamic>>.from(data['data']['services']);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando servicios: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showServiceDialog([Map<String, dynamic>? service]) async {
    final nameController = TextEditingController(text: service?['name'] ?? '');
    final descriptionController =
        TextEditingController(text: service?['description'] ?? '');
    final durationController = TextEditingController(
        text: service?['durationMinutes']?.toString() ?? '');
    final priceController =
        TextEditingController(text: service?['price']?.toString() ?? '');

    final isEditing = service != null;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Servicio' : 'Nuevo Servicio'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre *'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              TextField(
                controller: durationController,
                decoration:
                    const InputDecoration(labelText: 'Duración (minutos) *'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Precio (€) *'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty ||
                  durationController.text.isEmpty ||
                  priceController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Completa todos los campos requeridos')),
                );
                return;
              }

              try {
                final body = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'durationMinutes': int.parse(durationController.text),
                  'price': double.parse(priceController.text),
                };

                Map<String, dynamic>? createdService;
                if (isEditing) {
                  await _apiService.put(
                    '${ApiConfig.services}/${service['id']}',
                    body,
                    requiresAuth: true,
                  );
                } else {
                  final response = await _apiService.post(
                    ApiConfig.services,
                    body,
                    requiresAuth: true,
                  );
                  final data = _apiService.handleResponse(response);
                  createdService = data['data']['service'];
                }

                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing
                          ? 'Servicio actualizado'
                          : 'Servicio creado'),
                    ),
                  );

                  // Agregar servicio a la lista localmente
                  if (createdService != null) {
                    setState(() {
                      _services.add(createdService!);
                    });
                  } else if (isEditing) {
                    // Si es edición, recargar la lista completa
                    _fetchServices();
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(Map<String, dynamic> service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desactivar Servicio'),
        content: Text('¿Estás seguro de desactivar ${service['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Desactivar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _apiService.delete('${ApiConfig.services}/${service['id']}');
        if (mounted) {
          await _fetchServices();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Servicio desactivado')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Servicios'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _services.isEmpty
              ? const Center(child: Text('No hay servicios'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    final service = _services[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(service['name']),
                        subtitle: Text(
                          '${service['durationMinutes']} min - ${service['price']}€\n${service['description'] ?? ''}',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showServiceDialog(service),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () => _confirmDelete(service),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showServiceDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
