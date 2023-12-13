import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/CategoryEntry.dart';
import 'package:todo_app/model/TodoEntry.dart';

class SQLiteStorage {
  static final SQLiteStorage _instance = SQLiteStorage._internal();
  late Future<Database> _database;

  factory SQLiteStorage() {
    return _instance;
  }

  SQLiteStorage._internal() {
    WidgetsFlutterBinding.ensureInitialized();

    _initDatabase();
  }

  void _initDatabase() async {
    _database = openDatabase(join(await getDatabasesPath(), 'todo_list.db'));
  }

  Future<void> createCategory(CategoryEntry category) async {
    final db = await _database;
    return db.execute(
        'CREATE TABLE IF NOT EXISTS $category(id TEXT PRIMARY KEY, name TEXT, deadline TEXT, isDone BOOLEAN)');
  }

  Future<void> deleteCategory(CategoryEntry category) async {
    final db = await _database;
    return db.execute("DROP TABLE IF EXISTS $category");
  }

  Future<void> addTodo(TodoEntry todo, String categoryName) async {
    final db = await _database;

    await db.insert(categoryName, todo.toMap());
  }

  Future<void> deleteTodo(String todo_id, String categoryName) async {
    final db = await _database;
    db.delete(categoryName, where: 'id = ?', whereArgs: [todo_id]);
  }

  Future<List<TodoEntry>> getTodos(String categoryName) async {
    final db = await _database;

    final List<Map<String, dynamic>> todoMaps = await db.query(categoryName);
    return List.generate(
        todoMaps.length,
        (index) => TodoEntry(
            name: todoMaps[index]['name'] as String,
            deadline: DateTime.parse(todoMaps[index]['deadline']),
            id: todoMaps[index]['id'] as String));
  }

  Future<int> getTodoAmount(String categoryName) async {
    final db = await _database;

    final List<Map<String, dynamic>> categoryMap = await db.query(categoryName);
    return categoryMap.length;
  }
}
