import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventana de Home'),
        actions: [
          IconButton(
            onPressed: auth.logout, // cerrar sesión → redirige automáticamente
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text('Bienvenido a Home')),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
