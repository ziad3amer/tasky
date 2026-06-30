import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/model/task_model.dart';

import '../../../core/constances/storage_kay.dart' show StorageKay;

class TasksController with ChangeNotifier {
  bool isLoading = false;

  List<TaskModel> tasks = [];
  List<TaskModel> completeTasks = [];
  List<TaskModel> todoTasks = [];
  List<TaskModel> HighPriorityTasks = [];
  int totalTask = 0;
  int totaldoneTasks = 0;
  double percent = 0;

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
      todoTasks = tasks.where((element) => !element.isDone).toList();
      completeTasks = tasks.where((element) => element.isDone).toList();

      HighPriorityTasks = tasks.where((element) => element.isHighPriority).toList();




      HighPriorityTasks = HighPriorityTasks.reversed.toList();
      calculatePercent();
    }
    isLoading = false;
    notifyListeners();
  }

  void doneTask(bool? value, int? index) async {
    tasks[index!].isDone = value ?? false;
    calculatePercent();
    final updateTask=tasks.map((element)=>element.toJson()).toList();
    PreferencesMangar().setString(StorageKay.tasks, jsonEncode(updateTask));
    notifyListeners();
  }

  void doneTodoTask(bool? value, int? index) async {
    if (index == null) return;
    calculatePercent();
    todoTasks[index].isDone = value ?? false;

    final int newIndex = tasks.indexWhere(
          (e) => e.taskName == todoTasks[index].taskName,
    );
    tasks[newIndex] = todoTasks[index];
    PreferencesMangar().setString(StorageKay.tasks, jsonEncode(tasks));
    _loudTasks();
  }

  void doneCompleteTask(bool? value, int? index) async {
    if (index == null) return;

    completeTasks[index].isDone = value ?? false;

    final int newIndex = tasks.indexWhere(
      (e) => e.taskName == completeTasks[index].taskName,
    );
    tasks[newIndex] = completeTasks[index];
    PreferencesMangar().setString(StorageKay.tasks, jsonEncode(tasks));
    _loudTasks();
  }
  void doneHighPriorityTasks(bool? value, int? index) async {
    if (index == null) return;

    HighPriorityTasks[index].isDone = value ?? false;

    final int newIndex = tasks.indexWhere(
          (e) => e.taskName == HighPriorityTasks[index].taskName,
    );
    tasks[newIndex] = HighPriorityTasks[index];
    PreferencesMangar().setString(StorageKay.tasks, jsonEncode(tasks));
    _loudTasks();
  }

  void deleteTask(int? id) async {
    if (id == null) return;
    tasks.removeWhere((e) => e.id == id);

    // todoTasks.removeWhere((task) => task.id == id);
    // completeTasks.removeWhere((task) => task.id == id);
    // HighPriorityTasks.removeWhere((task) => task.id == id);
    _loudTasks();
    calculatePercent();

    final updatedTask = todoTasks.map((element) => element.toJson()).toList();
    PreferencesMangar().setString(StorageKay.tasks, jsonEncode(updatedTask));

    notifyListeners();
  }

  calculatePercent() {
    totalTask = tasks.length;
    totaldoneTasks = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totaldoneTasks / totalTask;

    notifyListeners();
  }
}
