import 'package:appdrinkify/login.dart';
import 'package:appdrinkify/register.dart';
import 'package:flutter/material.dart';

class InicioApp extends StatelessWidget 
{
  const InicioApp({super.key});

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
              'Hola',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // Separacion entre widgets
            const SizedBox(height: 30),
            const Icon(
              Icons.person_rounded,
              size: 160,
            ),
            
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => login()),
              );
            },
              child: const Text(style: TextStyle(fontSize: 20),'Iniciar sesión'),
            ),
            
            const SizedBox(height: 30),
            
            ElevatedButton(
              onPressed:(){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => register()),
              );
            },
              child: const Text(style: TextStyle(fontSize: 20),'  Registrarse  '),
            ),
            const SizedBox(height: 190),
          ],
        ),
      ),
    );
  }
}