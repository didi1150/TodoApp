import 'package:flutter/material.dart';
import 'package:todo_app/components/CategorySection.dart';
import 'package:todo_app/components/EntrySearchBar.dart';
import 'package:todo_app/components/TodoEntrySection.dart';
import 'package:todo_app/model/TodoEntry.dart';
import 'package:todo_app/model/state/CategoryManager.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatefulWidget {
  final CategoryManager categoryManager = CategoryManager();
  TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<TodoEntry> todoList = [
    TodoEntry(name: "Mike", deadline: DateTime.now(), id: const Uuid().v4()),
    TodoEntry(name: "Oxlong", deadline: DateTime.now(), id: const Uuid().v4()),
    TodoEntry(
        name: "DK",
        deadline: DateTime.now().add(Duration(days: 2)),
        id: const Uuid().v4()),
    TodoEntry(name: "1", deadline: DateTime.now(), id: const Uuid().v4()),
    TodoEntry(name: "2", deadline: DateTime.now(), id: const Uuid().v4()),
    TodoEntry(name: "3", deadline: DateTime.now(), id: const Uuid().v4()),
    TodoEntry(name: "4", deadline: DateTime.now(), id: const Uuid().v4()),
    TodoEntry(name: "5", deadline: DateTime.now(), id: const Uuid().v4()),
    TodoEntry(name: "6", deadline: DateTime.now(), id: const Uuid().v4())
  ];

  late final List<TodoEntry> _searchResults = List.from(todoList);

  updateSearchResult(String searchText) {
    _searchResults.clear();
    if (searchText.isEmpty) {
      for (int i = 0; i < todoList.length; i++) {
        _searchResults.add(todoList[i]);
      }
      setState(() {});
      return;
    }
    for (int i = 0; i < todoList.length; i++) {
      TodoEntry todo = todoList[i];
      if (todo.name.toLowerCase().contains(searchText.toLowerCase())) {
        _searchResults.add(todo);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    widget.categoryManager.possibleCategories.clear();
    widget.categoryManager
        .addCategory("name", const Icon(Icons.school_outlined));
    widget.categoryManager.addCategory("name1", const Icon(Icons.house));
    widget.categoryManager.addCategory("name2", const Icon(Icons.book));

    widget.categoryManager
        .addCategory("name3safjnaslkfnasln", const Icon(Icons.book));
    return MaterialApp(
        title: "Todo App",
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text(
                "Todo App",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25),
              ),
              centerTitle: true,
            ),
            body: Card(
              child: ListView(
                children: [
                  const Text("Categories",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  CategorySection(categoryManager: widget.categoryManager),
                  const SizedBox(
                    height: 15,
                  ),
                  TodoEntrySearchBar(
                    callback: updateSearchResult,
                  ),
                  const SizedBox(height: 15),
                  TodoEntrySection(
                    searchResults: [..._searchResults],
                  ),
                ],
              ),
            )));
  }
}
