import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:appdrinkify/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await Supabase.initialize(
    url: 'https://tbgdjgohrllhrcmwigkv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRiZ2RqZ29ocmxsaHJjbXdpZ2t2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA1Mzg4MjIsImV4cCI6MjA3NjExNDgyMn0.V6rI0L7fOw8fMB3dFT1S4dkn-nMj0v45tXk3nncoT8g',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    )
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
