import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter/cupertino.dart';
import 'package:tasky/core/services/hive_storage_manager.dart';
import 'package:tasky/core/services/preferences_mangar.dart';

import '../../core/constances/storage_kay.dart' show StorageKay;
import '../../model/task_model.dart' show TaskModel;

class AddTaskController with ChangeNotifier {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  bool isHighPriority = true;
  bool id = true;

  void addTask(BuildContext context) async {
    print("object");
    if (key.currentState?.validate() ?? false) {
      List<TaskModel> listTasks = HiveStorageManager().loadTasks();

      TaskModel model = TaskModel(
        taskName: taskNameController.text,
        taskDescription: taskDescriptionController.text,
        isHighPriority: isHighPriority,
        id: id,
      );
      listTasks.add(model);
      await HiveStorageManager().SaveTasks(listTasks);

      Navigator.of(context).pop(true);
    }
  }

  void toggle(bool value) {
    isHighPriority = value;
    notifyListeners();
  }
}
