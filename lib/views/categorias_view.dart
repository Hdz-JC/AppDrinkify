import 'package:flutter/material.dart';
import 'package:appdrinkify/controllers/navigation_controller.dart';
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/bebidas_provider.dart';
import 'package:appdrinkify/views/bebidas_por_categoria_view.dart';
import 'package:appdrinkify/models/bebidas_model.dart';

class CategoriasView extends StatelessWidget{
  const CategoriasView({super.key});

  void _navegarACategoria(BuildContext context, String nombreCategoria) {
    final provider = context.read<BebidaProvider>();
    final List<Bebida> bebidasFiltradas = provider.getBebidasPorCategoria(nombreCategoria);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        leading: IconButton(
            onPressed:()=> NavigationController.navigateTo(context,'/home'),
            icon: const Icon(Icons.arrow_back),
          ),
        title: const Text('Explora distintas categorías'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
                  Column(
                    children: [
                      TextButton(
                        onPressed:() => _navegarACategoria(context, "Aguas frescas"),
                        child: Image.asset("assets/images/carrusel/frescas.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Aguas frescas", style: TextStyle(fontSize: 20)),
                      
                      TextButton(
                        onPressed:() => _navegarACategoria(context, "Calientes"),
                        child: Image.asset("assets/images/carrusel/calientes.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Calientes", style: TextStyle(fontSize: 20)),

                      TextButton(
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
                        onPressed:() => _navegarACategoria(context, "Jugos Clasicos"),
                        child: Image.asset("assets/images/carrusel/clasicos.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Jugos Clasicos", style: TextStyle(fontSize: 20)),

                      TextButton(
                        onPressed:() => _navegarACategoria(context, "Jugos fitness"),
                        child: Image.asset("assets/images/carrusel/fitness.jpg",
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,),
                      ),
                      const Text("Jugos fitness", style: TextStyle(fontSize: 20)),
                      
                      TextButton(
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