// lib/views/detalle_lista_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdrinkify/models/lista_model.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/providers/listas_provider.dart';
import 'package:appdrinkify/views/detalle_bebida_view.dart';
import 'package:appdrinkify/providers/favoritos_provider.dart';

class DetalleListaView extends StatefulWidget {
  final Lista lista;
  
  const DetalleListaView({super.key, required this.lista});

  @override
  State<DetalleListaView> createState() => _DetalleListaViewState();
}

class _DetalleListaViewState extends State<DetalleListaView> {
  Future<List<Bebida>>? _bebidasFuture;

  @override
  void initState() {
    super.initState();
    _bebidasFuture = context.read<ListasProvider>().getBebidasParaLista(widget.lista.id!);
  }

  @override
  Widget build(BuildContext context) {
    final favoritosProvider = context.watch<FavoritosProvider>();
    
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        title: Text(widget.lista.nombre),
      ),
      body: FutureBuilder<List<Bebida>>(
        future: _bebidasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Esta lista está vacía.',
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            );
          }

          final List<Bebida> bebidas = snapshot.data!;
          
          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: bebidas.length,
            separatorBuilder: (ctx, index) => const Divider(),
            itemBuilder: (context, index) {
              final bebida = bebidas[index];
              final bool esFav = favoritosProvider.esFavorita(bebida.id!);

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    bebida.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    // --- CAMBIO: ICONO DE FALLBACK ---
                    errorBuilder: (context, error, stackTrace) => Container(
                       width: 60, height: 60, color: const Color.fromARGB(255, 255, 255, 255),
                       child: const Icon(Icons.local_drink, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                title: Text(
                  bebida.nombre, 
                  style: const TextStyle(fontWeight: FontWeight.bold)
                ),
                
                subtitle: Row(
                  children: [
                    const Icon(Icons.label_outline, size: 14, color: Color.fromRGBO(251, 83, 21, 1)),
                    const SizedBox(width: 4),
                    Text(
                      bebida.categoria_nombre ?? 'General',
                      style: TextStyle(color: Color.fromRGBO(251, 83, 21, 1)),
                    ),
                  ],
                ),
                
                trailing: IconButton(
                  icon: Icon(
                    esFav ? Icons.favorite : Icons.favorite_border,
                    color: esFav ? Colors.red : const Color.fromARGB(255, 255, 255, 255),
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
          );
        },
      ),
    );
  }
}