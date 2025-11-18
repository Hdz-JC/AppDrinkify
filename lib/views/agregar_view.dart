// lib/views/agregar_view.dart
import 'package:appdrinkify/views/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdrinkify/providers/bebidas_provider.dart';
import 'package:appdrinkify/providers/listas_provider.dart';
import 'package:appdrinkify/models/categoria_model.dart';
import 'package:appdrinkify/controllers/navigation_controller.dart';

class AgregarView extends StatefulWidget {
  const AgregarView({super.key});

  @override
  State<AgregarView> createState() => _AgregarViewState();
}

class _AgregarViewState extends State<AgregarView> {
  final _nombreController = TextEditingController();
  final Map<int, bool> _categoriasSeleccionadas = {};
  List<Categoria> _categoriasDisponibles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Un pequeño delay para asegurar que el provider esté listo
    Future.microtask(() => _cargarCategorias());
  }

  void _cargarCategorias() {
    final categorias = context.read<BebidaProvider>().todasCategorias;
    
    if (mounted) {
      setState(() {
        _categoriasDisponibles = categorias;
        for (var cat in categorias) {
          // Inicializamos desmarcadas
          _categoriasSeleccionadas[cat.id!] = false;
        }
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _crearLista() async {
    final nombre = _nombreController.text.trim(); // Quitamos espacios al inicio/final

    // --- VALIDACIÓN 1: CAMPO VACÍO ---
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ponle un nombre a tu mix')),
      );
      return;
    }

    // --- VALIDACIÓN 2: CARACTERES PERMITIDOS (REGEX) ---
    // Permite: a-z, A-Z, 0-9, espacios (\s) y letras con acentos/ñ del español.
    // Rechaza automáticamente: " ' = % ( ) @ # etc.
    final validCharacters = RegExp(r'^[a-zA-Z0-9\sñÑáéíóúÁÉÍÓÚüÜ]+$');
    
    if (!validCharacters.hasMatch(nombre)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre solo puede contener letras, números y espacios.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // --- VALIDACIÓN 3: PALABRAS PROHIBIDAS (SQL) ---
    // Lista de palabras que no quieres (en minúsculas)
    final forbiddenWords = ['select', 'where', 'like', 'drop', 'delete', 'update', 'insert', 'table'];
    final nombreMinusculas = nombre.toLowerCase();

    for (var word in forbiddenWords) {
      // Usamos \b para buscar la palabra exacta (que "selecta" no active "select")
      if (RegExp(r'\b' + word + r'\b').hasMatch(nombreMinusculas)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La palabra "$word" no está permitida por seguridad.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final List<Categoria> seleccionadas = [];
    for (var cat in _categoriasDisponibles) {
      if (_categoriasSeleccionadas[cat.id!] == true) {
        seleccionadas.add(cat);
      }
    }

    if (seleccionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona al menos una categoría')));
      return;
    }

    try {
      // Esto llama al método que modificamos en SqliteService
      // para crear una lista RANDOM de 10 bebidas.
      await context.read<ListasProvider>().createLista(nombre, seleccionadas);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Playlist "$nombre" creada!')));
        // Redirigimos a la vista de Listas para ver el resultado
        NavigationController.navigateTo(context, '/listas');
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Mix'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Crea tu playlist de bebidas",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Elige un nombre y las categorías. Nosotros seleccionaremos bebidas al azar para ti.",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Input del nombre
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Mix (ej. Fiesta Viernes)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Categorías a incluir:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Lista de Checkboxes
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _categoriasDisponibles.length,
                    itemBuilder: (context, index) {
                      final categoria = _categoriasDisponibles[index];
                      return CheckboxListTile(
                        activeColor: Colors.deepPurple,
                        title: Text(categoria.nombre),
                        value: _categoriasSeleccionadas[categoria.id!],
                        onChanged: (bool? value) {
                          setState(() {
                            _categoriasSeleccionadas[categoria.id!] = value ?? false;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Botón Crear
                  ElevatedButton.icon(
                    onPressed: _crearLista,
                    icon: const Icon(Icons.auto_awesome), // Icono mágico
                    label: const Text('Generar Mix Aleatorio', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}