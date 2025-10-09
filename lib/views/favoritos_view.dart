import 'package:appdrinkify/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
class FavoritosView extends StatelessWidget {
  const FavoritosView({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Ventana de Favoritos')),
      body: const Center(child: Text('Ventana de Favoritos')),
       bottomNavigationBar: const BottomNavBar(),
    );
  }
}
