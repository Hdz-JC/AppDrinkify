// lib/models/categoria_model.dart
class Categoria {
  final int? id;
  final String nombre;

  Categoria({
    this.id,
    required this.nombre,
  });

  // Convertir un Map (de SQLite) a un objeto Categoria
  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'],
      nombre: map['nombre'],
    );
  }

  // Convertir un objeto Categoria a un Map (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}