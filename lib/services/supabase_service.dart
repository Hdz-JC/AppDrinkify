import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  /// Registra un usuario en Supabase
  Future<bool> registerUser(UserModel user) async {
    try {

      // 1️⃣ Revisar si el email ya existe
      final existing = await client
          .from('users')
          .select()
          .eq('email', user.email)
          .maybeSingle(); // devuelve null si no existe

      if (existing != null) {
        print('El email ya está registrado');
        return false; // No permitimos registro duplicado
      }

      final response = await client
          .from('users')
          .insert({
            'email': user.email,
            'username': user.username,
            'password': user.password,
          })
          .select(); 

        // Revisamos si hay error manualmente
        if (response == null || (response as List).isEmpty) {
          print('Error al registrar en Supabase');
          return false;
        }

        print('Usuario registrado en Supabase: $response');
        return true;
      }   catch (e) {
        print('Excepción al registrar usuario: $e');
        return false;
    }
  }

  /// Inicia sesión en Supabase verificando email y password
  Future<UserModel?> loginUser(String email, String password) async {
    try {
      final response = await client
          .from('users')
          .select()
          .eq('email', email)
          .eq('password', password)
          .maybeSingle(); // No usamos execute()

      // Revisamos si no hay datos
      if (response == null) {
        print('Usuario no encontrado o contraseña incorrecta');
        return null;
      }

      return UserModel.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      print('Excepción al loguear usuario: $e');
      return null;
    }
  }
}
