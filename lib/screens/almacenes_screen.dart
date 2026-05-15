import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'crear_almacen_screen.dart';
import 'productos_screen.dart';

class AlmacenesScreen extends StatefulWidget {
  const AlmacenesScreen({super.key});

  @override
  State<AlmacenesScreen> createState() => _AlmacenesScreenState();
}

class _AlmacenesScreenState extends State<AlmacenesScreen> {
  List almacenes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarAlmacenes();
  }

  Future<void> cargarAlmacenes() async {
    try {
      final data = await ApiService.getAlmacenes();
      setState(() {
        almacenes = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> borrarAlmacen(int idAlmacen) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar almacén'),
        content: const Text(
          '¿Seguro que quieres eliminar este almacén? Esta acción no se puede deshacer.',
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
      await ApiService.borrarAlmacen(idAlmacen);
      cargarAlmacenes();
    }
  }

  void editarAlmacen(Map almacen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrearAlmacenScreen(
          almacen: almacen,
        ),
      ),
    );

    cargarAlmacenes();
  }

  void verProductos(Map almacen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductosScreen(
          idAlmacen: almacen['id_almacen'],
          nombreAlmacen: almacen['direccion'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis almacenes'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CrearAlmacenScreen(),
            ),
          );
          cargarAlmacenes();
        },
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : almacenes.isEmpty
              ? const Center(child: Text('No hay almacenes'))
              : ListView.builder(
                  itemCount: almacenes.length,
                  itemBuilder: (context, index) {
                    final a = almacenes[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(a['direccion']),
                        subtitle: Text('${a['provincia']} - ${a['pais']}'),
                        onTap: () => verProductos(a),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => editarAlmacen(a),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  borrarAlmacen(a['id_almacen']),
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