import 'package:appdrinkify/views/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/favoritos_provider.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/views/detalle_bebida_view.dart';

class FavoritosView extends StatelessWidget {
  const FavoritosView({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritosProvider = context.watch<FavoritosProvider>();
    final List<Bebida> listaFavoritos = favoritosProvider.favoritos;

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: const Text('Mis Favoritos')
      ),
      body: favoritosProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : listaFavoritos.isEmpty
              ? const Center(
                  child: Text(
                    'Aún no tienes bebidas favoritas.\n¡Presiona el ❤️ para añadir una!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )

              : ListView.builder(
                  itemCount: listaFavoritos.length,
                  itemBuilder: (context, index) {
                    final bebida = listaFavoritos[index];
                    
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
                        icon: const Icon(Icons.favorite),
                        color: Colors.red,
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
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}