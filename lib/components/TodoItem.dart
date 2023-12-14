import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/TodoEntry.dart';

class TodoItem extends StatelessWidget {
  final TodoEntry todo;
  final Function onTodoChanged;
  final Function onDeleteItem;

  const TodoItem(
      {super.key,
      required this.todo,
      required this.onTodoChanged,
      required this.onDeleteItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
            borderRadius: BorderRadius.circular(10)),
        selectedColor: Colors.green,
        tileColor: Theme.of(context).listTileTheme.tileColor,
        leading: IconButton(
          onPressed: () {
            onTodoChanged(todo);
          },
          icon: todo.isDone
              ? const Icon(Icons.check_box)
              : const Icon(Icons.check_box_outline_blank),
          color: Colors.green,
        ),
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(
          todo.name,
          style: TextStyle(
              decoration: todo.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        subtitle:
            Text("Deadline: ${DateFormat("E dd-MM-yy").format(todo.deadline)}"),
        trailing: IconButton(
          onPressed: () {
            onDeleteItem(todo);
          },
          icon: const Icon(Icons.delete),
          color: Colors.red,
        ));
  }
}
