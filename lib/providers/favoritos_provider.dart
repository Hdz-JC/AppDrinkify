// lib/providers/favoritos_provider.dart
import 'package:flutter/material.dart';
import 'package:appdrinkify/config/datasource/sqlite_service.dart';
import 'package:appdrinkify/models/bebidas_model.dart'; 

class FavoritosProvider with ChangeNotifier {
  final SqliteService _sqliteService;

  FavoritosProvider(this._sqliteService);

  // --- ESTADO INTERNO ---
  String? _currentUserId; // Esto SE QUEDA como String
  List<Bebida> _favoritos = [];
  bool _isLoading = false;

  // --- GETTERS ---
  List<Bebida> get favoritos => _favoritos;
  bool get isLoading => _isLoading;

  // --- LÓGICA PRINCIPAL ---

  // ========================================================
  // --- ¡AQUÍ ESTÁ LA CORRECCIÓN! ---
  // Cambiamos el tipo de parámetro de 'String?' a 'int?'
  void updateUser(int? newUserId) {
    
    // 1. Convertimos el int? a String?
    final String? newUserIdAsString = newUserId?.toString();

    // 2. El resto de la lógica funciona igual que antes
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
  // --- FIN DE LA CORRECCIÓN ---
  // ========================================================


  /// Carga la lista de favoritos desde la BD (privado)
  Future<void> _loadFavoritos(String userId) async {
    _isLoading = true;
    notifyListeners(); 

    // Esta función ya espera un String, así que está perfecto
    _favoritos = await _sqliteService.getFavoritosPorUsuario(userId);
    
    _isLoading = false;
    notifyListeners(); 
  }

  /// Revisa (sincrónicamente) si una bebida ya está en nuestra lista local
  bool esFavorita(int bebidaId) {
    return _favoritos.any((bebida) => bebida.id == bebidaId);
  }

  /// La función principal que la UI llamará para añadir/quitar un favorito
  Future<void> toggleFavorito(Bebida bebida) async {
    if (_currentUserId == null || bebida.id == null) return;

    // Esta función ya usa _currentUserId (que es String), así que está perfecta
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