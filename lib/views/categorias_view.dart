import 'package:flutter/material.dart';
import 'package:appdrinkify/controllers/navigation_controller.dart';
// --- AÑADIR IMPORTS ---
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/bebidas_provider.dart';
import 'package:appdrinkify/views/bebidas_por_categoria_view.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
// --- FIN IMPORTS ---

class CategoriasView extends StatelessWidget{
  const CategoriasView({super.key});

  // --- AÑADIR ESTA FUNCIÓN HELPER ---
  void _navegarACategoria(BuildContext context, String nombreCategoria) {
    // 1. Obtener el provider (solo para leer, no escuchar)
    final provider = context.read<BebidaProvider>();
    
    // 2. Usar el nuevo método para filtrar las bebidas
    final List<Bebida> bebidasFiltradas = provider.getBebidasPorCategoria(nombreCategoria);

    // 3. Navegar a la nueva vista de lista
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BebidasPorCategoriaView(
          bebidas: bebidasFiltradas,
          categoriaNombre: nombreCategoria,
        ),
      ),
    );
  }
  // --- FIN FUNCIÓN HELPER ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed:()=> NavigationController.navigateTo(context,'/home'),
            icon: const Icon(Icons.arrow_back),
          ),
        title: const Text('Explora distintas categorías'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView( // <-- Añadido para evitar overflow
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                //children: [
                  Column(
                    children: [
                      TextButton(
                        // --- MODIFICADO ---
                        onPressed:() => _navegarACategoria(context, "Aguas frescas"),
                        child: Image.asset("assets/images/carrusel/frescas.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Aguas frescas", style: TextStyle(fontSize: 20)),
                      
                      TextButton(
                        // --- MODIFICADO ---
                        onPressed:() => _navegarACategoria(context, "Calientes"),
                        child: Image.asset("assets/images/carrusel/calientes.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Calientes", style: TextStyle(fontSize: 20)),

                      TextButton(
                        // --- MODIFICADO ---
                        onPressed:() => _navegarACategoria(context, "Con alcohol"),
                        child: Image.asset("assets/images/carrusel/alcohol.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Con alcohol", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(
                        // --- MODIFICADO ---
                        onPressed:() => _navegarACategoria(context, "Jugos Clasicos"),
                        child: Image.asset("assets/images/carrusel/clasicos.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Jugos Clasicos", style: TextStyle(fontSize: 20)),

                      TextButton(
                        // --- MODIFICADO ---
                        onPressed:() => _navegarACategoria(context, "Jugos fitness"),
                        child: Image.asset("assets/images/carrusel/fitness.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Jugos fitness", style: TextStyle(fontSize: 20)),
                      
                      TextButton(
                        // --- MODIFICADO ---
                        onPressed:() => _navegarACategoria(context, "Batidos"),
                        child: Image.asset("assets/images/carrusel/batidos.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,
                        ),
                      ),
                      const Text("Batidos", 
                      style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                //],
              //),
            ],
          ),
        ),
      ),
    );
  }
}