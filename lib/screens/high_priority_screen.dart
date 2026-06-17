import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/widgets/task_list_widget.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  List<TaskModel> HighPriorityTasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _loudTask();
  }

  void _loudTask() async {
    setState(() {
      isLoading = true;
    });
    final finalTask = PreferencesMangar().getString("tasks");

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        HighPriorityTasks = taskAfterDecode
            .map((element) => TaskModel.fromjson(element))
            .toList();

        HighPriorityTasks = HighPriorityTasks.where(
          (element) => element.isHighPriority,
        ).toList();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  _deleteTask(int? id) async {
    List<TaskModel> tasks = [];
    final finalTask = PreferencesMangar().getString("tasks");
    if (id == null) return;
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      tasks = taskAfterDecode
          .map((element) => TaskModel.fromjson(element))
          .toList();
      tasks.removeWhere((e) => e.id == id);

      setState(() {
        HighPriorityTasks.removeWhere((task) => task.id == id);
      });

      final updatedTask = tasks.map((element) => element.toJson()).toList();
      PreferencesMangar().setString("tasks", jsonEncode(updatedTask));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "High Priority Tasks",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : TaskListWidget(
                tasks: HighPriorityTasks,
                onTap: (value, index) async {
                  setState(() {
                    HighPriorityTasks[index!].isDone = value ?? false;
                  });
                  final pref = await SharedPreferences.getInstance();

                  final allData = pref.getString("tasks");
                  if (allData != null) {
                    List<TaskModel> allDataList = (jsonDecode(allData) as List)
                        .map((element) => TaskModel.fromjson(element))
                        .toList();
                    HighPriorityTasks = HighPriorityTasks.reversed.toList();
                    final int newIndex = allDataList.indexWhere(
                      (e) => e.taskName == HighPriorityTasks[index!].taskName,
                    );
                    allDataList[newIndex] = HighPriorityTasks[index!];

                    await pref.setString("tasks", jsonEncode(allDataList));
                    _loudTask();
                  }
                },
                emptyMessage: 'NO Taskes Found',
                onDelete: (int? id) {
                  _deleteTask(id);
                }, onEdit: (){
                  _loudTask();
        },
              ),
      ),
    );
  }
}
