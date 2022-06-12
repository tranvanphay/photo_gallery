import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery/model/item.dart';
import 'package:photo_gallery/model/items.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDbProvider {
  static final SQLiteDbProvider instance = SQLiteDbProvider._instance();
  static Database? _database;

  SQLiteDbProvider._instance();

  Future<Database> get database async => _database ??= await initDB();

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Photos.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Photos ("
          "remoteID INTEGER PRIMARY KEY,"
          "thumnail TEXT,"
          "linkDownload TEXT,"
          "photoDate TEXT,"
          "photoDateTime TEXT,"
          "serverDate TEXT"
          ")");
    });
  }

  insert({required List<Item> photos}) async {
    final db = await database;
    var batch = db.batch();
    photos.forEach((element) async {
      Map<String, dynamic> row = {
        "remoteID": element.remoteId,
        "thumnail": element.thumnail,
        "linkDownload": element.linkDownload,
        "photoDate": element.photoDate,
        "photoDateTime": element.photoDateTime,
        "serverDate": element.serverDate,
      };
      batch.insert("Photos", row, conflictAlgorithm: ConflictAlgorithm.replace);
      log("insert success Photos ${element.remoteId}");
    });
    var result = await batch.commit(noResult: true);
    return result;
  }

  delete(String key) async {
    final db = await database;
    db.delete("Photos", where: "remoteID = ?", whereArgs: [key]);
  }

  Future<List<String>> getTitle() async {
    final db = await database;
    final result = await db.query("Photos",
        groupBy: "photoDate", orderBy: "photoDate DESC");
    final List<String> titles = [];
    result.forEach((element) {
      titles.add(element['photoDate'] as String);
    });

    return result.isNotEmpty ? titles : [];
  }

  Future<List<Item>> getPhotoByDate(String date) async {
    final db = await database;
    var result = await db.query("Photos",
        where: "photoDate = ?",
        whereArgs: [date],
        orderBy: "photoDateTime DESC");
    List<Item> _items = [];
    result.forEach((element) {
      _items.add(Item(
          remoteId: element['remoteID'] as int,
          thumnail: element['thumnail'] as String,
          linkDownload: element['linkDownload'] as String,
          photoDate: element['photoDate'] as String,
          photoDateTime: element['photoDateTime'] as String,
          serverDate: element['serverDate'] as String));
    });
    return _items;
  }
}
