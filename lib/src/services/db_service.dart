import 'dart:io';

import '../models/commute.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/stop.dart';
import 'package:path_provider/path_provider.dart';

class DBService {
  DBService._();
  static final DBService db = DBService._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "mbta.db");
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: populateDb);
  }

  void populateDb(Database database, int version) async {
    await database.execute("CREATE TABLE SavedStops ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "latitude TEXT,"
        "longitude TEXT,"
        "platform_name TEXT,"
        "direction_name TEXT,"
        "description TEXT"
        ")");
    await database.execute("CREATE TABLE Commute ("
        "id INTEGER PRIMARY KEY,"
        "id_one INTEGER,"
        "name_one TEXT,"
        "latitude_one TEXT,"
        "longitude_one TEXT,"
        "platform_name_one TEXT,"
        "direction_name_one TEXT,"
        "description_one TEXT,"
        "id_two INTEGER,"
        "name_two TEXT,"
        "latitude_two TEXT,"
        "longitude_two TEXT,"
        "platform_name_two TEXT,"
        "direction_name_two TEXT,"
        "description_two TEXT,"
        "arrival_time TEXT,"
        "departure_time TEXT"
        ")");
  }

  Future<int> saveStop(Stop stop) async {
    final db = await database;
    var result = await db.insert("SavedStops", stop.toJson());
    return result;
  }

  Future<List<Stop>> getAllSavedStops() async {
    final db = await database;
    var result = await db.query("SavedStops", columns: [
      "id",
      "name",
      "latitude",
      "longitude",
      "platform_name",
      "direction_name",
      "description"
    ]);

    return result.map((e) {
      return Stop.fromDb(e);
    }).toList();
  }

  Future<int> updateSavedStop(Stop stop) async {
    final db = await database;
    return await db.update("SavedStops", stop.toJson(),
        where: "id = ?", whereArgs: [stop.id]);
  }

  Future<int> removeSavedStop(int id) async {
    final db = await database;
    return await db.delete("SavedStops", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> saveCommute(Commute commute) async {
    final db = await database;
    var result = await db.insert("Commute", commute.toJson());
    return result;
  }

  Future<Commute> getCommute() async {
    final db = await database;
    var result = await db.query("Commute", columns: [
      "id",
      "id_one",
      "name_one",
      "latitude_one",
      "longitude_one",
      "platform_name_one",
      "direction_name_one",
      "description_one",
      "id_two",
      "name_two",
      "latitude_two",
      "longitude_two",
      "platform_name_two",
      "direction_name_two",
      "description_two",
      "arrival_time",
      "departure_time",
    ]);

    final listOfOne = result.map((e) {
      return Commute.fromJson(e);
    }).toList();
    if (listOfOne == null || listOfOne.length == 0) {
      return null;
    }
    return listOfOne[0];
  }

  Future<int> updateCommute(Commute commute) async {
    final db = await database;
    return await db.update("Commute", commute.toJson(),
        where: "id = ?", whereArgs: [commute.id]);
  }

  Future<int> removeCommute() async {
    final db = await database;
    return await db.delete("Commute", where: 'id = ?', whereArgs: [1]);
  }
}
