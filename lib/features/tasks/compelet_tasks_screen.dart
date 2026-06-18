import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/components/task_list_widget.dart';

class CompeletTasksScreen extends StatefulWidget {
  const CompeletTasksScreen({super.key});

  @override
  State<CompeletTasksScreen> createState() => _CompeletTasksScreenState();
}

class _CompeletTasksScreenState extends State<CompeletTasksScreen> {
  List<TaskModel> completeTasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loudTask();
  }

  void _loudTask() async {
    final finalTask = await PreferencesMangar().getString("tasks");

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      final allTasks = taskAfterDecode
          .map((element) => TaskModel.fromjson(element))
          .toList();

      setState(() {
        completeTasks = allTasks.where((element) => element.isDone).toList();

        isLoading = false;
      });
    } else {
      setState(() {
        completeTasks = [];
        isLoading = false;
      });
    }
  }

  _deleteTask(int? id) async {
    List<TaskModel> tasks=[];
    final finalTask = PreferencesMangar().getString("tasks");
    if(id==null)return;
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      tasks=taskAfterDecode.map((element)=>TaskModel.fromjson(element)).toList();
      tasks.removeWhere((e)=>e.id==id);

      setState(() {
        completeTasks.removeWhere((task) => task.id == id);
      });

      final updatedTask = tasks.map(
            (element) => element.toJson(),
      ).toList();
      PreferencesMangar().setString("tasks", jsonEncode(updatedTask));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Complete Tasks",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),

        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : TaskListWidget(
                  tasks: completeTasks,
                  emptyMessage: "NO Taskes Found",
                  onTap: (value, index) async {
                    setState(() {
                      completeTasks[index!].isDone = value ?? false;
                    });

                    final pref = await SharedPreferences.getInstance();
                    final allData = pref.getString("tasks");

                    if (allData != null) {
                      List<TaskModel> allDataList =
                          (jsonDecode(allData) as List)
                              .map((e) => TaskModel.fromjson(e))
                              .toList();

                      final newIndex = allDataList.indexWhere(
                        (e) => e.taskName == completeTasks[index!].taskName,
                      );

                      if (newIndex != -1) {
                        allDataList[newIndex] = completeTasks[index!];

                        await pref.setString(
                          "tasks",
                          jsonEncode(
                            allDataList.map((e) => e.toMap()).toList(),
                          ),
                        );
                        _loudTask();
                      }
                    }
                  },
                  onDelete: (int? id) {
                    _deleteTask(id);
                  }, onEdit: (){_loudTask();},
                ),
        ),
      ],
    );
  }
}
