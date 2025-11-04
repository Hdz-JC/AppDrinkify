// lib/views/search_results_view.dart
import 'package:flutter/material.dart';
import 'package:appdrinkify/models/bebidas_model.dart'; // Revisa que este sea tu nombre correcto

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
                    bebida.imageUrl, // Esto usa la nueva ruta
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.no_photography, color: Colors.grey),
                  ),
                  title: Text(bebida.nombre),
                  
                  // --- MODIFICADO: Mostrar nombre de categoría ---
                  subtitle: Text(
                    // 'categoria_nombre' viene del JOIN en la BD
                    // Usamos '??' como un valor por defecto si fuera nulo
                    bebida.categoria_nombre ?? 'Sin categoría',
                    maxLines: 1,
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