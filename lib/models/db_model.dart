import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import './todo_model.dart';
import './user_model.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class DatabaseConnect {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todo3_backup.db");

    // Check if the database exists
    bool dbExists = await databaseExists(path);

    if (!dbExists) {
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "todo3_backup.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path, version: 1);
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> insertTodo(Todo todo) async {
    final db = await database;
    await db.insert(
      'todos', // Fixed the typo here (was 'todo')
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> deleteUser(User user) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id == ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteTodo(Todo todo) async {
    final db = await database;
    await db.delete(
      'todos', // Fixed the typo here (was 'todo')
      where: 'id == ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteUserTodos(int userId) async {
    final db = await database;
    await db.delete(
      'todos', // Fixed the typo here (was 'todo')
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Todo>> getTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        title: maps[i]['title'] ?? '',
        tamount: maps[i]['tamount'],
        pamount: maps[i]['pamount'],
        lamount: maps[i]['lamount'],
        creationDate: DateTime.parse(maps[i]['creationDate']),
        userId: maps[i]['userId'],
      );
    });
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    List<Map<String, dynamic>> items =
        await db.query('users', orderBy: 'id DESC');
    return List.generate(
      items.length,
      (i) => User(
        id: items[i]['id'],
        name: items[i]['name'],
        address: items[i]['address'],
        mob: items[i]['mob'],
      ),
    );
  }

  Future<List<Todo>> getUserTodos(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> items = await db.query(
      'todos', // Fixed the typo here (was 'todo')
      where: 'userId == ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return List.generate(
      items.length,
      (i) => Todo(
        id: items[i]['id'],
        userId: items[i]['userId'],
        title: items[i]['title'] ?? '',
        tamount: items[i]['tamount'],
        pamount: items[i]['pamount'],
        lamount: items[i]['lamount'],
        creationDate: DateTime.parse(items[i]['creationDate']),
      ),
    );
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> updateTodo(Todo todo) async {
    final db = await database;
    await db.update(
      'todos', // Fixed the typo here (was 'todo')
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> backupDatabase() async {
    final dbpath = await getDatabasesPath();
    const dbname = 'todo3_backup.db';
    final path = join(dbpath, dbname);
    final directory = await getApplicationDocumentsDirectory();
    final backupDirectory = Directory(join(directory.path, 'backup'));

    if (!(await backupDirectory.exists())) {
      await backupDirectory.create(recursive: true);
    }

    final backupPath = join(backupDirectory.path, 'todo4_backup.db');
    final dbFile = File(path);

    if (await dbFile.exists()) {
      await dbFile.copy(backupPath);
    }
  }
}
