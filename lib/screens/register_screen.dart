import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'almacenes_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nombreCtrl = TextEditingController();
  final dniCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final cifCtrl = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    setState(() => loading = true);

    try {
      await ApiService.register(
        nombre: nombreCtrl.text,
        dni: dniCtrl.text,
        email: emailCtrl.text,
        password: passwordCtrl.text,
        cif: cifCtrl.text,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AlmacenesScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Center(
        child: SizedBox(
          width: 420,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
                  TextField(controller: dniCtrl, decoration: const InputDecoration(labelText: 'DNI')),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                  TextField(controller: passwordCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña')),
                  TextField(controller: cifCtrl, decoration: const InputDecoration(labelText: 'CIF Empresa')),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: loading ? null : register,
                    child: Text(loading ? 'Registrando...' : 'Registrarme'),
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