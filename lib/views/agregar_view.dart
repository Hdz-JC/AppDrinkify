import 'package:appdrinkify/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
class AgregarView extends StatelessWidget {
  const AgregarView({super.key});


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text('Ventana de Agregar')),
      body: const Center(child: Text('Ventana de Agregar')),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
