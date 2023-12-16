import 'dart:async';
import 'package:flutter/material.dart';
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

  SQLiteStorage._internal();

  Future<Database> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    return _database = openDatabase(
        join(await getDatabasesPath(), 'todo_list.db'),
        version: 1,
        singleInstance: true);
  }

  Future<List<CategoryEntry>> getCategories() async {
    final db = await _database;
    List<Map<String, dynamic>> query = await db
        .query('sqlite_master', where: 'type = ?', whereArgs: ['table']);
    var list =
        query.map((row) => CategoryEntry(row['name'])).toList(growable: true);
    list.removeWhere((element) => element.name == 'android_metadata');
    return list;
  }

  Future<void> createCategory(CategoryEntry category) async {
    final db = await _database;
    return db.execute(
        'CREATE TABLE IF NOT EXISTS ${category.name}(id TEXT PRIMARY KEY, name TEXT, deadline TEXT, isDone TEXT)');
  }

  Future<void> deleteCategory(CategoryEntry category) async {
    final db = await _database;
    return db.execute("DROP TABLE IF EXISTS ${category.name}");
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
    if (todoMaps.isEmpty) return [];
    return List.generate(
      todoMaps.length,
      (index) {
        TodoEntry t = TodoEntry(
            name: todoMaps[index]['name'] as String,
            deadline: DateTime.parse(todoMaps[index]['deadline']),
            id: todoMaps[index]['id'] as String);
        t.isDone = bool.parse(todoMaps[index]['isDone']);
        return t;
      },
    );
  }

  Future<Map<String, int>> getAllTodoAmounts() async {
    List<CategoryEntry> categories = await getCategories();
    Map<String, int> amountMap = {};
    for (CategoryEntry c in categories) {
      var amount = await _getTodoAmount(c.name);
      amountMap.putIfAbsent(c.name, () => amount);
    }
    return amountMap;
  }

  Future<Map<String, List<TodoEntry>>> getAllTodos() async {
    List<CategoryEntry> categories = await getCategories();
    Map<String, List<TodoEntry>> todosMap = {};
    for (CategoryEntry c in categories) {
      List<TodoEntry> todo = await getTodos(c.name);
      todosMap.putIfAbsent(c.name, () => todo);
    }
    return todosMap;
  }

  Future<int> _getTodoAmount(String categoryName) async {
    final db = await _database;

    List<Map<String, dynamic>> categoryMap = await db.query(categoryName);
    return categoryMap.length;
  }

  Future<void> updateTodoStatus(TodoEntry todo, String categoryName) async {
    final db = await _database;
    db.update(categoryName, todo.toMap(),
        where: 'id = ?', whereArgs: [todo.id]);
  }
}
