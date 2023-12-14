class TodoEntry {
  final String name;
  final DateTime deadline;
  bool isDone;
  final String id;
  TodoEntry({required this.name, required this.deadline, this.isDone = false, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'deadline': deadline.toString(),
      'isDone': isDone,
    };
  }
}
