import 'package:flutter/foundation.dart';

class Task {
  String name;
  bool completed;
  String category;

  Task({
    required this.name,
    required this.category,
    this.completed = false,
  });
}

class TaskProvider extends ChangeNotifier {
  Map<String, List<Task>> _tasksByCategory = {
    'General': [
      Task(name: "task 1", category: 'General', completed: false),
      Task(name: "task 2", category: 'General', completed: false),
    ],
    'Work': [
      Task(name: "work task 1", category: 'Work', completed: false),
      Task(name: "work task 2", category: 'Work', completed: false),
    ],
  };

  List<Task> get allTasks {
    List<Task> allTasks = [];
    _tasksByCategory.values.forEach((categoryTasks) {
      allTasks.addAll(categoryTasks);
    });
    return allTasks;
  }

  List<Task> tasksInCategory(String category) {
    return _tasksByCategory[category] ?? [];
  }

  void addTask(Task task) {
    if (_tasksByCategory.containsKey(task.category)) {
      _tasksByCategory[task.category]!.add(task);
    } else {
      _tasksByCategory[task.category] = [task];
    }
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasksByCategory[task.category]?.remove(task);
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
