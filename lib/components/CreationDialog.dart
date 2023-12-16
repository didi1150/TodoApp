import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Storage.dart';
import 'package:todo_app/model/CategoryEntry.dart';
import 'package:todo_app/model/TodoEntry.dart';
import 'package:todo_app/model/state/CategoryManager.dart';
import 'package:uuid/uuid.dart';

class CreationDialog extends StatefulWidget {
  final int dialogType;
  Function closeDialog;
  CategoryManager categoryManager;
  CreationDialog(
      {super.key,
      required this.categoryManager,
      required this.dialogType,
      required this.closeDialog});

  @override
  State<CreationDialog> createState() => _CreationDialogState();
}

class _CreationDialogState extends State<CreationDialog> {
  final TextEditingController _inputController = TextEditingController();
  late int type;
  String? selectedCategory = null;
  String? errorMessage = null;
  DateTime? pickedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    type = widget.dialogType;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime.now().subtract(const Duration(days: 1)),
        lastDate: DateTime(2101));
    if (picked != null && picked != pickedDate) {
      setState(() {
        pickedDate = picked;
      });
    }
  }

  Future<void> _finish(BuildContext context) async {
    if (type == 0) {
      await SQLiteStorage()
          .createCategory(CategoryEntry(_inputController.text));

      widget.closeDialog();
    }

    if (type == 1) {
      errorMessage = null;
      if (selectedCategory == null) {
        errorMessage = "Please select a category";
      } else if (_inputController.text.isEmpty) {
        errorMessage = "Please insert a valid todo description";
      } else if (pickedDate == null) {
        errorMessage = "Please pick a deadline";
      }

      if (errorMessage != null) {
        setState(() {});
        return;
      }
      await SQLiteStorage().addTodo(
          TodoEntry(
              name: _inputController.text,
              deadline: pickedDate!,
              id: const Uuid().v4()),
          selectedCategory!);
      widget.closeDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (type == 0) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
                padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Center(
                    child: Text(
                  "Add Category...",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ))),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                      hintText: "Enter Category name...",
                      contentPadding: EdgeInsets.only(left: 10, right: 10))),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(
                  onPressed: () => widget.closeDialog(),
                  style: const ButtonStyle(
                      elevation: MaterialStatePropertyAll(0),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          side: BorderSide(
                              color: Colors.red,
                              strokeAlign: 1,
                              style: BorderStyle.solid,
                              width: 1.3)))),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () async => await _finish(context),
                    style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(0),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.green,
                                strokeAlign: 1,
                                style: BorderStyle.solid,
                                width: 1.3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(2))))),
                    child: const Text(
                      "Finish",
                      style: TextStyle(color: Colors.green),
                    ))
              ]),
            )
          ],
        ),
      );
    }
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
              padding: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Center(
                  child: Text(
                "Add Todo",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ))),
          const SizedBox(
            height: 15,
          ),
          DropdownMenu(
            enableSearch: true,
            dropdownMenuEntries: widget.categoryManager.possibleCategories
                .map((c) => DropdownMenuEntry(value: c, label: c.name))
                .toList(),
            enableFilter: true,
            leadingIcon: const Icon(Icons.search),
            requestFocusOnTap: true,
            label: const Text('Category'),
            width: 300,
            onSelected: (value) {
              selectedCategory = value!.name;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
                controller: _inputController,
                decoration: const InputDecoration(
                    hintText: "Enter Todo description...",
                    contentPadding: EdgeInsets.only(left: 10, right: 10))),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Until:_${pickedDate!.toLocal()}"
                  .split(' ')[0]
                  .replaceFirst('_', ' ')),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                style: const ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        side: BorderSide(
                            strokeAlign: 1,
                            style: BorderStyle.solid,
                            width: 1.3)))),
                child: const Text(
                  "Select Deadline",
                ),
              ),
            ],
          ),
          errorMessage != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton(
                onPressed: () => widget.closeDialog(),
                style: const ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        side: BorderSide(
                            color: Colors.red,
                            strokeAlign: 1,
                            style: BorderStyle.solid,
                            width: 1.3)))),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () async => await _finish(context),
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.green,
                              strokeAlign: 1,
                              style: BorderStyle.solid,
                              width: 1.3),
                          borderRadius: BorderRadius.all(Radius.circular(2))))),
                  child: const Text(
                    "Finish",
                    style: TextStyle(color: Colors.green),
                  ))
            ]),
          )
        ],
      ),
    );
  }
}
