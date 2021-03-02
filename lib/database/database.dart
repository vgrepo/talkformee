import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/rjecnik.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database
  String rjecnikTable = 'Rjecnik_table';
  String colId = 'id';
  String colGrp = 'grp';
  String colTitle = 'title';
  String colIcon = 'icon';
  String colIconTitle = 'icontitle';
  String colLng = 'lng';
  String colDefult = 'def';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    //int _nRec;
    if (_database == null) {
      _database = await initializeDatabase();
      var _nRec = await getCount();
      if (_nRec == 0) {
        insertWord();
        insertSentence();
      }
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'rjecnik.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''CREATE TABLE $rjecnikTable(
            $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
            $colGrp TEXT,
            $colLng TEXT,
            $colTitle TEXT, 
            $colIcon TEXT,
            $colIconTitle TEXT,
            $colDefult INTEGER 
            )''');
    print("create table");
  }

  // Fetch Operation: Get all  objects from database
  Future<List<Map<String, dynamic>>> getRjecnikMapList(String filter) async {
    Database db = await this.database;
    var result = await db.query(rjecnikTable,
        where: 'grp=?', whereArgs: [filter], orderBy: '$colId ASC');
    return result;
  }

  // Insert Operation: Insert a Rjecnik object to database
  Future<int> insertRjecnik(Rjecnik rjecnik) async {
    print('insertRjecnik: ' + rjecnik.title);
    Database db = await this.database;
    var result = await db.insert(rjecnikTable, rjecnik.toMap());
    return result;
  }

  // Update Operation: Update a Rjecnik object and save it to database
  Future<int> updateRjecnik(Rjecnik rjecnik) async {
    var db = await this.database;
    var result = await db.update(rjecnikTable, rjecnik.toMap(),
        where: '$colId = ?', whereArgs: [rjecnik.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteRjecnik(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $rjecnikTable WHERE $colId = $id');
    return result;
  }

  // Get number of  objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $rjecnikTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Rjecnik List' [ List<Note> ]
  Future<List<Rjecnik>> getRjecnikList(String filter) async {
    var rjecnikMapList =
        await getRjecnikMapList(filter); // Get 'Map List' from database
    int count =
        rjecnikMapList.length; // Count the number of map entries in db table

    List<Rjecnik> rjecnikList = List<Rjecnik>();
    // For loop to create a 'Rjecnik List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      rjecnikList.add(Rjecnik.fromMapObject(rjecnikMapList[i]));
    }
    return rjecnikList;
  }

  void insertWord() {
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','da')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','ne')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','hoću')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','neću')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','jesi')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','nisi')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','kava')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','pivo')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','rakija')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','želim')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','želite')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','kako')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('word','hr','idemo')");
  }

  void insertSentence() {
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('sentences','hr','Što ćeš popiti?')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('sentences','hr','Želi te li kavu?')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('sentences','hr','Idemo u trgovinu?')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('sentences','hr','Idemo u goste?')");
    _database.rawInsert(
        "Insert into Rjecnik_table (grp,lng,title) values('sentences','hr','Kupi mi ')");
  }
}
