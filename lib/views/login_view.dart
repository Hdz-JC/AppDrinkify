import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/navigation_controller.dart';
import '../models/user_model.dart';
//import '../config/datasource/sqlite_service.dart';
import '../providers/auth_provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void _clearFields() {
      emailController.clear();
      passwordController.clear();
    }

    Future<void> _login() async {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Todos los campos son obligatorios')),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        
        await authProvider.login(email, password);
        UserModel ? user = authProvider.currentUser;

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login exitoso!')),
          );
          _clearFields();
          NavigationController.navigateTo(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email o contraseña incorrectos')),
          );
          _clearFields();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en login: $e')),
        );
        _clearFields();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_rounded, size: 120),
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

              // Botón Entrar
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Entrar', style: TextStyle(fontSize: 18)),
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
