// lib/views/search_results_view.dart
import 'package:flutter/material.dart';
import 'package:appdrinkify/models/bebidas_model.dart';

class SearchResultsView extends StatelessWidget {
  final List<Bebida> resultados;
  final String query;

  const SearchResultsView({
    Key? key,
    required this.resultados,
    required this.query,
  }) : super(key: key);

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
                  // --- Carga la imagen desde los ASSETS locales ---
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    // Opcional: Navegar a una pantalla de detalle de la bebida
                  },
                );
              },
            ),
    );
  }
}