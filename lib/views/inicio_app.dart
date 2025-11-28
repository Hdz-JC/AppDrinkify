import 'package:appdrinkify/views/login_view.dart';
import 'package:appdrinkify/views/registro_view.dart';
import 'package:flutter/material.dart';

class InicioApp extends StatelessWidget {
  const InicioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo/drinkifyblanco.png",
              height: 320,
            ),

            const SizedBox(height: 50),

            ElevatedButton(
                onPressed:() => Navigator.push(context,MaterialPageRoute(builder: (context) => LoginView()),
                ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Color.fromRGBO(251, 83, 21, 1),
              ),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
                
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
                onPressed:() => Navigator.push(context,MaterialPageRoute(builder: (context) => RegistroView()),
                ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: const Text(
                'Registrarse',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
