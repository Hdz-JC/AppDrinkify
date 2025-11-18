// lib/views/listas_view.dart
import 'package:appdrinkify/views/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/listas_provider.dart';
import 'package:appdrinkify/models/lista_model.dart';
import 'package:appdrinkify/views/detalle_lista_view.dart'; 

class ListasView extends StatelessWidget {
  const ListasView({super.key});

  @override
  Widget build(BuildContext context) {
    final listasProvider = context.watch<ListasProvider>();
    final List<Lista> misListas = listasProvider.misListas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Mixes'), // Cambié "Listas" por "Mixes" (suena mejor)
        centerTitle: true,
      ),
      body: listasProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : misListas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // --- CAMBIO DE ICONO GRANDE ---
                      const Icon(Icons.liquor, size: 80, color: Colors.grey), 
                      const SizedBox(height: 16),
                      const Text(
                        'Aún no tienes Mixes creados.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.0),
                        child: Text(
                          'Ve a la pestaña "Crear" para generar uno nuevo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: misListas.length,
                  itemBuilder: (context, index) {
                    final lista = misListas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        // --- CAMBIO: ICONO DE LA LISTA ---
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple.shade100,
                          child: const Icon(Icons.local_bar, color: Colors.deepPurple), 
                        ),
                        title: Text(
                          lista.nombre, 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: const Text("Mix de bebidas"),
                        
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showRenameDialog(context, lista);
                            } else if (value == 'delete') {
                              _showDeleteDialog(context, lista);
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 10),
                                  Text('Renombrar'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text('Eliminar'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleListaView(lista: lista),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  // (Los diálogos _showRenameDialog y _showDeleteDialog se quedan IGUAL que antes)
  void _showRenameDialog(BuildContext context, Lista lista) {
    final renameController = TextEditingController(text: lista.nombre);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Renombrar Mix'),
          content: TextField(
            controller: renameController,
            decoration: const InputDecoration(labelText: 'Nuevo nombre'),
            autofocus: true,
          ),
          actions: [
            TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(ctx)),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (renameController.text.isNotEmpty) {
                  context.read<ListasProvider>().renameLista(lista.id!, renameController.text);
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Lista lista) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Eliminar Mix'),
          content: Text('¿Seguro que quieres borrar "${lista.nombre}"?'),
          actions: [
            TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(ctx)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                context.read<ListasProvider>().deleteLista(lista.id!);
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }
}