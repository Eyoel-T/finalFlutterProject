class Task {
  final String? taskTitle;
  bool isDone;

  Task({this.taskTitle, this.isDone = false});

  void done() {
    isDone = !isDone;
  }

  Task.fromMap(Map map)
      : taskTitle = map['taskTitle'],
        isDone = map['isDone'];

  Map toMap() {
    return {
      'taskTitle': taskTitle,
      'isDone': isDone,
    };
  }
}
