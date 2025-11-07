//import 'package:appdrinkify/config/datasource/sqlite_service.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../config/datasource/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> login(String email, String password) async {
    final user = await _supabaseService.loginUser(email, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
    }
  }

  Future<void> register(String username, String email, String password) async {
    final user = UserModel(
      username: username,
      email: email,
      password: password,
    );
    final success = await _supabaseService.registerUser(user);
    if (success) {
      _currentUser = user;
      notifyListeners();
    }
  }

  void logout() async {
  _currentUser = null;


}

}
