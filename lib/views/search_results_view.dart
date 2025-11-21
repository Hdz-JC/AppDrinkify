// lib/views/search_results_view.dart
import 'package:flutter/material.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/views/detalle_bebida_view.dart';
// --- AÑADIR ESTOS IMPORTS ---
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/favoritos_provider.dart';
// --- FIN IMPORTS ---

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
    // --- AÑADIDO ---
    // Usamos 'watch' para que los iconos se redibujen solos
    // cuando la lista de favoritos cambie.
    final favoritosProvider = context.watch<FavoritosProvider>();

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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

                // --- AÑADIDO ---
                // Revisa el estado de ESTA bebida
                final bool esFav = favoritosProvider.esFavorita(bebida.id!);

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

                  // --- AÑADIDO: EL ICONO DE FAVORITO ---
                  trailing: IconButton(
                    icon: Icon(
                      // Icono condicional
                      esFav ? Icons.favorite : Icons.favorite_border,
                      // Color condicional
                      color: esFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      // Llama al provider para añadir/quitar
                      // Usamos 'read' dentro de un callback
                      context.read<FavoritosProvider>().toggleFavorito(bebida);
                    },
                  ),
                  // --- FIN DE AÑADIDO ---

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
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