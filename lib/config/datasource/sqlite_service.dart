// lib/config/datasource/sqlite_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:appdrinkify/models/bebidas_model.dart';
import 'package:appdrinkify/models/categoria_model.dart';

class SqliteService {
  static final SqliteService instance = SqliteService._init();
  static Database? _database;
  SqliteService._init();

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

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE categorias (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nombre TEXT NOT NULL
    )
    ''');

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

  Future<int> createBebida(Bebida bebida) async {
    final db = await instance.database;
    return await db.insert('bebidas', bebida.toMap());
  }

  Future<List<Categoria>> getAllCategorias() async {
    final db = await instance.database;
    final result = await db.query('categorias', orderBy: 'nombre ASC');
    return result.map((json) => Categoria.fromMap(json)).toList();
  }

  Future<List<Bebida>> getAllBebidas() async {
    final db = await instance.database;
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
    
    return result.map((json) => Bebida.fromMap(json)).toList();
  }
  
  Future<void> popularDatosIniciales() async {
  final db = await instance.database;
  int catCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM categorias')) ?? 0;
  if (catCount == 0) {
    await db.insert('categorias', {'nombre': 'Aguas frescas'}); // ID = 1
    await db.insert('categorias', {'nombre': 'Calientes'}); // ID = 2
    await db.insert('categorias', {'nombre': 'Con alcohol'}); // ID = 3
    await db.insert('categorias', {'nombre': 'Jugos Clasicos'}); // ID = 4
    await db.insert('categorias', {'nombre': 'Jugos Fitness'}); // ID = 5
    await db.insert('categorias', {'nombre': 'Batidos'}); // ID = 6
  }

  int bevCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM bebidas')) ?? 0;
  if (bevCount == 0) {

    // ===============================
    // CATEGORÍA 1 - AGUAS FRESCAS
    // ===============================
    await createBebida(Bebida(
      nombre: "Agua de Jamaica",
      descripcion: "Refrescante y con toque ácido.",
      preparacion: "1. Hierve 1 taza de flor de jamaica en 1 litro de agua por 5 minutos.\n2. Deja reposar la mezcla 15 minutos y cuela el concentrado en una jarra.\n3. Agrega 1-2 litros más de agua (según qué tan concentrada te guste), azúcar al gusto y el jugo de 1 limón. Mezcla y sirve con mucho hielo.",
      imageUrl: "assets/images/aguas_frescas/jamaica.jpg",
      categoria_id: 1
    ));
    await createBebida(Bebida(
      nombre: "Agua de Horchata",
      descripcion: "Tradicional bebida mexicana de arroz y canela.",
      preparacion: "1. Remoja 1 taza de arroz y 1 raja de canela en 2 tazas de agua caliente por al menos 2 horas (idealmente toda la noche).\n2. Licúa el arroz remojado, la canela, 1 lata de leche evaporada, 1 taza de leche normal y azúcar al gusto.\n3. Cuela la mezcla usando una manta de cielo o un colador muy fino sobre una jarra.\n4. Agrega 1 litro más de agua, mezcla y sirve con hielo. Opcional: espolvorea canela en polvo.",
      imageUrl: "assets/images/aguas_frescas/horchata.jpg",
      categoria_id: 1
    ));
    await createBebida(Bebida(
      nombre: "Agua de Tamarindo",
      descripcion: "Sabor agridulce natural.",
      preparacion: "1. Pela 250g de tamarindo y hiérvelo en 1 litro de agua hasta que la pulpa esté muy suave (aprox. 20 min).\n2. Deja enfriar y 'amasa' la pulpa con las manos en el agua para desprenderla de las semillas y venas.\n3. Cuela la mezcla (exprimiendo bien la pulpa) sobre una jarra, agrega 1-2 litros más de agua y endulza al gusto.",
      imageUrl: "assets/images/aguas_frescas/tamarindo.jpg",
      categoria_id: 1
    ));
    await createBebida(Bebida(
      nombre: "Agua de Pepino con Limón y Chía",
      descripcion: "Ligera y muy hidratante.",
      preparacion: "1. Licúa 1 pepino grande (con cáscara y sin semillas), el jugo de 5 limones, 2 litros de agua y azúcar al gusto.\n2. Cuela la mezcla (opcional, si no te gusta la pulpa).\n3. Agrega 3 cucharadas de semillas de chía, revuelve bien y deja reposar en el refrigerador por 10 minutos para que la chía se hidrate.",
      imageUrl: "assets/images/aguas_frescas/pepino_limon.jpg",
      categoria_id: 1
    ));
    await createBebida(Bebida(
      nombre: "Agua de Melón",
      descripcion: "Refrescante y veraniega.",
      preparacion: "1. Parte 1/2 melón en trozos (sin cáscara ni semillas).\n2. Licúa el melón con 1 litro de agua y azúcar al gusto.\n3. Vierte la mezcla en una jarra con 1 litro más de agua, revuelve y sirve con mucho hielo.",
      imageUrl: "assets/images/aguas_frescas/melon.jpg",
      categoria_id: 1
    ));

    // ===============================
    // CATEGORÍA 2 - CALIENTES
    // ===============================
    await createBebida(Bebida(
      nombre: "Café Cappuccino",
      descripcion: "Clásico italiano con espresso y espuma de leche.",
      preparacion: "1. Prepara una carga de espresso (1-2 oz) y viértela en una taza.\n2. Calienta 6 oz de leche fría (en vaporizador de cafetera o en una ollita y luego con un espumador manual).\n3. Bate la leche hasta crear una microespuma densa (que doble su volumen).\n4. Vierte la leche espumada sobre el espresso. La proporción ideal es 1/3 espresso, 1/3 leche vaporizada y 1/3 espuma.",
      imageUrl: "assets/images/calientes/capuchino.jpg",
      categoria_id: 2
    ));
    await createBebida(Bebida(
      nombre: "Chocolate Caliente",
      descripcion: "Bebida dulce y reconfortante.",
      preparacion: "1. Calienta 1 taza de leche en una olla a fuego medio (justo antes de que hierva).\n2. Agrega 2-3 pastillas de chocolate de mesa (o 1/4 taza de chocolate amargo en trozos).\n3. Bate constantemente con un molinillo o batidor de globo hasta que el chocolate se disuelva por completo y se forme una capa de espuma en la superficie.",
      imageUrl: "assets/images/calientes/chocolate.jpg",
      categoria_id: 2
    ));
    await createBebida(Bebida(
      nombre: "Té Chai Latte",
      descripcion: "Té negro con especias y leche.",
      preparacion: "1. En una olla, hierve 1 taza de agua con 1 raja de canela, 3 clavos de olor, 2 vainas de cardamomo y 1 trozo pequeño de jengibre.\n2. Agrega 2 bolsas de té negro, apaga el fuego y deja reposar 5 minutos.\n3. Cuela el té en una taza, añade 1/2 taza de leche caliente (espumada si es posible) y endulza con miel o azúcar.",
      imageUrl: "assets/images/calientes/chai_latte.jpg",
      categoria_id: 2
    ));
    await createBebida(Bebida(
      nombre: "Matcha Latte",
      descripcion: "Té verde japonés energizante.",
      preparacion: "1. Coloca 1-2 cucharaditas de polvo de matcha en un tazón (usando un colador pequeño para evitar grumos).\n2. Agrega 2 oz de agua caliente (no hirviendo, aprox 80°C).\n3. Bate en forma de 'W' o 'M' con un batidor de bambú (chasen) hasta que esté espumoso.\n4. Calienta y espuma 6-8 oz de tu leche preferida y viértela sobre el matcha batido.",
      imageUrl: "assets/images/calientes/matcha_latte.jpg",
      categoria_id: 2
    ));
    await createBebida(Bebida(
      nombre: "Atole de Vainilla",
      descripcion: "Tradicional mexicano, espeso y suave.",
      preparacion: "1. Disuelve 3 cucharadas de maicena (fécula de maíz) en 1/2 taza de leche fría para que no queden grumos.\n2. Calienta 1 litro de leche con 1/2 taza de azúcar (o piloncillo) y 1 cucharada de extracto de vainilla.\n3. Cuando esté a punto de hervir, agrega la maicena disuelta y bate constantemente.\n4. Sigue batiendo a fuego bajo por 5-10 minutos hasta que espese a tu gusto.",
      imageUrl: "assets/images/calientes/vainilla.jpg",
      categoria_id: 2
    ));

    // ===============================
    // CATEGORÍA 3 - CON ALCOHOL
    // ===============================
    await createBebida(Bebida(
      nombre: "Mojito",
      descripcion: "Un cóctel cubano refrescante con menta y ron.",
      preparacion: "1. En un vaso alto, coloca 10-12 hojas de hierbabuena (menta), 2 cucharaditas de azúcar y el jugo de 1/2 lima.\n2. Machaca suavemente con un mortero (sin romper las hojas, solo para liberar el aroma).\n3. Llena el vaso con hielo picado.\n4. Añade 2 oz de ron blanco y rellena el vaso con agua mineral (soda). Remueve suavemente y decora con una ramita de hierbabuena.",
      imageUrl: "assets/images/con_alcohol/mojito.jpeg",
      categoria_id: 3
    ));
    await createBebida(Bebida(
      nombre: "Margarita",
      descripcion: "Un clásico mexicano con tequila y limón.",
      preparacion: "1. Escarcha el borde de una copa: pasa un trozo de lima por el borde y luego pon la copa boca abajo sobre un plato con sal.\n2. En una coctelera con hielo, añade 2 oz de tequila (blanco o reposado), 1 oz de licor de naranja (Triple Sec o Cointreau) y 1 oz de jugo de lima fresco.\n3. Agita vigorosamente por 15 segundos.\n4. Cuela la mezcla sobre la copa escarchada (puede ser con hielo nuevo o sin él).",
      imageUrl: "assets/images/con_alcohol/margarita.jpg",
      categoria_id: 3
    ));
    await createBebida(Bebida(
      nombre: "Piña Colada",
      descripcion: "Cóctel tropical y cremoso de ron, piña y coco.",
      preparacion: "1. En una licuadora, añade 1 taza de hielo.\n2. Vierte 2 oz de ron blanco, 3 oz de jugo de piña (natural es mejor) y 1.5 oz de crema de coco.\n3. Licúa a alta velocidad hasta obtener una consistencia de frappé.\n4. Sirve en un vaso alto (como el 'Hurricane') y decora con una rodaja de piña y una cereza.",
      imageUrl: "assets/images/con_alcohol/pina.jpeg",
      categoria_id: 3
    ));
    await createBebida(Bebida(
      nombre: "Negroni",
      descripcion: "Cóctel italiano fuerte y amargo.",
      preparacion: "1. Llena un vaso corto (tipo 'Old Fashioned') con hielos grandes.\n2. Vierte los ingredientes en partes iguales: 1 oz de Ginebra (Gin), 1 oz de Campari y 1 oz de Vermut Rojo dulce.\n3. Remueve suavemente con una cuchara de cóctel durante 20-30 segundos para enfriar y diluir.\n4. Exprime la cáscara de una naranja sobre el vaso para liberar sus aceites y úsala como decoración.",
      imageUrl: "assets/images/con_alcohol/negroni.jpg",
      categoria_id: 3
    ));
    await createBebida(Bebida(
      nombre: "Whiskey Sour",
      descripcion: "Equilibrio entre dulce y ácido con whiskey.",
      preparacion: "1. Llena una coctelera con hielo.\n2. Añade 2 oz de Whiskey (preferiblemente Bourbon), 1 oz de jugo de limón fresco y 3/4 oz de jarabe de azúcar.\n3. (Opcional para textura sedosa) Añade 1/2 clara de huevo (o aquafaba).\n4. Agita vigorosamente por 15 segundos y cuela sobre un vaso corto con hielo fresco. Decora con una cereza y una rodaja de naranja.",
      imageUrl: "assets/images/con_alcohol/whiskey_sour.jpg",
      categoria_id: 3
    ));

    // ===============================
    // CATEGORÍA 4 - JUGOS CLÁSICOS
    // ===============================
    await createBebida(Bebida(
      nombre: "Jugo de Naranja",
      descripcion: "Clásico desayuno lleno de vitamina C.",
      preparacion: "1. Parte 4-5 naranjas tipo Valencia (son las más dulces) por la mitad.\n2. Usa un exprimidor (manual o eléctrico) para extraer todo el jugo.\n3. Cuela el jugo (si prefieres sin pulpa) y sirve inmediatamente en un vaso frío.",
      imageUrl: "assets/images/jugos_clasicos/naranja.jpg",
      categoria_id: 4
    ));
    await createBebida(Bebida(
      nombre: "Jugo Verde",
      descripcion: "Nutritivo y depurativo.",
      preparacion: "1. Añade a la licuadora 1 taza de agua o jugo de naranja como base líquida.\n2. Agrega 1/2 nopal picado, 1 rebanada de piña, 1 vara de apio, 1 manojo pequeño de perejil y 1 puño de espinaca.\n3. Licúa todo perfectamente por 1-2 minutos.\n4. Cuela (opcional) y sirve inmediatamente.",
      imageUrl: "assets/images/jugos_clasicos/verde.jpg",
      categoria_id: 4
    ));
    await createBebida(Bebida(
      nombre: "Jugo de Zanahoria",
      descripcion: "Dulce y lleno de betacarotenos.",
      preparacion: "1. Lava, desinfecta y corta los extremos de 4-5 zanahorias grandes.\n2. Pasa las zanahorias por un extractor de jugos.\n3. Sirve inmediatamente. Opcional: añade el jugo de 1/2 limón para realzar el sabor y evitar oxidación.",
      imageUrl: "assets/images/jugos_clasicos/zanahoria.jpg",
      categoria_id: 4
    ));
    await createBebida(Bebida(
      nombre: "Jugo de Piña con Menta",
      descripcion: "Refrescante y digestivo.",
      preparacion: "1. Añade a la licuadora 2 tazas de piña fresca (o congelada) en cubos.\n2. Agrega 10-15 hojas de menta fresca y 1 taza de agua fría.\n3. Licúa hasta que esté suave. No es necesario colar. Endulza con miel si la piña no está muy dulce.",
      imageUrl: "assets/images/jugos_clasicos/pina_menta.jpg",
      categoria_id: 4
    ));
    await createBebida(Bebida(
      nombre: "Jugo de Betabel, Zanahoria y Manzana",
      descripcion: "Colorido y antioxidante.",
      preparacion: "1. Lava, desinfecta y pica los ingredientes: 1/2 betabel (remolacha) crudo, 2 zanahorias y 1 manzana verde (con cáscara).\n2. Pasa todos los ingredientes por un extractor de jugos.\n3. Mezcla bien el jugo resultante y sirve inmediatamente.",
      imageUrl: "assets/images/jugos_clasicos/betabel.jpg",
      categoria_id: 4
    ));
    
    // ===============================
    // CATEGORÍA 5 - JUGOS FITNESS
    // ===============================
    await createBebida(Bebida(
      nombre: "Jugo Verde Detox",
      descripcion: "Depurativo con vegetales verdes.",
      preparacion: "1. Pasa por un extractor de jugos: 1 puño grande de espinaca, 1/2 pepino, 2 varas de apio y 1 manzana verde.\n2. Agrega al jugo extraído 1 cm de jengibre fresco (rallado o exprimido) y el jugo de 1/2 limón.\n3. Remueve bien y bebe preferiblemente en ayunas.",
      imageUrl: "assets/images/jugos_fitness/jugo_verde_detox.jpg",
      categoria_id: 5
    ));
    await createBebida(Bebida(
      nombre: "Energía Matutina",
      descripcion: "Activa el cuerpo y la mente.",
      preparacion: "1. Extrae el jugo de 3 zanahorias grandes.\n2. Exprime el jugo de 2 naranjas.\n3. Ralla o exprime 1 cm de jengibre fresco.\n4. Mezcla los tres ingredientes en un vaso, revuelve bien y sirve.",
      imageUrl: "assets/images/jugos_fitness/energia_matutina.jpg",
      categoria_id: 5
    ));
    await createBebida(Bebida(
      nombre: "Metabolismo Activo",
      descripcion: "Estimula la quema de grasa.",
      preparacion: "1. Exprime el jugo de 1 toronja (pomelo) grande.\n2. Licúa 1 taza de piña en cubos con 1/2 taza de agua fría y 5 hojas de menta fresca.\n3. Mezcla el jugo de toronja con la piña licuada en un vaso grande y sirve.",
      imageUrl: "assets/images/jugos_fitness/metabolismo_activo.jpg",
      categoria_id: 5
    ));
    await createBebida(Bebida(
      nombre: "Recuperación Post-Ejercicio",
      descripcion: "Hidratante y rica en electrolitos.",
      preparacion: "1. En la licuadora, pon 2 tazas de sandía fresca y sin semillas.\n2. Añade 1 taza de agua de coco (natural, sin azúcar) y el jugo de 1/2 limón.\n3. Licúa por 30 segundos y sirve bien frío. Perfecto para rehidratar después de entrenar.",
      imageUrl: "assets/images/jugos_fitness/recuperacion_post_ejercicio.jpg",
      categoria_id: 5
    ));
    await createBebida(Bebida(
      nombre: "Antioxidante Power",
      descripcion: "Rico en antioxidantes naturales.",
      preparacion: "1. En la licuadora, pon 1/2 taza de arándanos (blueberries), 1/2 taza de uvas moradas (sin semilla) y 1/4 de betabel crudo picado.\n2. Añade 1 taza de agua fría o té verde frío.\n3. Licúa todo perfectamente hasta que no queden grumos y sirve.",
      imageUrl: "assets/images/jugos_fitness/antioxidante_power.jpg",
      categoria_id: 5
    ));

    // ===============================
    // CATEGORÍA 6 - BATIDOS
    // ===============================
    await createBebida(Bebida(
      nombre: "Banana y Avena",
      descripcion: "Ideal para el desayuno o post entreno.",
      preparacion: "1. En la licuadora, añade 1 plátano (banana), preferiblemente congelado para mejor textura.\n2. Agrega 1/4 taza de hojuelas de avena, 1 taza de leche (de vaca o almendras) y 1 cucharadita de miel o vainilla.\n3. Licúa hasta que esté cremoso y sirve inmediatamente.",
      imageUrl: "assets/images/batidos/banana_avena.jpg",
      categoria_id: 6
    ));
    await createBebida(Bebida(
      nombre: "Fresa y Yogur",
      descripcion: "Cremoso, dulce y natural.",
      preparacion: "1. En la licuadora, añade 1 taza de fresas (frescas o congeladas).\n2. Agrega 1/2 taza de yogur griego natural (sin azúcar) para cremosidad y proteína.\n3. Añade 1/2 taza de leche o agua para aligerar y 1 cucharadita de miel (opcional). Licúa hasta que esté suave.",
      imageUrl: "assets/images/batidos/fresa_yogur.jpg",
      categoria_id: 6
    ));
    await createBebida(Bebida(
      nombre: "Mango Tropical",
      descripcion: "Exótico y refrescante.",
      preparacion: "1. En la licuadora, pon 1 taza de mango congelado en cubos.\n2. Añade 1/2 taza de piña (fresca o congelada) y 1 taza de leche de coco (de cartón, para beber).\n3. Licúa hasta obtener una consistencia cremosa y espesa, como un helado suave.",
      imageUrl: "assets/images/batidos/mango_tropical.jpg",
      categoria_id: 6
    ));
    await createBebida(Bebida(
      nombre: "Chocolate Proteico",
      descripcion: "Energético y con alto contenido proteico.",
      preparacion: "1. En la licuadora, pon 1 plátano congelado y 1.5 tazas de leche (almendra o vaca).\n2. Añade 1 scoop (cucharada medidora) de proteína en polvo sabor chocolate o vainilla.\n3. Agrega 1 cucharada de cacao en polvo (sin azúcar) y 1 cucharada de mantequilla de maní (cacahuate).\n4. Licúa bien y sirve.",
      imageUrl: "assets/images/batidos/chocolate_proteico.jpg",
      categoria_id: 6
    ));
    await createBebida(Bebida(
      nombre: "Verde Energético",
      descripcion: "Refrescante y rico en fibra.",
      preparacion: "1. En la licuadora, pon 1 puño grande de espinaca fresca (no sabe a nada, solo da color y nutrientes).\n2. Añade 1/2 manzana verde, 1/2 pepino, 1 taza de piña y 1.5 tazas de agua de coco.\n3. Licúa a alta velocidad hasta que todo esté perfectamente integrado y no queden trozos de hojas. Sirve frío.",
      imageUrl: "assets/images/batidos/verde_energetico.jpg",
      categoria_id: 6
    ));
    
  }
}

}