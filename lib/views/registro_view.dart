import 'package:appdrinkify/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/sqlite_service.dart';
import '../services/supabase_service.dart';


class RegistroView extends StatelessWidget {
  const RegistroView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores de los campos
    final TextEditingController emailController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final SupabaseService supabaseService = SupabaseService();

    //Inicio
     Future<void> _register() async {
      final email = emailController.text.trim();
      final username = usernameController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todos los campos son obligatorios')),
        );
        return;
      }

      final user = UserModel(
        email: email,
        username: username,
        password: password,
      );

      try {
        // Guardar en SQLite (offline)
        await SQLiteService.insertUser(user);

        // Guardar en Supabase (online)
        final success = await supabaseService.registerUser(user);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario registrado con éxito!')),
          );
          NavigationController.navigateTo(context, '/inicio');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al registrar en Supabase')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    //Fin

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
              const Icon(Icons.person_add_rounded, size: 120),
              const SizedBox(height: 30),

              // Campo Email
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
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
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Registrar', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),

              // Botón Regresar
              TextButton(
                onPressed: () => NavigationController.navigateTo(context, '/inicio'),
                child: const Text('Regresar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

