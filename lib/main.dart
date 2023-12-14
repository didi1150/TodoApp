import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Storage.dart';
import 'package:todo_app/components/CategorySection.dart';
import 'package:todo_app/components/CreateFABButton.dart';
import 'package:todo_app/components/CreationDialog.dart';
import 'package:todo_app/components/EntrySearchBar.dart';
import 'package:todo_app/components/TodoEntrySection.dart';
import 'package:todo_app/model/CategoryEntry.dart';
import 'package:todo_app/model/TodoEntry.dart';
import 'package:todo_app/model/state/CategoryManager.dart';
import 'package:uuid/uuid.dart';

void main() async {
  await SQLiteStorage().initDatabase();
  // WidgetsFlutterBinding.ensureInitialized();
  // deleteDatabase(join(await getDatabasesPath(), 'todo_list.db'));
  runApp(MaterialApp(
    title: "Todo App",
    home: const TodoApp(),
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey, brightness: Brightness.dark),
    ),
  ));
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final CategoryManager categoryManager = CategoryManager();

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

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return CreationDialog(
          dialogType: index,
          closeDialog: () {
            Navigator.of(context).pop();
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            "Todo App",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontSize: 25),
          ),
          elevation: 10,
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: Future.wait([
              SQLiteStorage().getCategories(),
              SQLiteStorage().getAllTodoAmounts(),
              SQLiteStorage().getAllTodos()
            ]),
            builder: (context, snapshot) {
              List<Widget> children;

              if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ];
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                );
              } else if (!snapshot.hasData) {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                );
              }

              print("Data has arrived");
              List<CategoryEntry> categories =
                  snapshot.data![0] as List<CategoryEntry>;
              Map<String, int> amountsMap =
                  snapshot.data![1] as Map<String, int>;
              Map<String, List<TodoEntry>> todosMap =
                  snapshot.data![2] as Map<String, List<TodoEntry>>;

              categoryManager.possibleCategories = categories;

              return SingleChildScrollView(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    Scaffold.of(context).appBarMaxHeight!.toInt(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text("Categories",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25))),
                    CategorySection(categoryManager: categoryManager),
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
              ));
            }),
        floatingActionButton: CreateFABButton(distance: 112, children: [
          ActionButton(
            icon: const Icon(Icons.create_new_folder),
            onPressed: () => _showAction(context, 0),
          ),
          ActionButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAction(context, 1),
          )
        ]));
  }
}
