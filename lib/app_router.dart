import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'controllers/auth_controller.dart';
import 'views/inicio_app.dart';
import 'views/login_view.dart';
import 'views/registro_view.dart';
import 'views/home_view.dart';
import 'views/favoritos_view.dart';
import 'views/agregar_view.dart';
import 'views/listas_view.dart';

GoRouter createRouter(AuthController authController) {
  return GoRouter(
    initialLocation: '/inicio',
    //refreshListenable: authController, // escucha cambios en auth
    redirect: (context, state) {
      //final isLoggedIn = authController.isLoggedIn;
      //final location = state.uri.path;

      //const protected = ['/home', '/favoritos', '/agregar', '/listas'];

      // Si no está logueado y quiere entrar a zonas protegidas → /login
     // if (!isLoggedIn && protected.contains(location)) {
     //   return '/login';
     // }

      // Si ya está logueado y está en /login o /registro → /home
      //   if (isLoggedIn && (location == '/login' || location == '/registro')) {
     //   return '/home';
    //  }

      return null;
    },
    routes: [
      GoRoute(path: '/inicio', builder: (context, state) => const InicioApp()),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      GoRoute(path: '/registro', builder: (context, state) => const RegistroView()),
      GoRoute(path: '/home', builder: (context, state) => const HomeView()),
      GoRoute(path: '/favoritos', builder: (context, state) => const FavoritosView()),
      GoRoute(path: '/agregar', builder: (context, state) => const AgregarView()),
      GoRoute(path: '/listas', builder: (context, state) => const ListasView()),
    ],
  );
}
