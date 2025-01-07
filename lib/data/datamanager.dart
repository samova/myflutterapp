import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Datamanager {
  static final Datamanager instance = Datamanager._init();
  static Database? _database;

  Datamanager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _executeSqlFromFile(Database db) async {
    final String filePath = 'packages/mymoney/data/CreateDB.sql';
    final String sql = await rootBundle.loadString(filePath);
    final List<String> sqlStatements = sql.split(';');

    for (final String statement in sqlStatements) {
      if (statement.trim().isNotEmpty) {
        await db.execute(statement);
      }
    }
  }

  Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'mymoney.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await _executeSqlFromFile(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < newVersion) {
          await _executeSqlFromFile(db);
        }
      },
    );
  }

  Future<int> addItem(String table, Map<String, dynamic> map) async {
    final db = await instance.database;
    return await db.insert(table, map);
  }

  Future<List<Map<String, dynamic>>> getItems(String table, String catetype) async {
    final db = await instance.database;
    return await db.query(table, where: 'catetype = ?', whereArgs: [catetype]);
  }

  Future<List<Map<String, dynamic>>> getAllItems(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  Future<int> deleteItem(String table, Map<String, dynamic> map) async {
    final db = await instance.database;
    final String whereClause = map.keys.map((key) => '$key = ?').join(' AND ');
    final List<dynamic> whereArgs = map.values.toList();
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}