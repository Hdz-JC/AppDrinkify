import 'package:appdrinkify/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
//import '../config/datasource/sqlite_service.dart';
import '../config/datasource/supabase_service.dart';


class RegistroView extends StatelessWidget {
  const RegistroView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores de los campos
    final TextEditingController emailController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final SupabaseService supabaseService = SupabaseService();

    void clearFields() {
        emailController.clear();
        usernameController.clear();
        passwordController.clear();
      }

    //Inicio
    Future<void> register() async {
      final email = emailController.text.trim();
      final username = usernameController.text.trim();
      final password = passwordController.text;

      // 1. Validar Email
      // Permite letras, números, y ._%+- antes del @
      // Permite letras, números, y .- después del @
      // Exige un dominio de 2+ letras (ej. .com)
      final emailRegex =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, ingresa un correo válido')),
        );
        return;
      }

      // 2. Validar Usuario
      // Debe empezar con letra
      // Puede contener letras, números, _ o -
      // Longitud total entre 3 y 20 caracteres
      final userRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9_-]{2,19}$');
      if (!userRegex.hasMatch(username)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Usuario inválido (3-20 caracteres, debe empezar con letra)')),
        );
        return;
      }

      // 3. Validar Contraseña
      // Acepta cualquier carácter
      // Longitud mínima de 8 caracteres
      final passRegex = RegExp(r'^.{8,}$');
      if (!passRegex.hasMatch(password)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('La contraseña debe tener al menos 8 caracteres')),
        );
        return;
      }

      final user = UserModel(
        email: email,
        username: username,
        password: password,
      );

      try {
        final success = await supabaseService.registerUser(user);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario registrado con éxito!')),
          );
          clearFields();
          NavigationController.navigateTo(context, '/inicio');
        } else if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Este email ya está registrado')),
          );
          clearFields();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al registrar en Supabase')),
          );
          clearFields();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        clearFields();
      }
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      /*appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: const Text('Registro de Usuario'),
        centerTitle: true,
      ),*/
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //const Icon(Icons.person_add_rounded, size: 120),
              Image.asset("assets/logo/drinkifyblanco.png",
              height: 220,
            ),
              const SizedBox(height: 30),

              // Campo Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 20),

              // Campo Usuario
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 20),

              // Campo Contraseña
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

              // Botón Registrar
              ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Color.fromRGBO(251, 83, 21, 1),
                ),
                child: const Text('Registrar', style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                )
                ),
              ),
              const SizedBox(height: 20),

              // Botón Regresar
              TextButton(
                onPressed: () => NavigationController.navigateTo(context, '/inicio'),
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

