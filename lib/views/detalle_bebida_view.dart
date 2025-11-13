import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:flutter/material.dart';

// --- AÑADIR ESTOS IMPORTS ---
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/favoritos_provider.dart';
// --- FIN IMPORTS ---


class DetalleBebidaView extends StatelessWidget {
  // 1. AÑADIMOS ESTO:
  // Le decimos a la pantalla que NECESITA que le pases
  // un objeto 'Bebida' para poder construirse.
  final Bebida bebida;

  const DetalleBebidaView({
    super.key,
    required this.bebida, // <-- Se hace obligatorio
  });

  @override
  Widget build(BuildContext context) {
    
    // --- AÑADIDO: OBTENER EL PROVIDER DE FAVORITOS ---
    // Usamos 'watch' para que el icono se redibuje
    final favoritosProvider = context.watch<FavoritosProvider>();
    
    // Determinamos si la bebida actual es favorita
    final bool esFav = (bebida.id != null)
        ? favoritosProvider.esFavorita(bebida.id!)
        : false;
    // --- FIN DE AÑADIDO ---

    return Scaffold(
      appBar: AppBar(
        //Aqui se debe mostrar el nombre de la bebida a la que se le hizo click
        title: Text(bebida.nombre), // <-- SOLUCIONADO
        
        // --- AÑADIDO: BOTÓN DE ACCIÓN EN APPBAR ---
        actions: [
          IconButton(
            icon: Icon(
              esFav ? Icons.favorite : Icons.favorite_border,
              color: esFav ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              // Llamamos al provider para añadir/quitar
              // Usamos 'read' porque estamos dentro de un callback
              context.read<FavoritosProvider>().toggleFavorito(bebida);
            },
          ),
        ],
        // --- FIN DE AÑADIDO ---
      ),
      //todo debe de estar centrado
      body: Center(
        // 2. AÑADIMOS UN SCROLL
        // Para que si las instrucciones son muy largas, no se rompa la pantalla
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Un poco de espacio en los bordes
          // 3. AÑADIMOS LA COLUMNA
          // La Columna nos deja poner widgets uno encima de otro.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // aqui se mostrara la imagen de la bebida seleccioanda
              ClipRRect( // Para redondear las esquinas
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  bebida.imageUrl, // <-- SOLUCIONADO
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                  // Un 'errorBuilder' por si no se encuentra la imagen
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
              const SizedBox(height: 16), // Espacio

              // aqui se mostrara el nombre de la categoria a la que pertenece la bebida
              Text(
                // Usamos '??' por si 'categoria_nombre' es nulo
                bebida.categoria_nombre ?? 'Sin Categoría', // <-- SOLUCIONADO
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24), // Más espacio

              // aqui se mostrara la palabra instrucciones en grande
              const Text(
                "Instrucciones", // <-- SOLUCIONADO
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // Espacio

              // aqui se mostraran las instrucciones paso a paso
              Text(
                bebida.preparacion, // <-- SOLUCIONADO
                textAlign: TextAlign.center, // Para que el texto se vea centrado
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}