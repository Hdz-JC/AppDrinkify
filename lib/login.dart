import 'package:flutter/material.dart';

class login extends StatelessWidget 
{
  const login({super.key});

  // hay que usar las funciones para mandar a otra pantalla
  // con el onPressed we, una funcion para cada boton 
  void pruebadealgoxd (){

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Inicia sesión',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // Separacion entre widgets
            const SizedBox(height: 30),
            const Icon(
              Icons.person,
              size: 260,
            ),
          ],
        ),
      ),
    );
  }
}