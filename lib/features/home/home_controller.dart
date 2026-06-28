import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/model/task_model.dart';

class HomeController with ChangeNotifier {
  List<TaskModel> tasksList = [];
  String? username = "Default";
  String? userImagePath;
  List<TaskModel> tasks = [];
  int totalTask = 0;
  int totaldoneTasks = 0;
  double percent = 0;

  init(){
      loudUserData();
      loudTask();
  }
  void loudUserData() async {
    final pref = await SharedPreferences.getInstance();
    username = PreferencesMangar().getString(StorageKay.username);
    userImagePath = PreferencesMangar().getString(StorageKay.userImage);
    notifyListeners();
  }

  void loudTask() async {
    final pref = await SharedPreferences.getInstance();
    final finalTask = pref.getString(StorageKay.tasks);

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      tasks = taskAfterDecode
          .map((element) => TaskModel.fromjson(element))
          .toList();
      calculatePercent();
      notifyListeners();
    }
  }

  calculatePercent() {
    totalTask = tasks.length;
    totaldoneTasks = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totaldoneTasks / totalTask;
    notifyListeners();
  }

  doneTask(bool? value, int? index) async {
    tasks[index!].isDone = value ?? false;
    calculatePercent();

    final updatedTask = tasks.map((element) => element.toMap()).toList();
    PreferencesMangar().setString(StorageKay.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }

  deleteTask(int? id) async {
    if (id == null) return;
    tasks.removeWhere((task) => task.id == id);
    calculatePercent();
    //todo : makeshared method.
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesMangar().setString(StorageKay.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }
}
