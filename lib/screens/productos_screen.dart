import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'producto_form_screen.dart';

class ProductosScreen extends StatefulWidget {
  final int idAlmacen;
  final String nombreAlmacen;

  const ProductosScreen({
    super.key,
    required this.idAlmacen,
    required this.nombreAlmacen,
  });

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  List productos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    try {
      final data = await ApiService.getProductos(widget.idAlmacen);
      setState(() {
        productos = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> editar(Map producto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductoFormScreen(
          idAlmacen: widget.idAlmacen,
          producto: producto,
        ),
      ),
    );

    cargarProductos();
  }

  Future<void> borrar(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: const Text(
          '¿Seguro que quieres eliminar este producto? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await ApiService.borrarProducto(id);
      cargarProductos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos - ${widget.nombreAlmacen}'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductoFormScreen(
                idAlmacen: widget.idAlmacen,
              ),
            ),
          );
          cargarProductos();
        },
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : productos.isEmpty
              ? const Center(child: Text('No hay productos'))
              : ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final p = productos[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(p['nombre']),
                        subtitle: Text(
                          'Cantidad: ${p['cantidad']} | Precio: ${p['precio']}€ | Stock mín: ${p['stock_minimo']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => editar(p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => borrar(p['id_producto']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}