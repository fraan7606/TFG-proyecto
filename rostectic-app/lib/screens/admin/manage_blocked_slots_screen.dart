import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../config/api_config.dart';

class ManageBlockedSlotsScreen extends StatefulWidget {
  const ManageBlockedSlotsScreen({super.key});

  @override
  State<ManageBlockedSlotsScreen> createState() =>
      _ManageBlockedSlotsScreenState();
}

class _ManageBlockedSlotsScreenState extends State<ManageBlockedSlotsScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _blockedSlots = [];
  List<Map<String, dynamic>> _specialists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await Future.wait([
        _fetchBlockedSlots(),
        _fetchSpecialists(),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchBlockedSlots() async {
    try {
      final response = await _apiService.get(ApiConfig.blockedSlots);
      final data = _apiService.handleResponse(response);
      setState(() {
        _blockedSlots =
            List<Map<String, dynamic>>.from(data['data']['blockedSlots']);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando horarios bloqueados: $e')),
        );
      }
    }
  }

  Future<void> _fetchSpecialists() async {
    try {
      final response = await _apiService.get(ApiConfig.specialists);
      final data = _apiService.handleResponse(response);
      setState(() {
        _specialists =
            List<Map<String, dynamic>>.from(data['data']['specialists']);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando especialistas: $e')),
        );
      }
    }
  }

  Future<void> _showBlockedSlotDialog(
      [Map<String, dynamic>? blockedSlot]) async {
    DateTime? startDate;
    TimeOfDay? startTime;
    DateTime? endDate;
    TimeOfDay? endTime;

    if (blockedSlot != null) {
      final start = DateTime.parse(blockedSlot['startsAt']);
      final end = DateTime.parse(blockedSlot['endsAt']);
      startDate = start;
      startTime = TimeOfDay.fromDateTime(start);
      endDate = end;
      endTime = TimeOfDay.fromDateTime(end);
    }

    final reasonController =
        TextEditingController(text: blockedSlot?['reason'] ?? '');
    String? selectedSpecialistId = blockedSlot?['specialistId'];

    final isEditing = blockedSlot != null;

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing
              ? 'Editar Horario Bloqueado'
              : 'Nuevo Horario Bloqueado'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Fecha inicio'),
                  subtitle: Text(startDate != null
                      ? DateFormat('dd/MM/yyyy').format(startDate!)
                      : 'Seleccionar'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setDialogState(() => startDate = picked);
                    }
                  },
                ),
                ListTile(
                  title: const Text('Hora inicio'),
                  subtitle: Text(startTime != null
                      ? startTime!.format(context)
                      : 'Seleccionar'),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: startTime ?? TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setDialogState(() => startTime = picked);
                    }
                  },
                ),
                ListTile(
                  title: const Text('Fecha fin'),
                  subtitle: Text(endDate != null
                      ? DateFormat('dd/MM/yyyy').format(endDate!)
                      : 'Seleccionar'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? startDate ?? DateTime.now(),
                      firstDate: startDate ?? DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setDialogState(() => endDate = picked);
                    }
                  },
                ),
                ListTile(
                  title: const Text('Hora fin'),
                  subtitle: Text(endTime != null
                      ? endTime!.format(context)
                      : 'Seleccionar'),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: endTime ?? TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setDialogState(() => endTime = picked);
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(labelText: 'Razón'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedSpecialistId,
                  decoration: const InputDecoration(
                      labelText: 'Especialista (opcional)'),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Todos los especialistas'),
                    ),
                    ..._specialists.map((specialist) {
                      return DropdownMenuItem<String>(
                        value: specialist['id'] as String,
                        child: Text(specialist['name']),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedSpecialistId = value;
                    });
                  },
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
                if (startDate == null ||
                    startTime == null ||
                    endDate == null ||
                    endTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Completa todos los campos de fecha y hora')),
                  );
                  return;
                }

                try {
                  final startsAt = DateTime(
                    startDate!.year,
                    startDate!.month,
                    startDate!.day,
                    startTime!.hour,
                    startTime!.minute,
                  );

                  final endsAt = DateTime(
                    endDate!.year,
                    endDate!.month,
                    endDate!.day,
                    endTime!.hour,
                    endTime!.minute,
                  );

                  final body = {
                    'startsAt': startsAt.toIso8601String(),
                    'endsAt': endsAt.toIso8601String(),
                    'reason': reasonController.text,
                    'specialistId': selectedSpecialistId,
                  };

                  if (isEditing) {
                    await _apiService.put(
                      '${ApiConfig.blockedSlots}/${blockedSlot['id']}',
                      body,
                    );
                  } else {
                    await _apiService.post(ApiConfig.blockedSlots, body);
                  }

                  if (mounted) {
                    Navigator.pop(context);
                    await _fetchBlockedSlots();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEditing
                            ? 'Horario bloqueado actualizado'
                            : 'Horario bloqueado creado'),
                      ),
                    );
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
      ),
    );
  }

  Future<void> _confirmDelete(Map<String, dynamic> blockedSlot) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Horario Bloqueado'),
        content:
            const Text('¿Estás seguro de eliminar este horario bloqueado?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _apiService
            .delete('${ApiConfig.blockedSlots}/${blockedSlot['id']}');
        if (mounted) {
          await _fetchBlockedSlots();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Horario bloqueado eliminado')),
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
        title: const Text('Gestionar Horarios Bloqueados'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _blockedSlots.isEmpty
              ? const Center(child: Text('No hay horarios bloqueados'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _blockedSlots.length,
                  itemBuilder: (context, index) {
                    final slot = _blockedSlots[index];
                    final startsAt = DateTime.parse(slot['startsAt']);
                    final endsAt = DateTime.parse(slot['endsAt']);
                    final specialistName =
                        slot['specialist']?['name'] ?? 'Todos';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(slot['reason'] ?? 'Sin razón'),
                        subtitle: Text(
                          '${DateFormat('dd/MM/yyyy HH:mm').format(startsAt)} - ${DateFormat('HH:mm').format(endsAt)}\nEspecialista: $specialistName',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showBlockedSlotDialog(slot),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () => _confirmDelete(slot),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBlockedSlotDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
