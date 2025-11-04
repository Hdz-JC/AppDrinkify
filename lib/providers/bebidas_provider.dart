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
    // Carga los datos iniciales y luego carga la lista
    _inicializar();
  }

  Future<void> _inicializar() async {
    _isLoading = true;
    notifyListeners();
    
    // 1. Asegúrate de que haya datos (ejecuta esto solo una vez)
    await _sqliteService.popularDatosIniciales();
    
    // 2. Carga todas las bebidas en memoria
    _listaCompletaBebidas = await _sqliteService.getAllBebidas();
    
    _isLoading = false;
    notifyListeners();
  }

  // ¡La lógica de búsqueda!
  List<Bebida> buscarBebidas(String query) {
    if (query.isEmpty) {
      return []; // No mostrar nada si la búsqueda está vacía
    }
    
    final queryMinusculas = query.toLowerCase();

    // Filtra la lista que ya tienes en memoria (¡súper rápido!)
    final resultados = _listaCompletaBebidas.where((bebida) {
      final nombreMinusculas = bebida.nombre.toLowerCase();
      // Puedes hacer la búsqueda más compleja (por ingrediente, etc.)
      return nombreMinusculas.contains(queryMinusculas);
    }).toList();

    return resultados;
  }
}