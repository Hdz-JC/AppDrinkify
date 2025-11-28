// lib/providers/favoritos_provider.dart
import 'package:flutter/material.dart';
import 'package:appdrinkify/config/datasource/sqlite_service.dart';
import 'package:appdrinkify/models/bebidas_model.dart'; 

class FavoritosProvider with ChangeNotifier {
  final SqliteService _sqliteService;

  FavoritosProvider(this._sqliteService);
  String? _currentUserId;
  List<Bebida> _favoritos = [];
  bool _isLoading = false;
  List<Bebida> get favoritos => _favoritos;
  bool get isLoading => _isLoading;
  void updateUser(int? newUserId) {
    final String? newUserIdAsString = newUserId?.toString();
    if (_currentUserId != newUserIdAsString) {
      _currentUserId = newUserIdAsString;

      if (newUserIdAsString != null) {
        _loadFavoritos(newUserIdAsString);
      } else {
        _favoritos = [];
        notifyListeners();
      }
    }
  }
  Future<void> _loadFavoritos(String userId) async {
    _isLoading = true;
    notifyListeners(); 
    _favoritos = await _sqliteService.getFavoritosPorUsuario(userId);
    _isLoading = false;
    notifyListeners(); 
  }

  bool esFavorita(int bebidaId) {
    return _favoritos.any((bebida) => bebida.id == bebidaId);
  }

  Future<void> toggleFavorito(Bebida bebida) async {
    if (_currentUserId == null || bebida.id == null) return;

    final bool esFav = esFavorita(bebida.id!);

    if (esFav) {
      await _sqliteService.removeFavorito(_currentUserId!, bebida.id!);
      _favoritos.removeWhere((b) => b.id == bebida.id!);
    } else {
      await _sqliteService.addFavorito(_currentUserId!, bebida.id!);
      _favoritos.add(bebida);
    }
    
    notifyListeners();
  }
}