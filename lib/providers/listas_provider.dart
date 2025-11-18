// lib/providers/listas_provider.dart
import 'package:flutter/material.dart';
import 'package:appdrinkify/config/datasource/sqlite_service.dart';
import 'package:appdrinkify/models/lista_model.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/models/categoria_model.dart';

class ListasProvider with ChangeNotifier {
  final SqliteService _sqliteService;

  ListasProvider(this._sqliteService);

  String? _currentUserId;
  List<Lista> _misListas = [];
  bool _isLoading = false;

  List<Lista> get misListas => _misListas;
  bool get isLoading => _isLoading;

  void updateUser(int? newUserId) {
    final String? newUserIdAsString = newUserId?.toString();
    if (_currentUserId != newUserIdAsString) {
      _currentUserId = newUserIdAsString;
      if (newUserIdAsString != null) {
        _loadListas();
      } else {
        _misListas = [];
        notifyListeners();
      }
    }
  }

  Future<void> _loadListas() async {
    if (_currentUserId == null) return;
    _isLoading = true;
    notifyListeners();
    
    _misListas = await _sqliteService.getListasPorUsuario(_currentUserId!);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createLista(String nombre, List<Categoria> categorias) async {
    if (_currentUserId == null) return;
    
    // Convertir lista de objetos Categoria a lista de IDs (int)
    final List<int> categoriaIds = categorias.map((c) => c.id!).toList();
    
    // Llamar al servicio de BD
    final Lista nuevaLista = await _sqliteService.createLista(nombre, _currentUserId!, categoriaIds);
    
    // Añadir a la lista local y notificar
    _misListas.add(nuevaLista);
    notifyListeners();
  }

  Future<void> renameLista(int listaId, String nuevoNombre) async {
    await _sqliteService.renameLista(listaId, nuevoNombre);
    
    // Actualizar la lista local
    final index = _misListas.indexWhere((lista) => lista.id == listaId);
    if (index != -1) {
      // Recrear el objeto para forzar la actualización
      _misListas[index] = Lista(
        id: _misListas[index].id,
        nombre: nuevoNombre,
        userId: _misListas[index].userId,
      );
      notifyListeners();
    }
  }

  Future<void> deleteLista(int listaId) async {
    await _sqliteService.deleteLista(listaId);
    
    // Quitar de la lista local
    _misListas.removeWhere((lista) => lista.id == listaId);
    notifyListeners();
  }
  
  // Método para que la vista de detalle obtenga las bebidas
  Future<List<Bebida>> getBebidasParaLista(int listaId) {
    return _sqliteService.getBebidasPorLista(listaId);
  }
}