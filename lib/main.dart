import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const AppAlmacenes());
}

class AppAlmacenes extends StatelessWidget {
  const AppAlmacenes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestión de Almacenes',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const LoginScreen(),
    );
  }
}