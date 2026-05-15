import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CrearAlmacenScreen extends StatefulWidget {
  final Map? almacen;

  const CrearAlmacenScreen({
    super.key,
    this.almacen,
  });

  @override
  State<CrearAlmacenScreen> createState() => _CrearAlmacenScreenState();
}

class _CrearAlmacenScreenState extends State<CrearAlmacenScreen> {
  final direccionCtrl = TextEditingController();
  final provinciaCtrl = TextEditingController();
  final paisCtrl = TextEditingController();

  bool loading = false;

  bool get esEdicion => widget.almacen != null;

  @override
  void initState() {
    super.initState();

    if (esEdicion) {
      direccionCtrl.text = widget.almacen!['direccion'] ?? '';
      provinciaCtrl.text = widget.almacen!['provincia'] ?? '';
      paisCtrl.text = widget.almacen!['pais'] ?? '';
    }
  }

  Future<void> guardar() async {
    setState(() => loading = true);

    try {
      if (esEdicion) {
        await ApiService.editarAlmacen(
          idAlmacen: widget.almacen!['id_almacen'],
          direccion: direccionCtrl.text,
          provincia: provinciaCtrl.text,
          pais: paisCtrl.text,
        );
      } else {
        await ApiService.crearAlmacen(
          direccion: direccionCtrl.text,
          provincia: provinciaCtrl.text,
          pais: paisCtrl.text,
        );
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    direccionCtrl.dispose();
    provinciaCtrl.dispose();
    paisCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar almacén' : 'Crear almacén'),
      ),
      body: Center(
        child: SizedBox(
          width: 420,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: direccionCtrl,
                    decoration: const InputDecoration(labelText: 'Dirección'),
                  ),
                  TextField(
                    controller: provinciaCtrl,
                    decoration: const InputDecoration(labelText: 'Provincia'),
                  ),
                  TextField(
                    controller: paisCtrl,
                    decoration: const InputDecoration(labelText: 'País'),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: loading ? null : guardar,
                    child: Text(
                      loading
                          ? 'Guardando...'
                          : esEdicion
                              ? 'Actualizar'
                              : 'Guardar',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}