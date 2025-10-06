import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'views/home_view.dart';
import 'views/favoritos_view.dart';
import 'views/agregar_view.dart';
import 'views/listas_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/home', builder: (context, state) => const HomeView()),
    GoRoute(path: '/favoritos', builder: (context, state) => const FavoritosView()),
    GoRoute(path: '/agregar', builder: (context, state) => const AgregarView()),
    GoRoute(path: '/listas', builder: (context, state) => const ListasView()),
  ],
);
