import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/sqlite_service.dart';
import '../services/supabase_service.dart';

class AuthController extends ChangeNotifier {
  UserModel? _currentUser;
  final SupabaseService _supabaseService = SupabaseService();

  UserModel? get currentUser => _currentUser;

  /// Inicia sesión
  Future<bool> login(String email, String password) async {
    final user = await _supabaseService.loginUser(email, password);
    if (user != null) {
      _currentUser = user;
      // Guardamos el usuario localmente para persistencia
      await SQLiteService.insertUser(user);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Registrar usuario
  Future<bool> register(UserModel user) async {
    final success = await _supabaseService.registerUser(user);
    if (success) {
      await SQLiteService.insertUser(user);
      _currentUser = user;
      notifyListeners();
    }
    return success;
  }

  /// Cargar usuario guardado localmente (SQLite)
  Future<void> loadLocalUser() async {
    final dbUser = await SQLiteService.getUserByEmail(_currentUser?.email ?? '');
    if (dbUser != null) {
      _currentUser = dbUser;
      notifyListeners();
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}
