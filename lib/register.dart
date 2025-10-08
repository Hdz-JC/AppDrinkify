import 'package:flutter/material.dart';

class register extends StatelessWidget
{
  const register({super.key});

  void pruebadealgoxd(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nombre',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tu nombre',
              ),
            ),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Usuario',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tu usuario',
              ),
            ),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Contraseña',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tu contraseña',
              ),
            ),

            ElevatedButton(
              onPressed: pruebadealgoxd,
              child: const Text(style: TextStyle(fontSize: 20),'  Crear mi cuenta  '),
            ),
          ],
        ),
      ),
    );
  }
}