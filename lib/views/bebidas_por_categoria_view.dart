// lib/views/bebidas_por_categoria_view.dart
import 'package:flutter/material.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/views/detalle_bebida_view.dart'; // <-- AÑADE ESTA LÍNEA

class BebidasPorCategoriaView extends StatelessWidget {
  final List<Bebida> bebidas;
  final String categoriaNombre;

  const BebidasPorCategoriaView({
    super.key,
    required this.bebidas,
    required this.categoriaNombre,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoriaNombre),
      ),
      body: bebidas.isEmpty
          ? const Center(
              child: Text("No hay bebidas en esta categoría."),
            )
          : ListView.builder(
              itemCount: bebidas.length,
              itemBuilder: (context, index) {
                final bebida = bebidas[index];

                return ListTile(
                  leading: Image.asset(
                    bebida.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.no_photography, color: Colors.grey),
                  ),
                  title: Text(bebida.nombre),
                  subtitle: Text(
                    //Icon(Icons.favorite)
                    //const Icon(Icons.logout),
                    bebida.descripcion, 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite_border), // Corazón sin rellenar
                    color: Colors.grey, // Color gris
                    onPressed: () {
                      // Aquí irá la lógica para guardar el favorito
                      print("Le diste fav a ${bebida.nombre}");
                    },
                  ),
                  onTap: () {
                    // 1. Navega a la pantalla de detalle
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // 2. Construye la pantalla y le pasa la 'bebida'
                        //    a la que le hicieron tap
                        builder: (context) => DetalleBebidaView(bebida: bebida),
                        ),
                      );
                    },
                );
              },
            ),
    );
  }
}