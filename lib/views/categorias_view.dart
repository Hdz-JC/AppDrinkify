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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      TextButton(
                        // --- MODIFICADO ---
                        onPressed:() => _navegarACategoria(context, "Aguas frescas"),
                        child: Image.network("https://www.gob.mx/cms/uploads/article/main_image/24844/aguas.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Aguas frescas", style: TextStyle(fontSize: 20)),
                      
                      TextButton(
                        // --- MODIFICADO ---
                        onPressed:() => _navegarACategoria(context, "Calientes"),
                        child: Image.network("https://lucavending.net/wp-content/uploads/2021/06/bebidas-calientes.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Calientes", style: TextStyle(fontSize: 20)),

                      TextButton(
                        // --- MODIFICADO ---
                        onPressed:() => _navegarACategoria(context, "Con alcohol"),
                        child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS14sRbtoDJIDz3SJ2t1vZ19R5LJhXpSSQIAA&s",
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
                        child: Image.network("https.amazonaws.com/takami.co/thumbnails/productimage/75399ce2ab6242d8a683d822963e874c/nmj5mo4az3ka7gbkp4ufge_1280_800.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Jugos Clasicos", style: TextStyle(fontSize: 20)),

                      TextButton(
                        // --- MODIFICADO ---
                        onPressed:() => _navegarACategoria(context, "Jugos fitness"),
                        child: Image.network("https://media.gq.com.mx/photos/61e83673f4e647708c8d6205/16:9/w_2992,h_1683,c_limit/diaet-shakes-abnehm-trend-abnehmen-gesundheit-fitness-aufm.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Jugos fitness", style: TextStyle(fontSize: 20)),
                      
                      TextButton(
                        // --- MODIFICADO ---
                        onPressed:() => _navegarACategoria(context, "Batidos"),
                        child: Image.network("httpss2.abcstatics.com/media/bienestar/2020/07/04/batidos-saludables-kdhH--1248x698@abc.jpeg",
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}