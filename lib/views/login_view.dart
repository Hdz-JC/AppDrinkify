import 'package:appdrinkify/views/inicio_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/navigation_controller.dart';
import '../models/user_model.dart';
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
      final messenger = ScaffoldMessenger.of(context);

      if (email.isEmpty || password.isEmpty) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          const SnackBar(content: Text('Todos los campos son obligatorios')),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      try {
        
        await authProvider.login(email, password);
        UserModel ? user = authProvider.currentUser;

        if (user != null) {
          messenger.clearSnackBars();
          messenger.showSnackBar(
            const SnackBar(content: Text('Login exitoso!')),
          );
          _clearFields();
          NavigationController.navigateTo(context, '/home');
        } else {
                    messenger.clearSnackBars();
          messenger.showSnackBar(
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
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo/drinkifyblanco.png",
              height: 220,
            ),
              const SizedBox(height: 30),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Color.fromRGBO(251, 83, 21, 1),
                ),
                child: const Text('Iniciar sesión', style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  )
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed:() => Navigator.push(context,MaterialPageRoute(builder: (context) => InicioApp()),
                ),
                child: const Text('Regresar', style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0)
                )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
