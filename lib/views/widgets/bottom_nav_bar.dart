import 'package:appdrinkify/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  int _getCurrentIndex(String location) {
    if (location.startsWith('/favoritos')) return 1;
    if (location.startsWith('/agregar')) return 2;
    if (location.startsWith('/listas')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(location),
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            NavigationController.navigateTo(context,'/home');
            break;
          case 1:
           NavigationController.navigateTo(context,'/favoritos');
            break;
          case 2:
            NavigationController.navigateTo(context,'/agregar');
            break;
          case 3:
            NavigationController.navigateTo(context,'/listas');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Agregar'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Listas'),
      ],
    );
  }
}
