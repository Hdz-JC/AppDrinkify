import 'package:flutter/material.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/views/detalle_bebida_view.dart';
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/favoritos_provider.dart';

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

                  trailing: IconButton(
                    icon: Icon(
                      esFav ? Icons.favorite : Icons.favorite_border,
                      color: esFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {

                      context.read<FavoritosProvider>().toggleFavorito(bebida);
                    },
                  ),

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