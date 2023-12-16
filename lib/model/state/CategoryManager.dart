import 'package:Todos/model/CategoryEntry.dart';
import 'package:Todos/model/state/StateManager.dart';

class CategoryManager extends StateManager<String> {
  List<CategoryEntry> possibleCategories = [];
  CategoryEntry? selectedEntry = null;

  void addCategory(String name) {
    possibleCategories.add(CategoryEntry(name));
    notifyListeners();
  }

  void deleteCategory(String name) {
    possibleCategories.removeWhere((element) => element.name == name);
    notifyListeners();
  }

  CategoryEntry getCategory(String name) =>
      possibleCategories.firstWhere((element) => element.name == name);
}
