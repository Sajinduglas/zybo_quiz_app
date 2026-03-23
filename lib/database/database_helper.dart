import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/quiz_result.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz_results.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE quiz_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        questionIndex INTEGER,
        questionText TEXT,
        score INTEGER,
        timeTaken INTEGER
      )
    ''');
  }

  Future<int> insertResult(QuizResult result) async {
    final db = await instance.database;
    return await db.insert('quiz_results', result.toMap());
  }

  Future<List<QuizResult>> getAllResults() async {
    final db = await instance.database;
    final maps = await db.query('quiz_results');
    return maps.map((json) => QuizResult.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
