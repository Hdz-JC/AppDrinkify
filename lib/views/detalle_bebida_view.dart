import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/favoritos_provider.dart';

class DetalleBebidaView extends StatelessWidget {
  final Bebida bebida;

  const DetalleBebidaView({
    super.key,
    required this.bebida,
  });

  @override
  Widget build(BuildContext context) {
    final favoritosProvider = context.watch<FavoritosProvider>();
    final bool esFav = (bebida.id != null)
        ? favoritosProvider.esFavorita(bebida.id!)
        : false;

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text(bebida.nombre),
        actions: [
          IconButton(
            icon: Icon(
              esFav ? Icons.favorite : Icons.favorite_border,
              color: esFav ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              context.read<FavoritosProvider>().toggleFavorito(bebida);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    bebida.imageUrl,
                    height: 250,
                    width: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        width: 250,
                        color: Colors.grey[200],
                        child: const Icon(Icons.no_photography, color: Colors.grey, size: 100,),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: Text(
                  bebida.categoria_nombre ?? 'Sin Categoría',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  "Instrucciones",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                bebida.preparacion,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
      ),
    );
  }
}