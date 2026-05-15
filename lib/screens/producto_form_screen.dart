import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProductoFormScreen extends StatefulWidget {
  final int idAlmacen;
  final Map? producto;

  const ProductoFormScreen({
    super.key,
    required this.idAlmacen,
    this.producto,
  });

  @override
  State<ProductoFormScreen> createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final nombreCtrl = TextEditingController();
  final cantidadCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final codigoCtrl = TextEditingController();

  bool loading = false;

  bool get esEdicion => widget.producto != null;

  @override
  void initState() {
    super.initState();

    if (esEdicion) {
      nombreCtrl.text = widget.producto!['nombre']?.toString() ?? '';
      cantidadCtrl.text = widget.producto!['cantidad']?.toString() ?? '';
      precioCtrl.text = widget.producto!['precio']?.toString() ?? '';
      stockCtrl.text = widget.producto!['stock_minimo']?.toString() ?? '';
      codigoCtrl.text = widget.producto!['codigo_barras']?.toString() ?? '';
    }
  }

  Future<void> guardar() async {
    setState(() => loading = true);

    try {
      if (esEdicion) {
        await ApiService.editarProducto(
          idProducto: widget.producto!['id_producto'],
          nombre: nombreCtrl.text,
          cantidad: int.parse(cantidadCtrl.text),
          precio: double.parse(precioCtrl.text),
          stockMinimo: int.parse(stockCtrl.text),
          codigoBarras: codigoCtrl.text,
        );
      } else {
        await ApiService.crearProducto(
          idAlmacen: widget.idAlmacen,
          nombre: nombreCtrl.text,
          cantidad: int.parse(cantidadCtrl.text),
          precio: double.parse(precioCtrl.text),
          stockMinimo: int.parse(stockCtrl.text),
          codigoBarras: codigoCtrl.text,
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
    nombreCtrl.dispose();
    cantidadCtrl.dispose();
    precioCtrl.dispose();
    stockCtrl.dispose();
    codigoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar producto' : 'Crear producto'),
      ),
      body: Center(
        child: SizedBox(
          width: 430,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: cantidadCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                  ),
                  TextField(
                    controller: precioCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Precio'),
                  ),
                  TextField(
                    controller: stockCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Stock mínimo'),
                  ),
                  TextField(
                    controller: codigoCtrl,
                    decoration: const InputDecoration(labelText: 'Código barras'),
                  ),
                  const SizedBox(height: 20),
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