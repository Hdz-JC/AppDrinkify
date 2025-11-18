import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:appdrinkify/providers/auth_provider.dart';
import 'package:appdrinkify/providers/bebidas_provider.dart';
import 'package:provider/provider.dart';
import 'config/routes/app_router.dart'; // Mantengo tu ruta
import 'config/env.dart';

// --- IMPORTS AÑADIDOS ---
import 'package:appdrinkify/providers/favoritos_provider.dart';
import 'package:appdrinkify/config/datasource/sqlite_service.dart';
import 'package:appdrinkify/providers/listas_provider.dart'; // <-- AÑADIR ESTE
// --- FIN DE IMPORTS ---

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
  // Inicializar Supabase
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BebidaProvider()),

        // Provider de Favoritos (depende de Auth)
        ChangeNotifierProxyProvider<AuthProvider, FavoritosProvider>(
          create: (context) => FavoritosProvider(SqliteService.instance),
          update: (context, auth, previousFavoritos) {
            previousFavoritos!.updateUser(auth.currentUser?.id);
            return previousFavoritos;
          },
        ),

        // --- AÑADIR ESTE PROVIDER ---
        // Provider de Listas (también depende de Auth)
        ChangeNotifierProxyProvider<AuthProvider, ListasProvider>(
          create: (context) => ListasProvider(SqliteService.instance),
          update: (context, auth, previousListas) {
            // Llama al 'updateUser' de ListasProvider
            previousListas!.updateUser(auth.currentUser?.id);
            return previousListas;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Drinkify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}