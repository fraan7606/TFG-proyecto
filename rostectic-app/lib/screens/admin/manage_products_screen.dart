import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../config/api_config.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    print('=== INICIANDO CARGA DE PRODUCTOS ===');
    if (mounted) {
      setState(() => _isLoading = true);
    }
    try {
      final response = await _apiService.get(ApiConfig.products);
      print('Response recibida: ${response.statusCode}');
      final data = _apiService.handleResponse(response);
      print('Data parseada: $data');
      final products =
          List<Map<String, dynamic>>.from(data['data']['products']);
      print('Productos cargados: ${products.length}');
      if (products.isNotEmpty) {
        print('Primer producto: ${products[0]}');
      }
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
        print('Estado actualizado con ${_products.length} productos');
      }
    } catch (e, stackTrace) {
      print('Error cargando productos: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando productos: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showProductDialog([Map<String, dynamic>? product]) async {
    final nameController = TextEditingController(text: product?['name'] ?? '');
    final descriptionController =
        TextEditingController(text: product?['description'] ?? '');
    final stockController = TextEditingController(
        text: product?['stockQuantity']?.toString() ?? '');
    final priceController =
        TextEditingController(text: product?['price']?.toString() ?? '');

    final isEditing = product != null;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Producto' : 'Nuevo Producto'),
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
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock *'),
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
                  stockController.text.isEmpty ||
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
                  'stockQuantity': int.parse(stockController.text),
                  'price': double.parse(priceController.text),
                };

                Map<String, dynamic>? createdProduct;
                if (isEditing) {
                  await _apiService.put(
                    '${ApiConfig.products}/${product['id']}',
                    body,
                    requiresAuth: true,
                  );
                } else {
                  try {
                    final response = await _apiService.post(
                      ApiConfig.products,
                      body,
                      requiresAuth:
                          true, // ESTE ERA EL PROBLEMA - faltaba requiresAuth
                    );
                    final data = _apiService.handleResponse(response);
                    print('Response data: $data');
                    createdProduct = data['data']['product'];
                    print('Producto creado: $createdProduct');
                  } catch (e) {
                    print('Error al crear producto: $e');
                    rethrow;
                  }
                }

                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing
                          ? 'Producto actualizado'
                          : 'Producto creado'),
                    ),
                  );

                  // Agregar producto a la lista localmente
                  if (createdProduct != null) {
                    try {
                      setState(() {
                        _products.add(createdProduct!);
                        print(
                            'Producto agregado a la lista. Total: ${_products.length}');
                      });
                    } catch (e) {
                      print('Error al agregar producto a la lista: $e');
                      // Si falla, recargar la lista completa
                      _fetchProducts();
                    }
                  } else if (isEditing) {
                    // Si es edición, recargar la lista completa
                    _fetchProducts();
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

  Future<void> _confirmDelete(Map<String, dynamic> product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: Text('¿Estás seguro de eliminar ${product['name']}?'),
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
        await _apiService.delete('${ApiConfig.products}/${product['id']}');
        if (mounted) {
          await _fetchProducts();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto eliminado')),
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
    print('BUILD: _isLoading=$_isLoading, productos=${_products.length}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Productos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text('No hay productos'))
              : RefreshIndicator(
                  onRefresh: _fetchProducts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      print('Renderizando producto $index: ${product['name']}');
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(product['name'] ?? 'Sin nombre'),
                          subtitle: Text(
                            'Stock: ${product['stockQuantity']} - ${product['price']}€\n${product['description'] ?? ''}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showProductDialog(product),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () => _confirmDelete(product),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
