import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EmpresaScreen extends StatefulWidget {
  const EmpresaScreen({super.key});

  @override
  State<EmpresaScreen> createState() => _RegisterEmpresaScreenState();
}

class _RegisterEmpresaScreenState extends State<EmpresaScreen> {
  final nombreCtrl = TextEditingController();
  final cifCtrl = TextEditingController();
  final direccionCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  bool loading = false;

  Future<void> registrarEmpresa() async {
    setState(() => loading = true);

    try {
      await ApiService.registrarEmpresa(
        nombre: nombreCtrl.text,
        cif: cifCtrl.text,
        direccion: direccionCtrl.text,
        telefono: telefonoCtrl.text,
        email: emailCtrl.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Empresa registrada correctamente')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar empresa'),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Crear empresa',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre de la empresa'),
                  ),

                  TextField(
                    controller: cifCtrl,
                    decoration: const InputDecoration(labelText: 'CIF'),
                  ),

                  TextField(
                    controller: direccionCtrl,
                    decoration: const InputDecoration(labelText: 'Dirección'),
                  ),

                  TextField(
                    controller: telefonoCtrl,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                  ),

                  TextField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email de la empresa'),
                  ),

                  const SizedBox(height: 20),

                  FilledButton(
                    onPressed: loading ? null : registrarEmpresa,
                    child: Text(loading ? 'Registrando...' : 'Registrar empresa'),
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