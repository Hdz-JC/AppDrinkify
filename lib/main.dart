import 'package:flutter/material.dart';
import 'app_router.dart';

void main() {
  runApp(const MyApp());
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

//import 'package:provider/provider.dart';
//import 'controllers/auth_controller.dart';