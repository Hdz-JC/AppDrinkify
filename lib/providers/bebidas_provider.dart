// lib/providers/bebida_provider.dart
import 'package:flutter/material.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/config/datasource/sqlite_service.dart';

class BebidaProvider extends ChangeNotifier {
  final SqliteService _sqliteService = SqliteService.instance;

  List<Bebida> _listaCompletaBebidas = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Bebida> get listaCompletaBebidas => _listaCompletaBebidas;

  BebidaProvider() {
    _inicializar();
  }

  Future<void> _inicializar() async {
    _isLoading = true;
    notifyListeners();
    
    // 1. Poblar BD (si es necesario) con categorías y bebidas
    await _sqliteService.popularDatosIniciales();
    
    // 2. Cargar todas las bebidas (esto ahora incluye el JOIN!)
    _listaCompletaBebidas = await _sqliteService.getAllBebidas();
    
    _isLoading = false;
    notifyListeners();
  }

  // --- MODIFICADO: Búsqueda más potente ---
  List<Bebida> buscarBebidas(String query) {
    if (query.isEmpty) {
      return [];
    }
    
    final queryMinusculas = query.toLowerCase();

    final resultados = _listaCompletaBebidas.where((bebida) {
      final nombreMinusculas = bebida.nombre.toLowerCase();
      final descripcionMinusculas = bebida.descripcion.toLowerCase();
      
      // 'categoria_nombre' viene del JOIN y es seguro usarlo
      final categoriaMinusculas = bebida.categoria_nombre?.toLowerCase() ?? '';

      // Buscar en NOMBRE, DESCRIPCIÓN y NOMBRE DE CATEGORÍA
      return nombreMinusculas.contains(queryMinusculas) || 
             descripcionMinusculas.contains(queryMinusculas) ||
             categoriaMinusculas.contains(queryMinusculas);
             
    }).toList();

    return resultados;
  }

  List<Bebida> getBebidasPorCategoria(String nombreCategoria) {
    // Convierte el nombre de la categoría a minúsculas para una comparación segura
    final nombreMinusculas = nombreCategoria.toLowerCase();
    
    // Filtra la lista completa de bebidas
    final resultados = _listaCompletaBebidas.where((bebida) {
      // Compara el nombre de categoría de la bebida (del JOIN)
      final catNombreBebida = bebida.categoria_nombre?.toLowerCase() ?? '';
      return catNombreBebida == nombreMinusculas;
    }).toList();

    return resultados;
  }
}