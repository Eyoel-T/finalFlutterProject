class Task {
  final String? taskTitle;
  final String? taskId;
  bool isDone;

  Task({this.taskTitle, this.isDone = false, this.taskId});

  void done() {
    isDone = !isDone;
  }
}
