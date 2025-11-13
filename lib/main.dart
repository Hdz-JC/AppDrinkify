import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:appdrinkify/providers/auth_provider.dart';
import 'package:appdrinkify/providers/bebidas_provider.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'config/env.dart';

// --- AÑADIR ESTOS IMPORTS ---
import 'package:appdrinkify/providers/favoritos_provider.dart';
import 'package:appdrinkify/config/datasource/sqlite_service.dart';
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

        // --- AÑADIR ESTE PROVIDER ---
        // Este es un "ProxyProvider". Escucha los cambios en AuthProvider
        // y se los pasa a FavoritosProvider.
        ChangeNotifierProxyProvider<AuthProvider, FavoritosProvider>(
          
          // 1. Crea la instancia inicial, pasándole el servicio de BD
          create: (context) => FavoritosProvider(SqliteService.instance),
          
          // 2. Esta función se ejecuta CADA VEZ que AuthProvider cambia
          update: (context, auth, previousFavoritos) {
            // 'auth' es el AuthProvider
            // 'previousFavoritos' es el FavoritosProvider que ya existe
            
            // Llama al método 'updateUser' que creamos en FavoritosProvider
            // pasándole el ID del usuario actual (o null si cerró sesión)
            previousFavoritos!.updateUser(auth.currentUser?.id);
            
            return previousFavoritos;
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