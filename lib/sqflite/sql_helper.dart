import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      "zwel_test.db",
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> createTables(sql.Database database) async {
    // table name is items
    await database.execute("""CREATE TABLE items(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
""");
  }

  static Future<int> createItem(String title, String description) async {
    // db = database with tables
    final db = await SQLHelper.db();

    final data = {'title': title, 'description': description};

    final id = await db.insert("items", data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    // id is last inserted row of data
    return id;
  }

  //get all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();

    return db.query('items', orderBy: "id");
  }

  //get one item
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // update item
  static Future<int> updateItem(
      int id, String title, String description) async {
    final db = await SQLHelper.db();

    final data = {
      "title": title,
      "description": description,
      "createdAt": DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);

    return result;
  }

  // delete item
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Somthing wromg! : see => $err");
    }
  }

  // static Future<void> deleteAll() async {
  //   final db = await SQLHelper.db();

  //   db.close();
  // }
}
