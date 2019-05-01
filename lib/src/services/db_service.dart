import '../models/commute.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/stop.dart';

class DBService {
  Database db;

  createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'mbta.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  void populateDb(Database database, int version) async {
    await database.execute("CREATE TABLE SavedStops ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "latitude TEXT,"
        "longitude TEXT,"
        "platform_name TEXT,"
        "direction_name TEXT"
        ")");
    await database.execute("CREATE TABLE Commute ("
        "id INTEGER PRIMARY KEY,"
        "id_one INTEGER,"
        "name_one TEXT,"
        "latitude_one TEXT,"
        "longitude_one TEXT,"
        "platform_name_one TEXT,"
        "direction_name_one TEXT,"
        "id_two INTEGER,"
        "name_two TEXT,"
        "latitude_two TEXT,"
        "longitude_two TEXT,"
        "platform_name_two TEXT,"
        "direction_name_two TEXT"
        ")");
  }

  Future<int> saveStop(Stop stop) async {
    var result = await db.insert("SavedStops", stop.toJson());
    return result;
  }

  Future<List<Stop>> getAllSavedStops() async {
    var result = await db.query("SavedStops", columns: [
      "id",
      "name",
      "latitude",
      "longitude",
      "platform_name",
      "direction_name"
    ]);

    return result.map((e) {
      return Stop.fromJson(e);
    }).toList();
  }

  Future<int> updateSavedStop(Stop stop) async {
    return await db.update("SavedStops", stop.toJson(),
        where: "id = ?", whereArgs: [stop.id]);
  }

  Future<int> removeSavedStop(int id) async {
    return await db.delete("SavedStops", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createCommute(Stop stop1, Stop stop2) async {
    Commute commute = new Commute(1, stop1, stop2);
    var result = await db.insert("SavedStops", commute.toJson());
    return result;
  }

  Future<Commute> getCommute() async {
    var result = await db.query("Commute", columns: [
      "id",
      "id_one",
      "name_one",
      "latitude_one",
      "longitude_one",
      "platform_name_one",
      "direction_name_one",
      "id_two",
      "name_two",
      "latitude_two",
      "longitude_two",
      "platform_name_two",
      "direction_name_two",
    ]);

    return result.map((e) {
      return Commute.fromJson(e);
    }).toList()[0];
  }

  Future<int> updateCommute(Commute commute) async {
    return await db.update("Commute", commute.toJson(),
        where: "id = ?", whereArgs: [commute.id]);
  }

  Future<int> removeCommute(int id) async {
    return await db.delete("Commute", where: 'id = ?', whereArgs: [id]);
  }
}
