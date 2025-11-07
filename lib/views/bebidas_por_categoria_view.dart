// lib/views/bebidas_por_categoria_view.dart
import 'package:flutter/material.dart';
import 'package:appdrinkify/models/bebidas_model.dart';

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
                    bebida.descripcion, 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                  },
                );
              },
            ),
    );
  }
}