import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/core/widgets/custtom_svg_picture.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/screens/add_task_screen.dart';
import 'package:tasky/widgets/achieved_tasks_widget.dart';
import 'package:tasky/widgets/high_priority_tasks_widget.dart';
import 'package:tasky/widgets/sliver_task_list_widget.dart';
import 'package:tasky/widgets/task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.name});

  final String name;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username = "Default";
  String? userImagePath;
  List<TaskModel> tasks = [];
  int totalTask = 0;
  int totaldoneTasks = 0;
  double percent = 0;

  @override
  void initState() {
    super.initState();
    _loudUsername();
    _loudTask();
  }

  void _loudUsername() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      username = PreferencesMangar().getString("username");
      userImagePath = PreferencesMangar().getString("user_image");
    });
  }

  void _loudTask() async {
    final pref = await SharedPreferences.getInstance();
    final finalTask = pref.getString("tasks");

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        tasks = taskAfterDecode
            .map((element) => TaskModel.fromjson(element))
            .toList();
        _calculatePercent();
      });
    }
  }

  _calculatePercent() {
    totalTask = tasks.length;
    totaldoneTasks = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totaldoneTasks / totalTask;
  }

  _doneTask(bool? value, int? index) async {
    setState(() {
      tasks[index!].isDone = value ?? false;
      _calculatePercent();
    });

    final updatedTask = tasks.map((element) => element.toMap()).toList();
    PreferencesMangar().setString("tasks", jsonEncode(updatedTask));
  }

  _deleteTask(int? id) async {
    if (id == null) return;
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      _calculatePercent();
    });
    //todo : makeshared method.
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesMangar().setString("tasks", jsonEncode(updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    print("Homescreen");

    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(fixedSize: Size(168, 40)),
        label: Text("Add New Task"),
        icon: Icon(Icons.add),
        onPressed: () async {
          final bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return AddTask();
              },
            ),
          );
          if (result != null && result) _loudTask();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: userImagePath == null
                            ? AssetImage("lib/assets/images/person.png")
                            : FileImage(File(userImagePath!)),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening, $username",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "One task at a time. One step\ncloser.",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  Text(
                    "Yuhuu ,Your work Is ",
                    style: Theme.of(context).textTheme.displayLarge,
                    // TextStyle(fontSize: 32, color: Color(0xFFFFFCFC)),
                  ),
                  Row(
                    children: [
                      Text(
                        "almost done ! ",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      CusttomSvgPicture.withColorFilter(
                        path: "lib/assets/images/waving-hand-.svg",
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                  //Achieved Tasks
                  SizedBox(height: 16),
                  AchievedTasksWidget(
                    totaldoneTasks: totaldoneTasks,
                    totalTask: totalTask,
                    percent: percent,
                  ),
                  SizedBox(height: 8),
                  HighPriorityTasksWidget(
                    highPriorityTasksired: tasks
                        .where((e) => e.isHighPriority)
                        .toList(),
                    tasks: tasks,
                    onTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    refresh: () {
                      _loudTask();
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 16),
                    child: Text(
                      "My Tasks",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),

            SliverTaskListWidget(
              tasks: tasks,
              onTap: (bool? value, int? index) {
                _doneTask(value, index);
              },
              onDelete: (int? id) {
                _deleteTask(id);
              },
              emptyMessage: 'No Data',
              onEdit: () {
                _loudTask();
              },
            ),
          ],
        ),
      ),
    );
  }
}
