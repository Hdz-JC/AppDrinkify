import 'package:flutter/material.dart';
import 'package:appdrinkify/inicio_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
	debugShowCheckedModeBanner: false,
        theme: ThemeData(
	   useMaterial3: true,
	   colorSchemeSeed: const Color.fromARGB(255, 0, 0, 0)
      ),
      home: const InicioApp()
    );
  }
}