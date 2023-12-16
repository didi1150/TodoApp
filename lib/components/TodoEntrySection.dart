import 'package:flutter/material.dart';
import 'package:Todos/Storage.dart';
import 'package:Todos/components/TodoItem.dart';
import 'package:Todos/model/CategoryEntry.dart';
import 'package:Todos/model/TodoEntry.dart';

class TodoEntrySection extends StatefulWidget {
  TodoEntrySection(
      {super.key,
      required this.searchResults,
      required this.selectedCategory,
      required this.updateFunction});

  List<TodoEntry> searchResults = [];
  CategoryEntry? selectedCategory;
  Function updateFunction;
  @override
  State<TodoEntrySection> createState() => _TodoEntrySectionState();
}

class _TodoEntrySectionState extends State<TodoEntrySection> {
  void _handleTodoChange(TodoEntry todo) async {
    if (widget.selectedCategory == null) return;
    todo.isDone = !todo.isDone;
    await SQLiteStorage().updateTodoStatus(todo, widget.selectedCategory!.name);
    widget.updateFunction();
  }

  Future<void> _handleDeleteItem(TodoEntry todo) async {
    if (widget.selectedCategory == null) return;
    await SQLiteStorage().deleteTodo(todo.id, widget.selectedCategory!.name);
    widget.updateFunction();
  }

  Widget build(BuildContext context) {
    List<TodoEntry> todaysEntries = widget.searchResults
        .where(
            (element) => DateUtils.isSameDay(element.deadline, DateTime.now()))
        .toList();
    List<TodoEntry> upComingEntries = widget.searchResults
        .where((element) => !todaysEntries.contains(element))
        .toList();

    return DefaultTabController(
        length: 2,
        child: Expanded(
            child: Card(
                clipBehavior: Clip.hardEdge,
                elevation: 10,
                surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                child: Column(children: [
                  const TabBar(
                      tabs: [Tab(text: "Today"), Tab(text: "Upcoming")],
                      labelStyle: TextStyle(fontSize: 20)),
                  Expanded(
                      child: TabBarView(children: [
                    ListView.builder(
                        itemCount: todaysEntries.length,
                        itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: TodoItem(
                                todo: todaysEntries[index],
                                onTodoChanged: _handleTodoChange,
                                onDeleteItem: _handleDeleteItem))),
                    ListView.builder(
                        itemCount: upComingEntries.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(10),
                              child: TodoItem(
                                  todo: upComingEntries[index],
                                  onTodoChanged: _handleTodoChange,
                                  onDeleteItem: _handleDeleteItem),
                            ))
                  ])),
                ]))));
  }
}
