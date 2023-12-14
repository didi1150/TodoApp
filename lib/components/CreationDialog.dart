import 'package:flutter/material.dart';
import 'package:todo_app/Storage.dart';
import 'package:todo_app/model/CategoryEntry.dart';

class CreationDialog extends StatefulWidget {
  final int dialogType;
  Function closeDialog;

  CreationDialog(
      {super.key, required this.dialogType, required this.closeDialog});

  @override
  State<CreationDialog> createState() => _CreationDialogState();
}

class _CreationDialogState extends State<CreationDialog> {
  final TextEditingController _categoryController = TextEditingController();
  late int type;

  @override
  void initState() {
    super.initState();
    this.type = widget.dialogType;
  }

  @override
  Widget build(BuildContext context) {
    if (type == 0) {
      return TapRegion(
          onTapOutside: (event) {
            Navigator.of(context).pop();
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                    padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: Center(
                        child: Text(
                      "Add Category...",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ))),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                          hintText: "Enter Category name...",
                          contentPadding:
                              EdgeInsets.only(left: 10, right: 10))),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    ElevatedButton(
                      onPressed: () => widget.closeDialog(),
                      style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(0),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2)),
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
                        onPressed: () { SQLiteStorage().createCategory(CategoryEntry(_categoryController.text)); widget.closeDialog(); },
                        style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(0),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
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
          ));
    }
    return const Placeholder();
  }
}
