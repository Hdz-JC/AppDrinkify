// lib/config/datasource/sqlite_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/models/categoria_model.dart'; // <-- AÑADIR

class SqliteService {
  // ... (tu singleton se mantiene) ...
  static final SqliteService instance = SqliteService._init();
  static Database? _database;
  SqliteService._init();

  // ... (el 'get database' se mantiene) ...
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bebidas.db');
    return _database!;
  }
  
  // (el '_initDB' se mantiene, pero recuerda REINSTALAR la app)
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // --- MODIFICADO: Crear ambas tablas ---
  Future _createDB(Database db, int version) async {
    // 1. Crear tabla de Categorías (PRIMERO)
    await db.execute('''
    CREATE TABLE categorias (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL
    )
    ''');

    // 2. Modificar tabla de Bebidas (SEGUNDO)
    await db.execute('''
    CREATE TABLE bebidas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL,
      descripcion TEXT,
      preparacion TEXT,
      image_url TEXT NOT NULL,
      categoria_id INTEGER NOT NULL,
      FOREIGN KEY (categoria_id) REFERENCES categorias (id)
    )
    ''');
  }

  // --- MODIFICADO: createBebida ---
  Future<int> createBebida(Bebida bebida) async {
    final db = await instance.database;
    return await db.insert('bebidas', bebida.toMap());
  }

  // --- NUEVO: getAllCategorias (por si lo necesitas) ---
  Future<List<Categoria>> getAllCategorias() async {
    final db = await instance.database;
    final result = await db.query('categorias', orderBy: 'nombre ASC');
    return result.map((json) => Categoria.fromMap(json)).toList();
  }

  // --- MODIFICADO: getAllBebidas (AHORA CON JOIN) ---
  Future<List<Bebida>> getAllBebidas() async {
    final db = await instance.database;
    // Query con JOIN para obtener también el nombre de la categoría
    final result = await db.rawQuery('''
      SELECT 
        b.id, 
        b.nombre, 
        b.descripcion, 
        b.preparacion, 
        b.image_url, 
        b.categoria_id, 
        c.nombre as categoria_nombre 
      FROM bebidas b
      JOIN categorias c ON b.categoria_id = c.id
      ORDER BY b.nombre ASC
    ''');
    
    // El 'Bebida.fromMap' ya está listo para recibir 'categoria_nombre'
    return result.map((json) => Bebida.fromMap(json)).toList();
  }
  
  // --- MODIFICADO: popularDatosIniciales ---
  Future<void> popularDatosIniciales() async {
  final db = await instance.database;
  
  // 1. Revisar si las categorías existen. Si no, crearlas.
  int catCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM categorias')) ?? 0;
  if (catCount == 0) {
    await db.insert('categorias', {'nombre': 'Aguas frescas'}); // ID = 1
    await db.insert('categorias', {'nombre': 'Calientes'}); // ID = 2
    await db.insert('categorias', {'nombre': 'Con alcohol'}); // ID = 3
    await db.insert('categorias', {'nombre': 'Jugos Clasicos'}); // ID = 4
    await db.insert('categorias', {'nombre': 'Jugos Fitness'}); // ID = 5
    await db.insert('categorias', {'nombre': 'Batidos'}); // ID = 6
  }

  // 2. Revisar si las bebidas existen. Si no, crearlas.
  int bevCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM bebidas')) ?? 0;
  if (bevCount == 0) {

    // ===============================
    // CATEGORÍA 1 - AGUAS FRESCAS
    // ===============================
    await createBebida(Bebida(
      nombre: "Agua de Jamaica",
      descripcion: "Refrescante y con toque ácido.",
      preparacion: "Hierve flor de jamaica, cuela y mezcla con azúcar y limón.",
      imageUrl: "assets/images/aguas_frescas/jamaica.jpg",
      categoria_id: 1
    ));
    await createBebida(Bebida(
      nombre: "Agua de Horchata",
      descripcion: "Tradicional bebida mexicana de arroz y canela.",
      preparacion: "Licúa arroz, canela, azúcar y agua; cuela y enfría.",
      imageUrl: "assets/images/aguas_frescas/horchata.jpg",
      categoria_id: 1
    ));
    await createBebida(Bebida(
      nombre: "Agua de Tamarindo",
      descripcion: "Sabor agridulce natural.",
      preparacion: "Disuelve la pulpa de tamarindo en agua, cuela y endulza.",
      imageUrl: "assets/images/aguas_frescas/tamarindo.jpg",
      categoria_id: 1
    ));
    await createBebida(Bebida(
      nombre: "Agua de Pepino con Limón y Chía",
      descripcion: "Ligera y muy hidratante.",
      preparacion: "Licúa pepino y limón; añade chía y refrigera.",
      imageUrl: "assets/images/aguas_frescas/pepino_limon.jpg",
      categoria_id: 1
    ));
    await createBebida(Bebida(
      nombre: "Agua de Melón",
      descripcion: "Refrescante y veraniega.",
      preparacion: "Licúa melón con agua y azúcar; sirve con hielo.",
      imageUrl: "assets/images/aguas_frescas/melon.jpg",
      categoria_id: 1
    ));

    // ===============================
    // CATEGORÍA 2 - CALIENTES
    // ===============================
    await createBebida(Bebida(
      nombre: "Café Cappuccino",
      descripcion: "Clásico italiano con espresso y espuma de leche.",
      preparacion: "Prepara un espresso y añade leche vaporizada con espuma.",
      imageUrl: "assets/images/calientes/capuchino.jpg",
      categoria_id: 2
    ));
    await createBebida(Bebida(
      nombre: "Chocolate Caliente",
      descripcion: "Bebida dulce y reconfortante.",
      preparacion: "Derrite chocolate en leche caliente y mezcla hasta espumar.",
      imageUrl: "assets/images/calientes/chocolate.jpg",
      categoria_id: 2
    ));
    await createBebida(Bebida(
      nombre: "Té Chai Latte",
      descripcion: "Té negro con especias y leche.",
      preparacion: "Hierve té con canela, clavo y cardamomo; agrega leche.",
      imageUrl: "assets/images/calientes/chai_latte.jpg",
      categoria_id: 2
    ));
    await createBebida(Bebida(
      nombre: "Matcha Latte",
      descripcion: "Té verde japonés energizante.",
      preparacion: "Disuelve matcha en agua caliente y añade leche espumada.",
      imageUrl: "assets/images/calientes/matcha_latte.jpg",
      categoria_id: 2
    ));
    await createBebida(Bebida(
      nombre: "Atole de Vainilla",
      descripcion: "Tradicional mexicano, espeso y suave.",
      preparacion: "Cocina leche con maicena, azúcar y vainilla hasta espesar.",
      imageUrl: "assets/images/calientes/vainilla.jpg",
      categoria_id: 2
    ));

    // ===============================
    // CATEGORÍA 3 - CON ALCOHOL
    // ===============================
    await createBebida(Bebida(
      nombre: "Mojito",
      descripcion: "Un cóctel cubano refrescante con menta y ron.",
      preparacion: "Mezcla menta, azúcar, jugo de lima y ron; completa con soda y hielo.",
      imageUrl: "assets/images/con_alcohol/mojito.jpeg",
      categoria_id: 3
    ));
    await createBebida(Bebida(
      nombre: "Margarita",
      descripcion: "Un clásico mexicano con tequila y limón.",
      preparacion: "Agita tequila, triple sec y jugo de limón; sirve con sal en el borde.",
      imageUrl: "assets/images/con_alcohol/margarita.jpg",
      categoria_id: 3
    ));
    await createBebida(Bebida(
      nombre: "Piña Colada",
      descripcion: "Cóctel tropical y cremoso de ron, piña y coco.",
      preparacion: "Licúa ron, crema de coco y jugo de piña con hielo.",
      imageUrl: "assets/images/con_alcohol/pina.jpeg",
      categoria_id: 3
    ));
    await createBebida(Bebida(
      nombre: "Negroni",
      descripcion: "Cóctel italiano fuerte y amargo.",
      preparacion: "Mezcla ginebra, Campari y vermut rojo en partes iguales.",
      imageUrl: "assets/images/con_alcohol/negroni.jpg",
      categoria_id: 3
    ));
    await createBebida(Bebida(
      nombre: "Whiskey Sour",
      descripcion: "Equilibrio entre dulce y ácido con whiskey.",
      preparacion: "Agita whiskey, limón y jarabe de azúcar; sirve con hielo.",
      imageUrl: "assets/images/con_alcohol/whiskey_sour.jpg",
      categoria_id: 3
    ));

    // ===============================
    // CATEGORÍA 4 - JUGOS CLÁSICOS
    // ===============================
    await createBebida(Bebida(
      nombre: "Jugo de Naranja",
      descripcion: "Clásico desayuno lleno de vitamina C.",
      preparacion: "Exprime naranjas frescas y sirve frío.",
      imageUrl: "assets/images/jugos_clasicos/naranja.jpg",
      categoria_id: 4
    ));
    await createBebida(Bebida(
      nombre: "Jugo Verde",
      descripcion: "Nutritivo y depurativo.",
      preparacion: "Licúa nopal, piña, apio, perejil, limón y espinaca.",
      imageUrl: "assets/images/jugos_clasicos/verde.jpg",
      categoria_id: 4
    ));
    await createBebida(Bebida(
      nombre: "Jugo de Zanahoria",
      descripcion: "Dulce y lleno de betacarotenos.",
      preparacion: "Exprime zanahorias frescas y sirve frío.",
      imageUrl: "assets/images/jugos_clasicos/zanahoria.jpg",
      categoria_id: 4
    ));
    await createBebida(Bebida(
      nombre: "Jugo de Piña con Menta",
      descripcion: "Refrescante y digestivo.",
      preparacion: "Licúa piña natural con hojas de menta y agua fría.",
      imageUrl: "assets/images/jugos_clasicos/pina_menta.jpg",
      categoria_id: 4
    ));
    await createBebida(Bebida(
      nombre: "Jugo de Betabel, Zanahoria y Manzana",
      descripcion: "Colorido y antioxidante.",
      preparacion: "Licúa betabel, zanahoria y manzana en partes iguales.",
      imageUrl: "assets/images/jugos_clasicos/betabel.jpg",
      categoria_id: 4
    ));
    
    // ===============================
    // CATEGORÍA 5 - JUGOS FITNESS
    // ===============================
    await createBebida(Bebida(
      nombre: "Jugo Verde Detox",
      descripcion: "Depurativo con vegetales verdes.",
      preparacion: "Licúa espinaca, pepino, apio, manzana verde, jengibre y limón.",
      imageUrl: "assets/images/jugos_fitness/jugo_verde_detox.jpg",
      categoria_id: 5
    ));
    await createBebida(Bebida(
      nombre: "Energía Matutina",
      descripcion: "Activa el cuerpo y la mente.",
      preparacion: "Licúa zanahoria, naranja y jengibre fresco.",
      imageUrl: "assets/images/jugos_fitness/energia_matutina.jpg",
      categoria_id: 5
    ));
    await createBebida(Bebida(
      nombre: "Metabolismo Activo",
      descripcion: "Estimula la quema de grasa.",
      preparacion: "Mezcla toronja, piña y menta con agua fría.",
      imageUrl: "assets/images/jugos_fitness/metabolismo_activo.jpg",
      categoria_id: 5
    ));
    await createBebida(Bebida(
      nombre: "Recuperación Post-Ejercicio",
      descripcion: "Hidratante y rica en electrolitos.",
      preparacion: "Licúa sandía, limón y agua de coco.",
      imageUrl: "assets/images/jugos_fitness/recuperacion_post_ejercicio.jpg",
      categoria_id: 5
    ));
    await createBebida(Bebida(
      nombre: "Antioxidante Power",
      descripcion: "Rico en antioxidantes naturales.",
      preparacion: "Licúa arándanos, uva y betabel con agua fría.",
      imageUrl: "assets/images/jugos_fitness/antioxidante_power.jpg",
      categoria_id: 5
    ));

    // ===============================
    // CATEGORÍA 6 - BATIDOS
    // ===============================
    await createBebida(Bebida(
      nombre: "Banana y Avena",
      descripcion: "Ideal para el desayuno o post entreno.",
      preparacion: "Licúa plátano, avena, leche y miel.",
      imageUrl: "assets/images/batidos/banana_avena.jpg",
      categoria_id: 6
    ));
    await createBebida(Bebida(
      nombre: "Fresa y Yogur",
      descripcion: "Cremoso, dulce y natural.",
      preparacion: "Licúa fresas, yogur natural y un toque de miel.",
      imageUrl: "assets/images/batidos/fresa_yogur.jpg",
      categoria_id: 6
    ));
    await createBebida(Bebida(
      nombre: "Mango Tropical",
      descripcion: "Exótico y refrescante.",
      preparacion: "Licúa mango, piña y leche de coco.",
      imageUrl: "assets/images/batidos/mango_tropical.jpg",
      categoria_id: 6
    ));
    await createBebida(Bebida(
      nombre: "Chocolate Proteico",
      descripcion: "Energético y con alto contenido proteico.",
      preparacion: "Licúa cacao, plátano, proteína en polvo y mantequilla de maní.",
      imageUrl: "assets/images/batidos/chocolate_proteico.jpg",
      categoria_id: 6
    ));
    await createBebida(Bebida(
      nombre: "Verde Energético",
      descripcion: "Refrescante y rico en fibra.",
      preparacion: "Licúa espinaca, manzana, pepino, piña y agua de coco.",
      imageUrl: "assets/images/batidos/verde_energetico.jpg",
      categoria_id: 6
    ));
    
  }
}

}