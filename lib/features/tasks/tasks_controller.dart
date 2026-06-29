import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/model/task_model.dart';

import '../../core/constances/storage_kay.dart' show StorageKay;

class TasksController with ChangeNotifier {
  bool isLoading = false;

  List<TaskModel> tasks = [];
  List<TaskModel> completeTasks = [];
  List<TaskModel> todoTasks = [];

  void init() {
    _loudTasks();
  }

  void _loudTasks() async {
    isLoading = true;
    final finalTask = PreferencesMangar().getString(StorageKay.tasks);


    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      tasks = taskAfterDecode
          .map((element) => TaskModel.fromjson(element))
          .toList();
      todoTasks=tasks.where((element) => !element.isDone).toList();
      // calculatePercent();

    }
    isLoading = false;
    notifyListeners();
  }

  void doneTask(bool? value, int? index) async {
    if (index == null) return;

    todoTasks[index].isDone = value ?? false;

      final int newIndex = tasks.indexWhere(
        (e) => e.taskName == todoTasks[index].taskName,
      );
      tasks[newIndex] = todoTasks[index];
      PreferencesMangar().setString(StorageKay.tasks, jsonEncode(tasks));
      _loudTasks();

  }

  void deleteTask(int? id) async {
    if (id == null) return;
    tasks.removeWhere((e) => e.id == id);

    todoTasks.removeWhere((task) => task.id == id);

    final updatedTask = todoTasks.map((element) => element.toJson()).toList();
    PreferencesMangar().setString(StorageKay.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }
}
