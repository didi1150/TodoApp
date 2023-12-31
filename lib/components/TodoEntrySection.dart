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
    todaysEntries.sort((a, b) => a.deadline.compareTo(b.deadline));
    List<TodoEntry> upComingEntries = widget.searchResults
        .where((element) =>
            element.deadline.isAfter(DateTime.now()) &&
            (element.deadline.day != DateTime.now().day ||
                DateTime.now().difference(element.deadline).inHours > 24))
        .toList();

    upComingEntries.sort((a, b) => a.deadline.compareTo(b.deadline));
    List<TodoEntry> expiredEntries = widget.searchResults
        .where((element) =>
            element.deadline.isBefore(DateTime.now()) &&
            (element.deadline.day != DateTime.now().day ||
                DateTime.now().difference(element.deadline).inHours > 24))
        .toList();
    expiredEntries.sort((a, b) => a.deadline.compareTo(b.deadline));

    return DefaultTabController(
        length: 3,
        child: Expanded(
            child: Card(
                clipBehavior: Clip.hardEdge,
                elevation: 10,
                surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                child: Column(children: [
                  const TabBar(
                      tabAlignment: TabAlignment.center,
                      isScrollable: true,
                      tabs: [
                        Tab(text: "Today"),
                        Tab(text: "Upcoming"),
                        Tab(text: "Expired")
                      ],
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
                            )),
                    ListView.builder(
                        itemCount: expiredEntries.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(10),
                              child: TodoItem(
                                  todo: expiredEntries[index],
                                  onTodoChanged: _handleTodoChange,
                                  onDeleteItem: _handleDeleteItem),
                            )),
                  ])),
                ]))));
  }
}
