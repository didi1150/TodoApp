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
    print(join(await getDatabasesPath(), 'todo_list.db'));
    return _database = openDatabase(
        join(await getDatabasesPath(), 'todo_list.db'),
        version: 1,
        singleInstance: true);
  }

  Future<List<CategoryEntry>> getCategories() async {
    final db = await _database;
    List<Map<String, dynamic>> query =
        await db.query('sqlite_master', columns: ['type', 'name']);
    debugPrint("${query.length}");
    return query
        .map((row) => CategoryEntry(row['name']))
        .toList(growable: true);
  }

  Future<void> createCategory(CategoryEntry category) async {
    final db = await _database;
    print("Adding ${category.name}");
    return db.execute(
        'CREATE TABLE IF NOT EXISTS ${category.name}(id TEXT PRIMARY KEY, name TEXT, deadline TEXT, isDone BOOLEAN)');
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
    return List.generate(
        todoMaps.length,
        (index) => TodoEntry(
            name: todoMaps[index]['name'] as String,
            deadline: DateTime.parse(todoMaps[index]['deadline']),
            id: todoMaps[index]['id'] as String));
  }

  Future<Map<String, int>> getAllTodoAmounts() async {
    List<CategoryEntry> categories = await getCategories();
    Map<String, int> amountMap = {};
    for (CategoryEntry c in categories) {
      int amount = await _getTodoAmount(c.name);
      print("db2: ${categories.length}");
      amountMap.putIfAbsent(c.name, () => amount);
    }
    return amountMap;
  }

  Future<Map<String, List<TodoEntry>>> getAllTodos() async {
    List<CategoryEntry> categories = await getCategories();
    Map<String, List<TodoEntry>> todosMap = {};
    for (CategoryEntry c in categories) {
      List<TodoEntry> todo = await getTodos(c.name);
      print("db3");
      todosMap.putIfAbsent(c.name, () => todo);
    }
    return todosMap;
  }

  Future<int> _getTodoAmount(String categoryName) async {
    final db = await _database;

    final List<Map<String, dynamic>> categoryMap = await db.query(categoryName);
    return categoryMap.length;
  }
}
