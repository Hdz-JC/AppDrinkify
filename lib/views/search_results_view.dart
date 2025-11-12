// lib/views/search_results_view.dart
import 'package:flutter/material.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/views/detalle_bebida_view.dart'; // <-- AÑADE ESTA LÍNEA

class SearchResultsView extends StatelessWidget {
  final List<Bebida> resultados;
  final String query;

  const SearchResultsView({
    super.key, 
    required this.resultados,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultados para '$query'"),
      ),
      body: resultados.isEmpty
          ? const Center(
              child: Text("No se encontraron bebidas."),
            )
          : ListView.builder(
              itemCount: resultados.length,
              itemBuilder: (context, index) {
                final bebida = resultados[index];

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
                    bebida.categoria_nombre ?? 'Sin categoría',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // Le pasa la 'bebida' de la lista de resultados
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