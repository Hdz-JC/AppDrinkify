import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InicioApp extends StatelessWidget {
  const InicioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido a Drinkify',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Ícono principal de usuario/inicio de sesión
            const Icon(
              Icons.person_rounded,
              size: 150,
            ),

            const SizedBox(height: 50),

            // Botón de iniciar sesión
            ElevatedButton(
              onPressed: () {
                // Aquí luego agregaremos la navegación al Login
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 20),
              ),
            ),

            const SizedBox(height: 20),

            // Botón de registrarse
            ElevatedButton(
              onPressed: () {
                // Aquí luego agregaremos la navegación al Registro
                context.go('/registro');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Registrarse',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
