import 'package:appdrinkify/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class ListasView extends StatelessWidget {
  const ListasView({super.key});


  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(title: const Text('Ventana de Listas')),
      body: const Center(child: Text('Ventana de Listas')),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
