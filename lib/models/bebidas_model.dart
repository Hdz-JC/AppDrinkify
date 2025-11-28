class Bebida {
  final int? id;
  final String nombre;
  final String descripcion;
  final String preparacion;
  final String imageUrl;
  final int categoria_id;

  final String? categoria_nombre; 

  Bebida({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.preparacion,
    required this.imageUrl,
    required this.categoria_id,
    this.categoria_nombre,
  });

  factory Bebida.fromMap(Map<String, dynamic> map) {
    return Bebida(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      preparacion: map['preparacion'],
      imageUrl: map['image_url'],
      categoria_id: map['categoria_id'],
      categoria_nombre: map['categoria_nombre'], 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'preparacion': preparacion,
      'image_url': imageUrl,
      'categoria_id': categoria_id,
    };
  }
}