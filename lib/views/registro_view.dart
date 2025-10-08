import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:appdrinkify/controllers/auth_controller.dart';

class RegistroView extends StatelessWidget {
  const RegistroView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores de los campos
    final TextEditingController nameController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final auth = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_add_rounded,
                size: 120,
              ),

              const SizedBox(height: 30),

              // Campo Nombre
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),

              const SizedBox(height: 20),

              // Campo Usuario
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 20),

              // Campo Contraseña
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),

              const SizedBox(height: 40),

              // Botón Registrar
              ElevatedButton(
                onPressed: () {
                  // Simula registro: cambia estado a logueado
                  auth.login(); // Esto activa el authController
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuario registrado con éxito!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Registrar',
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 20),

              // Botón Regresar
              TextButton(
                onPressed: () {
                  context.go('/inicio'); // Regresa a InicioApp
                },
                child: const Text(
                  'Regresar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

