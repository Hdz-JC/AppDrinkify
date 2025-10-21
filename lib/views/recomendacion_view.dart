//import 'package:appdrinkify/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:appdrinkify/controllers/navigation_controller.dart';

class RecomendacionView extends StatelessWidget{
  const RecomendacionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed:()=> NavigationController.navigateTo(context,'/home'),
            icon: const Icon(Icons.arrow_back),
          ),
        title: const Text('Ver recomendación del día'),
        centerTitle: true,
      ),
      body: Center(

      ),
      //bottomNavigationBar: const BottomNavBar(),
    );
  }
}