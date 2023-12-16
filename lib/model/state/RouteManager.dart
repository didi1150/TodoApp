import 'package:Todos/model/state/StateManager.dart';

class RouteManager extends StateManager<String> {
  List<String> possibleRoutes = [];
  String getRoute(String name) =>
      possibleRoutes.firstWhere((element) => element == name);
}
