import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class Avistamiento {
  final String id;
  final String especie;
  final double confianza;
  final String fotoPath;
  final double latitud;
  final double longitud;
  final String fecha;
  final bool sincronizado;

  Avistamiento({
    required this.id,
    required this.especie,
    required this.confianza,
    required this.fotoPath,
    required this.latitud,
    required this.longitud,
    required this.fecha,
    this.sincronizado = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'especie': especie,
    'confianza': confianza,
    'fotoPath': fotoPath,
    'latitud': latitud,
    'longitud': longitud,
    'fecha': fecha,
    'sincronizado': sincronizado ? 1 : 0,
  };

  factory Avistamiento.fromMap(Map<String, dynamic> map) => Avistamiento(
    id: map['id'],
    especie: map['especie'],
    confianza: map['confianza'],
    fotoPath: map['fotoPath'],
    latitud: map['latitud'],
    longitud: map['longitud'],
    fecha: map['fecha'],
    sincronizado: map['sincronizado'] == 1,
  );
}

class DatabaseService {
  static Database? _db;
  static const _dbName = 'aves.db';
  static const _tableName = 'avistamientos';
  static const _uuid = Uuid();

  static Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            especie TEXT NOT NULL,
            confianza REAL NOT NULL,
            fotoPath TEXT NOT NULL,
            latitud REAL NOT NULL,
            longitud REAL NOT NULL,
            fecha TEXT NOT NULL,
            sincronizado INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  // RF08: Guardar avistamiento local
  static Future<String> guardarAvistamiento({
    required String especie,
    required double confianza,
    required String fotoPath,
    required double latitud,
    required double longitud,
  }) async {
    final database = await db;
    final id = _uuid.v4(); // RNF06: UUID único
    final avistamiento = Avistamiento(
      id: id,
      especie: especie,
      confianza: confianza,
      fotoPath: fotoPath,
      latitud: latitud,
      longitud: longitud,
      fecha: DateTime.now().toIso8601String(),
    );
    await database.insert(
      _tableName,
      avistamiento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Avistamiento>> obtenerTodos() async {
    final database = await db;
    final maps = await database.query(_tableName, orderBy: 'fecha DESC');
    return maps.map((m) => Avistamiento.fromMap(m)).toList();
  }

  static Future<List<Avistamiento>> obtenerNosincronizados() async {
    final database = await db;
    final maps = await database.query(
      _tableName,
      where: 'sincronizado = ?',
      whereArgs: [0],
    );
    return maps.map((m) => Avistamiento.fromMap(m)).toList();
  }

  static Future<void> marcarSincronizado(String id) async {
    final database = await db;
    await database.update(
      _tableName,
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> eliminar(String id) async {
    final database = await db;
    await database.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
