import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  /// Метод получает базу данных, а в случае, если ее нет, создает и затем получает.√
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    await documentsDirectory.create(recursive: true);

    final path = await getDatabasesPath();

    final dbPath =
        Platform.isMacOS
            ? join(documentsDirectory.path, 'greenhouse.db')
            : join(path, 'greenhouse.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE greenhouse (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        zonesJson TEXT NOT NULL
      )
    ''');
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 1) {
      await _createDatabase(db, newVersion);
    }
  }
}
