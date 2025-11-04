// lib/models/bebida_model.dart
class Bebida {
  final int? id;
  final String nombre;
  final String descripcion; // La mantenemos para la búsqueda
  final String preparacion;
  final String imageUrl;
  final int categoria_id; // <-- AÑADIDO

  // AÑADIDO: Campo opcional para guardar el nombre de la categoría (del JOIN)
  final String? categoria_nombre; 

  Bebida({
    this.id,
    required this.nombre,
    required this.descripcion, // La mantenemos
    required this.preparacion,
    required this.imageUrl,
    required this.categoria_id, // <-- AÑADIDO
    this.categoria_nombre, // <-- AÑADIDO
  });

  // Convertir un Map (de SQLite) a un objeto Bebida
  factory Bebida.fromMap(Map<String, dynamic> map) {
    return Bebida(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      preparacion: map['preparacion'],
      imageUrl: map['image_url'],
      categoria_id: map['categoria_id'], // <-- AÑADIDO
      // AÑADIDO: Lee el nombre de la categoría si viene del JOIN
      categoria_nombre: map['categoria_nombre'], 
    );
  }

  // Convertir un objeto Bebida a un Map (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'preparacion': preparacion,
      'image_url': imageUrl,
      'categoria_id': categoria_id, // <-- AÑADIDO
    };
    // No incluimos 'categoria_nombre' en toMap porque es un campo de solo lectura
  }
}