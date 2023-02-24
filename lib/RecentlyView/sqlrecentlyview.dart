import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class SQLHelper1 {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE itemee1(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        Name TEXT,
        LocationName TEXT,
        Image TEXT,
        Description TEXT,
        lati TEXT,
        long TEXT,
        Connector TEXT,
        Types TEXT,
        Kwh TEXT,
        Payment Text,
        Hour TEXT,
        Parking TEXT,
        Phone TEXT,
        App TEXT,
        Play TEXT,
        Amni TEXT,
        Addrses TEXT,
        Specification TEXT,
        Brand Text,
        Model TEXT,
        Insta Text,
        Fb TEXT,
        web TEXT,
        
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbtecuhe1.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(
      String Name,
      String? LocationName,
      String Image,
      String Description,
      String lati,
      String long,
      String? Connector,
      String Types,
      String Kwh,
      String Payment,
      String Hour,
      String? Parking,
      String Phone,
      String App,
      String Play,
      String Amni,
      String? Addrses,
      String Specification,
      String Brand,
      String? Model,
      String Insta,
      String Fb,
      String? web) async {
    final db = await SQLHelper1.db();

    final data = {
      'Name': Name,
      'LocationName': LocationName,
      'Image': Image,
      'Description': Description,
      'lati': lati,
      'long': long,
      'Connector': Connector,
      'Types': Types,
      'Kwh': Kwh,
      'Payment': Payment,
      'Hour': Hour,
      'Parking': Parking,
      'Phone': Phone,
      'App': App,
      'Play': Play,
      'Amni': Amni,
      'Addrses': Addrses,
      'Specification': Specification,
      'Brand': Brand,
      'Model': Model,
      'Insta': Insta,
      'Fb': Fb,
      'web': web
    };
    final id = await db.insert('itemee1', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper1.db();
    return db.query('itemee1', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper1.db();
    return db.query('itemee1', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper1.db();
    try {
      await db.delete("itemee1", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
