import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import '../controllers/navigation_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final username = auth.currentUser?.username ?? 'Invitado';

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido, $username'),
        actions: [
          IconButton(
            onPressed: () {
              auth.logout();
              NavigationController.navigateTo(context, '/inicio');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text('Pantalla principal')),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
