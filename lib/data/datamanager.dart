import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Datamanager {
  late Database db;

  Datamanager() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mymoney.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''create table catemaster ( catetype text not null,category text not null,icon integer not null,budget integer not null,primary key (catetype, category))''');
      await db.execute('''create table recorddata ( 
        recordid text primary key, 
        catetype text not null,
        category text not null, 
        amount integer not null, 
        date text not null, 
        note text not null)''');
    });
  }

  Future<int> addItem(String table, Map<String, dynamic> map) async {
      return await db.insert(table, map);
  }

  Future<List<Map>> getItems(String table, String catetype) async {
    List<Map> maps = await db.query(table,
        columns: ['*'],
        where: 'catetype = ?',
        whereArgs: [catetype]);
    return maps;
  }

  Future<List<Map>> getAllItems(String table) async {
    List<Map> maps = await db.query(table,
        columns: ['*']);
    return maps;
  }

  Future<int> deleteItem(String table, Map<String,dynamic> map) async {
    String whereClause = map.keys.map((key) => '$key = ?').join(' AND ');
    List<dynamic> whereArgs = map.values.toList();
    return await db.delete(table, 
          where: whereClause,
          whereArgs: whereArgs);
  }
  
  Future close() async => db.close();
}