import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  Future<bool> registerUser(UserModel user) async {
    try {
      final existing = await client
          .from('users')
          .select()
          .eq('email', user.email)
          .maybeSingle();

      if (existing != null) {
        print('El email ya está registrado');
        return false;
      }

      final response = await client
          .from('users')
          .insert({
            'email': user.email,
            'username': user.username,
            'password': user.password,
          })
          .select(); 

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
  Future<UserModel?> loginUser(String email, String password) async {
    try {
      final response = await client
          .from('users')
          .select()
          .eq('email', email)
          .eq('password', password)
          .maybeSingle();
      if (response != null) {
       return UserModel.fromMap(response);
      }

      print('Usuario no encontrado o contraseña incorrecta');
      return null;

    } catch (e) {
      print('Excepción al loguear usuario: $e');
      return null;
    }
  }
}
