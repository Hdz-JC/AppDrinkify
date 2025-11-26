import 'package:flutter/material.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/views/detalle_bebida_view.dart';
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/favoritos_provider.dart';

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
    final favoritosProvider = context.watch<FavoritosProvider>();

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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

                // --- AÑADIDO ---
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
                    bebida.descripcion, 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // --- MODIFICADO: EL ICONO DE FAVORITO ---
                  trailing: IconButton(
                    icon: Icon(
                      esFav ? Icons.favorite : Icons.favorite_border,
                    ),
                    color: esFav ? Colors.red : Colors.grey,
                    onPressed: () {
                      // Llama al provider
                      context.read<FavoritosProvider>().toggleFavorito(bebida);
                    },
                  ),
                  // --- FIN DE MODIFICACIÓN ---

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