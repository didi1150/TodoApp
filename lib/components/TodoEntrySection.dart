import 'package:flutter/material.dart';
import 'package:todo_app/components/TodoItem.dart';
import 'package:todo_app/model/TodoEntry.dart';

class TodoEntrySection extends StatefulWidget {
  TodoEntrySection({super.key, required this.searchResults});

  List<TodoEntry> searchResults = [];

  @override
  State<TodoEntrySection> createState() => _TodoEntrySectionState();
}

class _TodoEntrySectionState extends State<TodoEntrySection> {
  Widget build(BuildContext context) {
    List<TodoEntry> todaysEntries = widget.searchResults
        .where(
            (element) => DateUtils.isSameDay(element.deadline, DateTime.now()))
        .toList();
    List<TodoEntry> upComingEntries = widget.searchResults
        .where((element) => !todaysEntries.contains(element))
        .toList();

    void _handleTodoChange(TodoEntry todo) {
      setState(() {
        todo.isDone = !todo.isDone;
      });
    }

    void _handleDeleteItem(TodoEntry todo) {
      setState(() {
        widget.searchResults.removeWhere((element) => element.id == todo.id);
      });
    }

    return DefaultTabController(
        length: 2,
        child: Expanded(
            child: Card(
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
