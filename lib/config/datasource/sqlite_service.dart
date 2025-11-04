// lib/config/datasource/sqlite_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:appdrinkify/models/bebidas_model.dart'; // Importa tu nuevo modelo

class SqliteService {
  // --- Singleton Pattern (opcional pero recomendado) ---
  static final SqliteService instance = SqliteService._init();
  static Database? _database;
  SqliteService._init();
  // --- Fin Singleton ---

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bebidas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Crear la tabla de bebidas
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE bebidas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      descripcion TEXT,
      preparacion TEXT,
      image_url TEXT NOT NULL 
    )
    ''');
  }

  // --- Métodos CRUD para Bebidas ---

  // Insertar una bebida
  Future<int> createBebida(Bebida bebida) async {
    final db = await instance.database;
    return await db.insert('bebidas', bebida.toMap());
  }

  // Obtener todas las bebidas
  Future<List<Bebida>> getAllBebidas() async {
    final db = await instance.database;
    final result = await db.query('bebidas', orderBy: 'nombre ASC');
    return result.map((json) => Bebida.fromMap(json)).toList();
  }
  
  // Puedes añadir un método para poblar datos iniciales si la tabla está vacía
  Future<void> popularDatosIniciales() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM bebidas'));
    
    if (count == 0) {
      await createBebida(Bebida(
        nombre: "Mojito",
        descripcion: "Un cóctel cubano refrescante.",
        preparacion: "Menta, azúcar, ron, lima y soda.",
        imageUrl: "assets/images/bebidas/mojito.jpeg" // Ruta de ejemplo
      ));
      await createBebida(Bebida(
        nombre: "Margarita",
        descripcion: "Clásico cóctel mexicano.",
        preparacion: "Tequila, triple sec y jugo de lima.",
        imageUrl: "assets/images/bebidas/pina_colada.jpeg" // Ruta de ejemplo
      ));
    }
  }
}