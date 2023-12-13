import 'package:flutter/material.dart';
import 'package:todo_app/model/CategoryEntry.dart';
import 'package:todo_app/model/state/StateManager.dart';

class CategoryManager extends StateManager<String> {
  List<CategoryEntry> possibleCategories = [];

  void addCategory(String name, Icon icon) {
    possibleCategories.add(CategoryEntry(name, icon));
    notifyListeners();
  }

  void deleteCategory(String name) {
    possibleCategories.removeWhere((element) => element.name == name);
    notifyListeners();
  }

  CategoryEntry getCategory(String name) =>
      possibleCategories.firstWhere((element) => element.name == name);
}
