import 'dart:convert';

import 'package:notesapp/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path + "notes.db";
    final database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("DROP TABLE IF EXISTS Note");
    print("oncreate");
    await db.execute(
        "CREATE TABLE Note(noteID TEXT, noteTitle TEXT, noteContent TEXT, createdDateTime TEXT, lastEditedDateTime TEXT)");
    print("Table is created");
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    var db = await database;
    var result = await db.query('Note');
    return result;
  }

  Future getNote(String noteID) async {
    var db = await database;
    List<Map> result = await db.query('Note', where: 'noteID = ?', whereArgs: [noteID],distinct: true);
    print(result.toString() + "result");
    return jsonEncode(result);
  }

  Future saveNote(Note note) async {
    var db = await database;
    bool _isAvailable = true;
    var res;
    List<Map> result = await db.rawQuery('SELECT * FROM Note WHERE noteID=?', [note.noteID]);
    result.forEach((row) => _isAvailable = false);
    if (_isAvailable) res = await db.insert("Note", note.toMap());
    return res;
  }

  Future updateNote(Note note) async {
    final db = await database;
    await db.update('Note', note.toMap(), where: "noteID = ?", whereArgs: [note.noteID]);
  }

  Future deleteNote(String noteID) async {
    final db = await database;
    var res = await db.delete('Note', where: "noteID = ?", whereArgs: [noteID]);
    print(res.toString());
    return res;
  }
}
