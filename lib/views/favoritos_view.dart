// lib/views/favoritos_view.dart
import 'package:appdrinkify/views/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
// --- AÑADIR ESTOS IMPORTS ---
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/favoritos_provider.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/views/detalle_bebida_view.dart';
// --- FIN IMPORTS ---

class FavoritosView extends StatelessWidget {
  const FavoritosView({super.key});


  @override
  Widget build(BuildContext context) {
    // --- AÑADIDO ---
    // 'watch' aquí es crucial. Si el usuario quita un favorito,
    // la lista se actualiza y la UI se reconstruye automáticamente.
    final favoritosProvider = context.watch<FavoritosProvider>();
    final List<Bebida> listaFavoritos = favoritosProvider.favoritos;
    // --- FIN AÑADIDO ---

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Favoritos')),

      // --- MODIFICADO: EL BODY ---
      body: favoritosProvider.isLoading
          // 1. Si está cargando, muestra un spinner
          ? const Center(child: CircularProgressIndicator())
          
          // 2. Si no está cargando, revisa si la lista está vacía
          : listaFavoritos.isEmpty
              ? const Center(
                  child: Text(
                    'Aún no tienes bebidas favoritas.\n¡Presiona el ❤️ para añadir una!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              
              // 3. Si no está vacía, muestra la lista
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
                      // El icono aquí siempre está lleno
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite),
                        color: Colors.red,
                        onPressed: () {
                          // Al presionarlo aquí, se QUITARÁ de favoritos
                          context.read<FavoritosProvider>().toggleFavorito(bebida);
                        },
                      ),
                      onTap: () {
                        // También puedes navegar al detalle desde aquí
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
      // --- FIN DE MODIFICACIÓN ---

      bottomNavigationBar: const BottomNavBar(),
    );
  }
}