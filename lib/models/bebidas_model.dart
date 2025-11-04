// lib/models/bebida_model.dart

class Bebida {
  final int? id;
  final String nombre;
  final String descripcion;
  final String preparacion;
  final String imageUrl; // Esta será la RUTA local (ej: "assets/images/mojito.png")

  Bebida({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.preparacion,
    required this.imageUrl,
  });

  // Convertir un Map (de SQLite) a un objeto Bebida
  factory Bebida.fromMap(Map<String, dynamic> map) {
    return Bebida(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      preparacion: map['preparacion'],
      imageUrl: map['image_url'],
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
    };
  }
}