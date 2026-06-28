import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/core/widgets/custtom_svg_picture.dart';
import 'package:tasky/features/home/home_controller.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/features/add_task/add_task_screen.dart';
import 'package:tasky/features/home/widget/achieved_tasks_widget.dart';
import 'package:tasky/features/home/widget/high_priority_tasks_widget.dart';
import 'package:tasky/features/home/widget/sliver_task_list_widget.dart';
import 'package:tasky/components/task_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    print("Homescreen");

    return ChangeNotifierProvider<HomeController>(
      create: (BuildContext context) => HomeController()..init(),
      child: Consumer<HomeController>(
        builder: (BuildContext context, value, Widget? child) {
          final controller = context.read<HomeController>();
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
                if (result != null && result) controller.loudTask();
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
                              backgroundImage: value.userImagePath == null
                                  ? AssetImage("lib/assets/images/person.png")
                                  : FileImage(File(value.userImagePath!)),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good Evening, ${value.username}",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
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
                          totaldoneTasks: value.totaldoneTasks,
                          totalTask: value.totalTask,
                          percent: value.percent,
                        ),
                        SizedBox(height: 8),
                        HighPriorityTasksWidget(
                          highPriorityTasksired: value.tasks
                              .where((e) => e.isHighPriority)
                              .toList(),
                          tasks: value.tasks,
                          onTap: (bool? value, int? index) {
                            controller.doneTask(value, index);
                          },
                          refresh: () {
                            controller.loudTask();
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
                    tasks: value.tasks,
                    onTap: (bool? value, int? index) {
                      controller.doneTask(value, index);
                    },
                    onDelete: (int? id) {
                      controller.deleteTask(id);
                    },
                    emptyMessage: 'No Data',
                    onEdit: () {
                      controller.loudTask();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
