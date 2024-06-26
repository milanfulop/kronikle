import 'package:flutter/foundation.dart';

class Task {
  String name;
  bool completed;

  Task({required this.name, this.completed = false});
}

class TaskProvider extends ChangeNotifier {
  Map<String, List<Task>> _taskLists = {
    'General': [],
    'Work': [],
  };

  List<String> get categories => _taskLists.keys.toList();

  List<Task> tasksInCategory(String category) {
    return _taskLists[category] ?? [];
  }

  void addTask(String category, Task task) {
    _taskLists[category]?.add(task);
    notifyListeners();
  }

  void addTaskList(String category) {
    if (!_taskLists.containsKey(category)) {
      _taskLists[category] = [];
      notifyListeners();
    }
  }

  void removeTask(String category, Task task) {
    _taskLists[category]?.remove(task);
    notifyListeners();
  }

  void updateTask(String category, Task task,
      {String? newName, bool? newCompleted}) {
    task.name = newName ?? task.name;
    task.completed = newCompleted ?? task.completed;
    notifyListeners();
  }

  void toggleTaskCompletion(String category, Task task) {
    task.completed = !task.completed;
    notifyListeners();
  }
}
