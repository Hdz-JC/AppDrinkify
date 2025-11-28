import 'package:go_router/go_router.dart';
import '../../views/inicio_app.dart';
import '../../views/login_view.dart';
import '../../views/registro_view.dart';
import '../../views/home_view.dart';
import '../../views/favoritos_view.dart';
import '../../views/agregar_view.dart';
import '../../views/listas_view.dart';
import '../../views/categorias_view.dart';
import '../../views/recomendacion_view.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/inicio',
    routes: [
      GoRoute(path: '/inicio', builder: (context, state) => const InicioApp()),
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      GoRoute(path: '/registro', builder: (context, state) => const RegistroView()),
      GoRoute(path: '/home', builder: (context, state) => const HomeView()),
      GoRoute(path: '/favoritos', builder: (context, state) => const FavoritosView()),
      GoRoute(path: '/agregar', builder: (context, state) => const AgregarView()),
      GoRoute(path: '/listas', builder: (context, state) => const ListasView()),
      GoRoute(path: '/categorias', builder: (context, state) => const CategoriasView()),
      GoRoute(path: '/recomendacion', builder: (context, state) => const RecomendacionView()),
    ],
  );
}


