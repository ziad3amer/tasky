import 'dart:convert';
import 'dart:io';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tasky/core/constances/Constants.dart';
import 'package:tasky/model/task_model.dart';

class HiveStorageManager {
  static final HiveStorageManager _instance = HiveStorageManager._();

  HiveStorageManager._();

  factory HiveStorageManager() {
    return _instance;
  }
  late Box<TaskModel> _taskBox;

  //mn hena 3maeyt el initialization
  init() async {
    Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    _taskBox=Hive.box<TaskModel>(Constants.taskNameCollection);

  }

  SaveTasks(List<TaskModel> list) async {
    await _taskBox.clear();
    await _taskBox.addAll(list);
  }

  List<TaskModel> loadTasks()  {
    return _taskBox.values.toList();
  }

  clear() async {
    await _taskBox.clear();
  }
}
