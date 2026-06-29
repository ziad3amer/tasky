import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/features/tasks/controller/tasks_controller.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/components/task_list_widget.dart';

class CompeletTasksScreen extends StatelessWidget {
  const CompeletTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TasksController>(
      create: (BuildContext context) => TasksController()..init(),
      child: Builder(
        builder: (BuildContext context) {
          final controller = context.read<TasksController>();
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
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Consumer<TasksController>(
                        builder: (BuildContext context, value, Widget? child) {
                          return TaskListWidget(
                            tasks: value.completeTasks,
                            emptyMessage: "NO Taskes Found",
                            onTap: (value, index) async {
                              controller.doneCompleteTask(value, index);
                            },
                            onDelete: (int? id) {
                              controller.deleteTask(id);
                            },
                            onEdit: () {
                              controller.init();
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
