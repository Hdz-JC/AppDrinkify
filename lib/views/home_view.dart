import 'package:appdrinkify/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventana de Home'),
        actions: [
          IconButton(
            onPressed:()=> NavigationController.navigateTo(context,'/inicio'), // cerrar sesión → redirige automáticamente
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text('Bienvenido a Home')),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
//import 'package:go_router/go_router.dart';
//import 'package:provider/provider.dart';
//import '../controllers/auth_controller.dart';
    //final auth = Provider.of<AuthController>(context, listen: false);