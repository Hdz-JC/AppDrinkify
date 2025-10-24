import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class SQLiteService {
  static Database? _db;

  static Future<Database> getDb() async {
    if (_db != null) return _db!;
    String path = join(await getDatabasesPath(), 'app.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            username TEXT,
            password TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  /// Inserta un usuario solo si el email no existe
  static Future<bool> insertUser(UserModel user) async {
    final db = await getDb();

    // 1️⃣ Revisar si el email ya existe
    final existing = await getUserByEmail(user.email);
    if (existing != null) {
      print('El email ya existe en SQLite');
      return false; // no insertamos duplicado
    }

    // 2️⃣ Insertar usuario
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    return true;
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    final db = await getDb();
    final maps = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<void> deleteAllUsers() async {
    final db = await getDb();
    await db.delete('users');
  }
}
