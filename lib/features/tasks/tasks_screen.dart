import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/features/tasks/tasks_screen.dart';
import 'package:tasky/components/task_list_widget.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskModel> todoTasks = [];
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
        todoTasks = taskAfterDecode
            .map((element) => TaskModel.fromjson(element))
            .toList();
        todoTasks = todoTasks.where((element) => !element.isDone).toList();
      });
    }

    setState(() {
      isLoading = false;
    });
  }
  _deleteTask(int? id) async {
    if (id == null) return;
    setState(() {
      todoTasks.removeWhere((task) => task.id == id);

    });

    final updatedTask = todoTasks.map((element) => element.toJson()).toList();
    PreferencesMangar().setString("tasks", jsonEncode(updatedTask));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  // appBar: AppBar(title: Text("To Do Tasks")),
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            "To Do Tasks",
            style:Theme.of(context).textTheme.labelSmall,

          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : TaskListWidget(
                    tasks: todoTasks,
                    onTap: (value, index) async {
                      setState(() {
                        todoTasks[index!].isDone = value ?? false;
                      });

                      final allData = PreferencesMangar().getString("tasks");
                      if (allData != null) {
                        List<TaskModel> allDataList =
                            (jsonDecode(allData) as List)
                                .map((element) => TaskModel.fromjson(element))
                                .toList();
                        final int newIndex = allDataList.indexWhere(
                          (e) => e.taskName == todoTasks[index!].taskName,
                        );
                        allDataList[newIndex] = todoTasks[index!];
                        PreferencesMangar().setString("tasks", jsonEncode(allDataList));
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
        ),
      ],
    );
  }
}
