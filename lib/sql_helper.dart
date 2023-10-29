import 'package:sqflite/sqflite.dart' as sql;

//create db for hike
// Name of hike (e.g. "Snowdon•, "Trosley Country park", etc.) — Required field - string
// Location - Required field - string
// Date of the hike - Required field -string
// Parking available (i.e. "Yes" or "NO") - Required field -boolean
// Length the hike - Required field - string
// Level of difficulty - Required field - string
// Description — Optional field - string

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase('${dbPath}hikes.db', onCreate: (db, version) {
      db.execute(
          'CREATE TABLE hikes(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, location TEXT, date TEXT, parking TEXT, length TEXT, difficulty TEXT, description TEXT)');
      db.execute(
          'CREATE TABLE observations(id INTEGER PRIMARY KEY AUTOINCREMENT, hikeId INTEGER, observation TEXT NOT NULL, time TEXT NOT NULL, comments TEXT, FOREIGN KEY (hikeId) REFERENCES hikes (id) ON DELETE CASCADE)');
    }, version: 1);

  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> delete(String table, int id) async {
    final db = await DBHelper.database();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAll(String table) async {
    final db = await DBHelper.database();
    db.delete(table);
  }

  static Future<void> update(String table, Map<String, Object> data, int id) async {
    final db = await DBHelper.database();
    db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getHike(String table, int id) async {
    final db = await DBHelper.database();
    return db.query(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getObservationsForHike(int hikeId) async {
    final db = await DBHelper.database();
    return db.query('observations', where: 'hikeId = ?', whereArgs: [hikeId]);
  }

  static Future<void> deleteObservationsForHike(int hikeId) async {
    final db = await DBHelper.database();
    db.delete('observations', where: 'hikeId = ?', whereArgs: [hikeId]);
  }

  static Future<void> updateObservation(Map<String, Object> data, int id) async {
    final db = await DBHelper.database();
    db.update('observations', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteObservation(int id) async {
    final db = await DBHelper.database();
    db.delete('observations', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getObservation(int id) async {
    final db = await DBHelper.database();
    return db.query('observations', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> insertObservation(Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert('observations', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }
}