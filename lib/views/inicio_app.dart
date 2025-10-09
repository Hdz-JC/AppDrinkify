import 'package:appdrinkify/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';

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

            const Icon(
              Icons.person_rounded,
              size: 150,
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                NavigationController.navigateTo(context, '/login');
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

            ElevatedButton(
              onPressed: () {
                NavigationController.navigateTo(context, '/registro');
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
