import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Datamanager {
  late Database db;

  Future<void> initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mymoney.db');
    db = await openDatabase(path, version: 3, 
      onCreate: (Database db, int version) {
        db.execute('''
          CREATE TABLE catemaster (
            cateid TEXT PRIMARY KEY,
            catetype TEXT NOT NULL,
            category TEXT NOT NULL,
            icon TEXT NOT NULL,
            budget INTEGER NOT NULL
          )
        ''');
        db.execute('''
          CREATE TABLE recorddata (
            recordid TEXT PRIMARY KEY,
            catetype TEXT NOT NULL,
            category TEXT NOT NULL,
            amount INTEGER NOT NULL,
            date TEXT NOT NULL,
            note TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion){
        if (oldVersion < newVersion) {
          db.execute('DROP TABLE IF EXISTS catemaster');
          db.execute('DROP TABLE IF EXISTS recorddata');
          db.execute('''
            CREATE TABLE catemaster (
              cateid TEXT PRIMARY KEY,
              catetype TEXT NOT NULL,
              category TEXT NOT NULL,
              icon TEXT NOT NULL,
              budget INTEGER NOT NULL
            )
          ''');
          db.execute('''
            CREATE TABLE recorddata (
              recordid TEXT PRIMARY KEY,
              catetype TEXT NOT NULL,
              category TEXT NOT NULL,
              amount INTEGER NOT NULL,
              date TEXT NOT NULL,
              note TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future<int> addItem(String table, Map<String, dynamic> map) async {
    return await db.insert(table, map);
  }

  Future<List<Map<String, dynamic>>> getItems(String table, String catetype) async {
    return await db.query(table, where: 'catetype = ?', whereArgs: [catetype]);
  }

  Future<List<Map<String, dynamic>>> getAllItems(String table) async {
    return await db.query(table);
  }

  Future<int> deleteItem(String table, Map<String, dynamic> map) async {
    String whereClause = map.keys.map((key) => '$key = ?').join(' AND ');
    List<dynamic> whereArgs = map.values.toList();
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  Future<void> close() async {
    await db.close();
  }
}