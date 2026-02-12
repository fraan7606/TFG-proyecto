import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../services/api_service.dart';

class ManageSpecialistsScreen extends StatefulWidget {
  const ManageSpecialistsScreen({super.key});

  @override
  State<ManageSpecialistsScreen> createState() => _ManageSpecialistsScreenState();
}

class _ManageSpecialistsScreenState extends State<ManageSpecialistsScreen> {
  final ApiService _apiService = ApiService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BookingProvider>().fetchSpecialists());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Perfiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showSpecialistDialog(context),
          ),
        ],
      ),
      body: Consumer<BookingProvider>(
        builder: (context, provider, child) {
          // Filtrar "Cualquiera" para la gestión
          final list = provider.specialists.where((s) => s.id != '0').toList();
          
          if (list.isEmpty) {
            return const Center(
              child: Text('No hay especialistas registrados.'),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final specialist = list[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(specialist.name),
                  subtitle: Text(specialist.role ?? 'Sin rol'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showSpecialistDialog(context, specialist: specialist),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, specialist),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showSpecialistDialog(BuildContext context, {Specialist? specialist}) {
    final nameController = TextEditingController(text: specialist?.name);
    final roleController = TextEditingController(text: specialist?.role);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(specialist == null ? 'Nuevo Especialista' : 'Editar Especialista'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Rol (Ej: Esteticista)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              
              Navigator.pop(context);
              setState(() => _isSaving = true);
              
              try {
                if (specialist == null) {
                  // Crear
                  await _apiService.post('/api/specialists', {
                    'name': nameController.text,
                    'role': roleController.text,
                  }, requiresAuth: true);
                } else {
                  // Editar
                  await _apiService.put('/api/specialists/${specialist.id}', {
                    'name': nameController.text,
                    'role': roleController.text,
                  }, requiresAuth: true);
                }
                
                if (mounted) {
                  context.read<BookingProvider>().fetchSpecialists();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Guardado correctamente')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              } finally {
                if (mounted) setState(() => _isSaving = false);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Specialist specialist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Especialista'),
        content: Text('¿Estás seguro de que quieres eliminar a ${specialist.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _apiService.delete('/api/specialists/${specialist.id}', requiresAuth: true);
                if (mounted) {
                  context.read<BookingProvider>().fetchSpecialists();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Eliminado correctamente')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar: $e')),
                  );
                }
              }
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
