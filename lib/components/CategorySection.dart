import 'package:flutter/material.dart';
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
                  color: Color.fromARGB(255, 0, 240, 220),
                  child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {},
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                category.icon,
                                Text(
                                  category.name.length >= 10
                                      ? category.name.substring(0, 10) + "..."
                                      : category.name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                const Text(
                                  "12 Left",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
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
