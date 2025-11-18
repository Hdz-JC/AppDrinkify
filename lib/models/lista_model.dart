// lib/models/lista_model.dart
class Lista {
  final int? id;
  final String nombre;
  final String userId; // El ID del usuario que la creó

  Lista({
    this.id,
    required this.nombre,
    required this.userId,
  });

  factory Lista.fromMap(Map<String, dynamic> map) {
    return Lista(
      id: map['id'],
      nombre: map['nombre'],
      userId: map['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'user_id': userId,
    };
  }
}