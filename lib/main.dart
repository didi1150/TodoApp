import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
import 'package:Todos/Storage.dart';
import 'package:Todos/components/CategorySection.dart';
import 'package:Todos/components/CreateFABButton.dart';
import 'package:Todos/components/CreationDialog.dart';
import 'package:Todos/components/EntrySearchBar.dart';
import 'package:Todos/components/TodoEntrySection.dart';
import 'package:Todos/model/CategoryEntry.dart';
import 'package:Todos/model/TodoEntry.dart';
import 'package:Todos/model/state/CategoryManager.dart';
import 'package:draggable_expandable_fab/draggable_expandable_fab.dart';
import 'package:uuid/uuid.dart';

void main() async {
  await SQLiteStorage().initDatabase();
  // await SQLiteStorage().deleteCategory(CategoryEntry("android_metadata"));
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
  String searchText = "";
  List<TodoEntry> todoList = [];

  late List<TodoEntry> _searchResults = [];

  updateSearchResult(String searchText, bool update) {
    this.searchText = searchText;
    _searchResults.clear();
    if (searchText.isEmpty) {
      for (int i = 0; i < todoList.length; i++) {
        _searchResults.add(todoList[i]);
      }
    } else {
      for (int i = 0; i < todoList.length; i++) {
        TodoEntry todo = todoList[i];
        if (todo.name.toLowerCase().contains(searchText.toLowerCase())) {
          _searchResults.add(todo);
        }
      }
    }
    if (update) setState(() {});
  }

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return CreationDialog(
          categoryManager: categoryManager,
          dialogType: index,
          closeDialog: () {
            Navigator.of(context).pop();
            setState(() {});
          },
        );
      },
    );
  }

  void _selectCategory(CategoryEntry categoryEntry) {
    categoryManager.selectedEntry = categoryEntry;
    setState(() {});
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
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.blue,
              height: 2.0,
            )),
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

            List<CategoryEntry> categories =
                snapshot.data![0] as List<CategoryEntry>;
            Map<String, int> amountsMap = snapshot.data![1] as Map<String, int>;
            Map<String, List<TodoEntry>> todosMap =
                snapshot.data![2] as Map<String, List<TodoEntry>>;

            categoryManager.possibleCategories = categories;
            if (categories.isNotEmpty) {
              categoryManager.selectedEntry ??= categories[0];
            }

            var currentTodos = [];
            if (categoryManager.selectedEntry != null) {
              currentTodos =
                  todosMap[categoryManager.selectedEntry!.name] ?? [];
            }
            todoList = [...currentTodos];
            _searchResults = List.from(todoList);

            updateSearchResult(searchText, false);
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
                  CategorySection(
                    categoryManager: categoryManager,
                    amountsMap: amountsMap,
                    updateFunction: () {
                      setState(() {});
                    },
                    select: _selectCategory,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TodoEntrySearchBar(
                    callback: (text) {
                      updateSearchResult(text, true);
                    },
                  ),
                  const SizedBox(height: 15),
                  TodoEntrySection(
                    selectedCategory: categoryManager.selectedEntry,
                    searchResults: [..._searchResults],
                    updateFunction: () {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ));
          }),
      floatingActionButtonAnimator: NoScalingAnimation(),
      floatingActionButtonLocation: ExpandableFloatLocation(),
      floatingActionButton: ExpandableDraggableFab(
          childrenTransition: ChildrenTransition.scaleTransation,
          distance: 150,
          childrenBacgroundColor: Colors.transparent,
          childrenCount: 2,
          childrenType: ChildrenType.rowChildren,
          enableChildrenAnimation: true,
          childrenAlignment: Alignment.bottomLeft,
          children: [
            ActionButton(
              icon: const Icon(Icons.create_new_folder),
              onPressed: () => _showAction(context, 0),
            ),
            ActionButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAction(context, 1),
            )
          ]),
    );
  }
}
