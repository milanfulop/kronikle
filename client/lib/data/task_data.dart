import 'package:flutter/foundation.dart';

class Task {
  String name;
  bool completed;

  Task({required this.name, this.completed = false});
}

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [
    Task(
      name: "task 010010101 0 101 task 111 task 1 1 1 1 1",
      completed: false,
    ),
    Task(
      name: "xd",
      completed: false,
    ),
  ];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void updateTask(Task task, {String? newName, bool? newCompleted}) {
    task.name = newName ?? task.name;
    task.completed = newCompleted ?? task.completed;
    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    task.completed = !task.completed;
    notifyListeners();
  }
}
