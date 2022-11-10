
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

import '../model/new.dart';

class LocalDatabase {
  final String tableName = 'bookmarks';

  late Future<Database> _database;

  bool _initialized = false;

  /// like singleton
  static final LocalDatabase _localDatabase = LocalDatabase._internal();

  factory LocalDatabase() {
    return _localDatabase;
  }

  LocalDatabase._internal();
  ///

  Future<void> initialize() async {
    if (!_initialized) {
      WidgetsFlutterBinding.ensureInitialized();

      final String dbPath = await getDatabasesPath();
      _database = openDatabase(
        join(dbPath, 'bookmarks_database.db'),
        onCreate: (db, version) async {
          return db.execute(
            'CREATE TABLE $tableName('
                'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, url TEXT, '
                'title TEXT, author TEXT, content TEXT, urlToImage TEXT, '
                'description TEXT, publishedAt TEXT'
                ')',
          );
        },
        version: 1,
      );

      _initialized = true;
    }
  }

  Future<void> insertNew(NewModel newModel) async {
    if (_initialized) {
      await _insert(newModel);
    } else {
      await initialize();
      await _insert(newModel);
    }
  }

  Future<void> _insert(NewModel newModel) async {
    final db = await _database;

    await db.insert(
      tableName,
      newModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NewModel>> getNewsInList() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      final Map<String, dynamic> item = maps[i];
      return NewModel.fromJson(item, isBookmark: true);
    });
  }

  Future<Map<String, NewModel>> getNewsInMap() async {
    final db = await _database;
    final Map<String, NewModel> result = {};
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    for (final Map<String,dynamic> map in maps) {
      result[map['title']] = NewModel.fromJson(map, isBookmark: true);
    }

    return result;
  }

  Future<void> updateNew(NewModel newModel) async {
    if (_initialized) {
      await _update(newModel);
    } else {
      await initialize();
      await _update(newModel);
    }
  }

  Future<void> _update(NewModel newModel) async {
    final db = await _database;

    if (newModel.id != null) {
      await db.update(
        tableName,
        newModel.toMap(),
        where: 'id = ?',
        whereArgs: [newModel.id],
      );

      return;
    }

    await db.update(
      tableName,
      newModel.toMap(),
      where: 'title = ?',
      whereArgs: [newModel.title],
    );
  }

  Future<void> deleteNew(NewModel newModel) async {
    if (_initialized) {
      await _delete(newModel);
    } else {
      await initialize();
      await _delete(newModel);
    }
  }

  Future<void> _delete(NewModel newModel) async {
    final db = await _database;

    if (newModel.id != null) {
      await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [newModel.id],
      );

      return;
    }

    await db.delete(
      tableName,
      where: 'title = ?',
      whereArgs: [newModel.title],
    );
  }
}
