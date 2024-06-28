import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Task {
  String name;
  bool completed;

  Task({required this.name, this.completed = false});

  Map<String, dynamic> toJson() => {
        'name': name,
        'completed': completed,
      };

  static Task fromJson(Map<String, dynamic> json) => Task(
        name: json['name'],
        completed: json['completed'],
      );
}

class TaskProvider extends ChangeNotifier {
  Map<String, List<Task>> _taskLists = {
    'General': [],
    'Work': [],
  };

  TaskProvider() {
    loadState();
  }

  List<String> get categories => _taskLists.keys.toList();

  List<Task> tasksInCategory(String category) {
    return _taskLists[category] ?? [];
  }

  void addTask(String category, Task task) {
    _taskLists[category]?.add(task);
    notifyListeners();
    saveState();
  }

  void addTaskList(String category) {
    if (!_taskLists.containsKey(category)) {
      _taskLists[category] = [];
      notifyListeners();
      saveState();
    }
  }

  void removeTask(String category, Task task) {
    _taskLists[category]?.remove(task);
    notifyListeners();
    saveState();
  }

  void updateTask(String category, Task task,
      {String? newName, bool? newCompleted}) {
    task.name = newName ?? task.name;
    task.completed = newCompleted ?? task.completed;
    notifyListeners();
    saveState();
  }

  void toggleTaskCompletion(String category, Task task) {
    task.completed = !task.completed;
    notifyListeners();
    saveState();
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
      print("jsontasklists: $jsonTaskLists");
      // Update only the specified category
      if (jsonTaskLists.containsKey(category)) {
        print("contains key");
        List<Task> tasks = (jsonDecode(taskJson) as List)
            .map((taskJson) => Task.fromJson(taskJson))
            .toList();
        print("tasks: $tasks");
        _taskLists[category] = tasks;
        print(_taskLists);
        notifyListeners();
        print("done notifying");
      }
    }

    print(_taskLists);
  }
}
