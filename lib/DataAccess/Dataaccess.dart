import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'favourite.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favourite (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT
      )
    ''');
  }

  Future<int> insertData(String data) async {
    Database db = await database;
    return await db.insert('favourite', {'data': data});
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    Database db = await database;
    return await db.query('favourite');
  }

  Future<int> insertFavourite(int characterId, String data) async {
    Database db = await database;
    return await db.insert('favourite', {'id': characterId, 'data': data});
  }

  Future<List<Map<String, dynamic>>> getAllFavourites() async {
    Database db = await database;
    return await db.query('favourite');
  }
}
