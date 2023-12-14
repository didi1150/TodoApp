import 'package:flutter/material.dart';
import 'package:todo_app/Storage.dart';
import 'package:todo_app/model/state/CategoryManager.dart';

class CategorySection extends StatefulWidget {
  CategoryManager categoryManager;

  CategorySection({super.key, required this.categoryManager});

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
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.all(10),
                  color: Theme.of(context).cardColor,
                  elevation: 5,
                  child: InkWell(
                      splashColor: Theme.of(context).splashColor,
                      onTap: () {},
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      SQLiteStorage().deleteCategory(category);
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red)),
                                Text(
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
                                ),
                                Text(
                                  "12 Left",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            )),
                      )),
                ),
              )
              .toList(),
        ));
  }
}
