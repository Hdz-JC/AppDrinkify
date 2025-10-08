import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:appdrinkify/controllers/auth_controller.dart';
import 'package:provider/provider.dart';


class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores para los campos de texto (opcional, por ahora sin lógica)
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final auth = Provider.of<AuthController>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView( // Para evitar overflow con el teclado
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person_rounded,
                size: 120,
              ),

              const SizedBox(height: 30),

              // Campo de nombre de usuario
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 20),

              // Campo de contraseña
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

              // Botón de iniciar sesión
              ElevatedButton(
                onPressed: () {
                  // Aquí luego conectaremos la lógica de autenticación
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 20),

              // Botón para regresar
              TextButton(
                onPressed: () {
                  context.go('/inicio');// Regresa a InicioApp
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
