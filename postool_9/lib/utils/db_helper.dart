import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<Database> database;

  static init() async {
    database = openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'buffalo_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        print("Creating Database ...");
        // Run the CREATE TABLE statement on the database.
        db.execute(
          "CREATE TABLE sale(id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL, mode TEXT NOT NULL)",
        );
        db.execute(
          "CREATE TABLE saleDetail(id INTEGER PRIMARY KEY, barCode TEXT NOT NULL, quantity INTERGER NOT NULL, head INTERGER NOT NULL)",
        );
      },
      // TEXT INTERGER REAL BLOB
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 5,
    );
  }
}
