class Lista {
  final int? id;
  final String nombre;
  final String userId;

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