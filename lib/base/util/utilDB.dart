import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class utilDB {
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "tempStorage" (
        "id"	INTEGER,
        "k"	TEXT,
        "v"	TEXT,
        "date"	TEXT,
        PRIMARY KEY("id" AUTOINCREMENT)
      )
    ''');
  }

  Future _connDb() async {
    final databasePath = await getDatabasesPath();
    String path = join(databasePath, 'database.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (Database db) => {},
      onCreate: _onCreate,
      onUpgrade: (Database db, int oldVersion, int newVersion) => {},
    );
  }

  Future<List<Map<String, Object?>>> select(selField, [where = ' 1'] ) async{
    // var datas = await db.select("v", "k='name' order by id desc limit 1 ");
    final db = await _connDb();
    return await db.rawQuery('SELECT ${selField} FROM tempStorage WHERE ${where}');
  }

  Future insert(setDatas) async {
    // db.insert({'k':'name', 'v':'overlay'});
    final db = await _connDb();
    await db.insert(
      'tempStorage',
      setDatas,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future update(setDatas, where, datas) async {
    //db.update({'v':'appbase_test'},'id=?', [2]);
    final db = await _connDb();
    await db.update(
      'tempStorage',
      setDatas,
      where: where,
      whereArgs: datas,
    );
  }

  Future del(where, datas) async {
    //db.del('id=?', [2]);
    final db = await _connDb();
    await db.delete(
      'tempStorage',
      where: where,
      whereArgs: datas,
    );
  }
}
final utilDB db = utilDB();