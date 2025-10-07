import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistroView extends StatelessWidget {
  const RegistroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Nombre completo')),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Correo electrónico')),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'Contraseña'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/login'); // simula registro → login
              },
              child: const Text('Registrar'),
            ),
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
