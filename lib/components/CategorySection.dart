import 'package:flutter/material.dart';
import 'package:Todos/Storage.dart';
import 'package:Todos/model/state/CategoryManager.dart';

class CategorySection extends StatefulWidget {
  CategoryManager categoryManager;
  Map<String, int> amountsMap;
  Function updateFunction;
  Function select;
  CategorySection(
      {super.key,
      required this.categoryManager,
      required this.amountsMap,
      required this.updateFunction,
      required this.select});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.categoryManager.possibleCategories
              .map(
                (category) => Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: widget.categoryManager.selectedEntry!.name !=
                                category.name
                            ? Colors.blue
                            : Colors.grey,
                        width: 2,
                      )),
                  margin: const EdgeInsets.all(10),
                  color: widget.categoryManager.selectedEntry!.name ==
                          category.name
                      ? Colors.blue
                      : Theme.of(context).cardColor,
                  elevation: 5,
                  child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      onTap: () {
                        widget.select(category);
                      },
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      await SQLiteStorage()
                                          .deleteCategory(category);
                                      widget.updateFunction();
                                    },
                                    icon: Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.all(10),
                                        child: const Icon(Icons.delete,
                                            color: Colors.red))),
                                Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      category.name.length >= 10
                                          ? "${category.name.substring(0, 10)}..."
                                          : category.name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color,
                                          fontWeight: FontWeight.w700),
                                    )),
                                Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      "${widget.amountsMap[category.name]} left",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color,
                                          fontWeight: FontWeight.w700),
                                    )),
                              ],
                            )),
                      )),
                ),
              )
              .toList(),
        ));
  }
}
