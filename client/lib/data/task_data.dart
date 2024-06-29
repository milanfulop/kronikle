import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Task {
  String name;
  bool completed;
  String category;

  Task({
    required this.name,
    this.completed = false,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'completed': completed,
        'category': category,
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
        name: json['name'],
        completed: json['completed'],
        category: json['category'],
      );
}

class TaskProvider extends ChangeNotifier {
  Map<String, List<Task>> _taskLists = {
    'General': [],
    'Work': [],
  };

  Map<String, bool> _categoryHidden = {};

  TaskProvider() {
    loadState().then((_) {
      initializeCategoryHidden();
    });
  }

  List<String> get categories => _taskLists.keys.toList();

  List<Task> tasksInCategory(String category) {
    return _taskLists[category] ?? [];
  }

  bool isCategoryHidden(String category) {
    return _categoryHidden[category] ?? false;
  }

  void toggleCategoryHidden(String category) {
    if (_categoryHidden.containsKey(category)) {
      _categoryHidden[category] = !_categoryHidden[category]!;
      notifyListeners();
    }
  }

  void initializeCategoryHidden() {
    for (var category in _taskLists.keys) {
      if (!_categoryHidden.containsKey(category)) {
        _categoryHidden[category] = false;
      }
    }
    notifyListeners();
  }

  void addTask(String category, Task task) async {
    _taskLists[category]?.add(task);
    notifyListeners();
    await saveState();
  }

  void addTaskList(String category) {
    if (!_taskLists.containsKey(category)) {
      _taskLists[category] = [];
      _categoryHidden[category] = false;
      notifyListeners();
      saveState();
    }
  }

  void removeTask(String category, Task task) {
    _taskLists[category]?.remove(task);
    notifyListeners();
    saveState();
  }

  void updateTask(Task task, {String? newName, bool? newCompleted}) {
    bool taskUpdated = false;

    for (var category in _taskLists.keys) {
      for (var t in _taskLists[category]!) {
        if (t.name == task.name && t.completed == task.completed) {
          t.name = newName ?? t.name;
          t.completed = newCompleted ?? t.completed;
          taskUpdated = true;
          break;
        }
      }
      if (taskUpdated) break;
    }

    if (taskUpdated) {
      notifyListeners();
      saveState();
    }
  }

  void toggleTaskCompletion(Task task) {
    bool taskUpdated = false;

    for (var category in _taskLists.keys) {
      for (var t in _taskLists[category]!) {
        if (t.name == task.name && t.completed == task.completed) {
          t.completed = !t.completed;
          taskUpdated = true;
          break;
        }
      }
      if (taskUpdated) break;
    }

    if (taskUpdated) {
      notifyListeners();
      saveState();
    }
  }

  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> jsonTaskLists = {};
    _taskLists.forEach((category, tasks) {
      jsonTaskLists[category] =
          jsonEncode(tasks.map((task) => task.toJson()).toList());
    });
    prefs.setString('taskLists', jsonEncode(jsonTaskLists));
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('taskLists');
    if (jsonString != null) {
      Map<String, dynamic> jsonTaskLists = jsonDecode(jsonString);
      _taskLists = jsonTaskLists.map((category, taskListJson) {
        List<Task> tasks = (jsonDecode(taskListJson) as List)
            .map((taskJson) => Task.fromJson(taskJson))
            .toList();
        return MapEntry(category, tasks);
      });
      notifyListeners();
    }
  }

  Future<void> loadCategoryState(String taskJson, String category) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('taskLists');

    if (jsonString != null) {
      Map<String, dynamic> jsonTaskLists = jsonDecode(jsonString);
      if (jsonTaskLists.containsKey(category)) {
        List<Task> tasks = (jsonDecode(taskJson) as List)
            .map((taskJson) => Task.fromJson(taskJson))
            .toList();
        _taskLists[category] = tasks;
        notifyListeners();
      }
    }
  }
}
