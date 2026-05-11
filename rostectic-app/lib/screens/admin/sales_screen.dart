import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import '../../config/api_config.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _sales = [];
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await Future.wait([
        _fetchSales(),
        _fetchProducts(),
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

  Future<void> _fetchSales() async {
    try {
      String url = ApiConfig.sales;
      if (_selectedDate != null) {
        final startDate = DateTime(
            _selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
        final endDate = startDate.add(const Duration(days: 1));
        url =
            '$url?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}';
      }

      final response = await _apiService.get(url);
      final data = _apiService.handleResponse(response);
      setState(() {
        _sales = List<Map<String, dynamic>>.from(data['data']['sales']);
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando ventas: $e')),
        );
      }
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await _apiService.get(ApiConfig.products);
      final data = _apiService.handleResponse(response);
      setState(() {
        _products = List<Map<String, dynamic>>.from(data['data']['products']);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando productos: $e')),
        );
      }
    }
  }

  Future<void> _showNewSaleDialog() async {
    final selectedProducts = <Map<String, dynamic>>[];
    DateTime saleDate = DateTime.now();
    final notesController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nueva Venta'),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Fecha'),
                    subtitle: Text(DateFormat('dd/MM/yyyy').format(saleDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: saleDate,
                        firstDate: DateTime(2024),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setDialogState(() => saleDate = picked);
                      }
                    },
                  ),
                  const Divider(),
                  const Text('Productos:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...selectedProducts.map((item) {
                    final product = _products.firstWhere(
                      (p) => p['id'].toString() == item['productId'].toString(),
                    );
                    final price = (item['price'] as num).toDouble();
                    final quantity = (item['quantity'] as num).toInt();
                    return ListTile(
                      title: Text(product['name']),
                      subtitle: Text(
                          'Cantidad: $quantity - ${price.toStringAsFixed(2)}€ c/u'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setDialogState(() {
                            selectedProducts.remove(item);
                          });
                        },
                      ),
                    );
                  }).toList(),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await _showProductSelector(context);
                      if (result != null) {
                        setDialogState(() {
                          selectedProducts.add(result);
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Producto'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    decoration:
                        const InputDecoration(labelText: 'Notas (opcional)'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  if (selectedProducts.isNotEmpty)
                    Text(
                      'Total: ${_calculateTotal(selectedProducts).toStringAsFixed(2)}€',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: selectedProducts.isEmpty
                  ? null
                  : () async {
                      try {
                        // Convertir items a formato correcto
                        final items = selectedProducts.map((item) {
                          return {
                            'productId': item['productId'].toString(),
                            'quantity': int.parse(item['quantity'].toString()),
                            'price': double.parse(item['price'].toString()),
                          };
                        }).toList();

                        final body = {
                          'date': saleDate.toIso8601String(),
                          'items': items,
                          'notes': notesController.text.isNotEmpty
                              ? notesController.text
                              : null,
                        };

                        await _apiService.post(ApiConfig.sales, body);

                        if (mounted) {
                          Navigator.pop(context);
                          await _fetchData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Venta registrada')),
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

  Future<Map<String, dynamic>?> _showProductSelector(
      BuildContext context) async {
    dynamic selectedProductId;
    int quantity = 1;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Seleccionar Producto'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                DropdownButtonFormField<dynamic>(
                  value: selectedProductId,
                  decoration: InputDecoration(
                    labelText: 'Producto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                  ),
                  items: _products.map((product) {
                    final price = (product['price'] as num).toDouble();
                    final stock = (product['stockQuantity'] as num).toInt();
                    final productId = product['id'];
                    return DropdownMenuItem<dynamic>(
                      value: productId,
                      child: Text(
                          '${product['name']} - ${price.toStringAsFixed(2)}€ (Stock: $stock)'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedProductId = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    quantity = int.tryParse(value) ?? 1;
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: selectedProductId == null
                  ? null
                  : () {
                      try {
                        final product = _products.firstWhere(
                          (p) =>
                              p['id'].toString() ==
                              selectedProductId.toString(),
                        );
                        final price = (product['price'] as num).toDouble();
                        Navigator.pop(context, {
                          'productId': selectedProductId,
                          'quantity': quantity,
                          'price': price,
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotal(List<Map<String, dynamic>> items) {
    double total = 0;
    for (var item in items) {
      final price = (item['price'] as num).toDouble();
      final quantity = (item['quantity'] as num).toInt();
      total += price * quantity;
    }
    return total;
  }

  Future<void> _deleteSale(String saleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Venta'),
        content: const Text(
            '¿Estás seguro? El stock de los productos será restaurado.'),
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
        await _apiService.delete('${ApiConfig.sales}/$saleId');
        if (mounted) {
          await _fetchData();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Venta eliminada y stock restaurado')),
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
        title: const Text('Ventas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
                _fetchSales();
              }
            },
          ),
          if (_selectedDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _selectedDate = null;
                });
                _fetchSales();
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_selectedDate != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.blue[50],
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list, size: 16),
                        const SizedBox(width: 8),
                        Text(
                            'Filtrando por: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'),
                      ],
                    ),
                  ),
                Expanded(
                  child: _sales.isEmpty
                      ? const Center(child: Text('No hay ventas'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _sales.length,
                          itemBuilder: (context, index) {
                            final sale = _sales[index];
                            final date = DateTime.parse(sale['date']);
                            final items = sale['items'] as List;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ExpansionTile(
                                title: Text(DateFormat('dd/MM/yyyy HH:mm')
                                    .format(date)),
                                subtitle: Text('Total: ${sale['total']}€'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteSale(sale['id']),
                                ),
                                children: items.map((item) {
                                  return ListTile(
                                    dense: true,
                                    title: Text(item['product']['name']),
                                    subtitle:
                                        Text('Cantidad: ${item['quantity']}'),
                                    trailing: Text('${item['price']}€'),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewSaleDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
