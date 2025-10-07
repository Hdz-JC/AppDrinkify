import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'controllers/auth_controller.dart';
import 'views/home_view.dart';
import 'views/favoritos_view.dart';
import 'views/agregar_view.dart';
import 'views/listas_view.dart';
import 'views/login_view.dart';
import 'views/registro_view.dart';

GoRouter createRouter(AuthController authController) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: authController,
    redirect: (context, state) {
      final loggedIn = authController.isLoggedIn;
      final location = state.uri.toString(); // reemplazo de 'subloc'
      final loggingIn = location == '/login' || location == '/registro';

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/home';
      return null; // no hacer nada
    },
    routes: [
      // Rutas públicas (login y registro)
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      GoRoute(path: '/registro', builder: (context, state) => const RegistroView()),

      // Rutas privadas (pantallas con barra inferior)
      GoRoute(path: '/home', builder: (context, state) => const HomeView()),
      GoRoute(path: '/favoritos', builder: (context, state) => const FavoritosView()),
      GoRoute(path: '/agregar', builder: (context, state) => const AgregarView()),
      GoRoute(path: '/listas', builder: (context, state) => const ListasView()),
    ],
  );
}
