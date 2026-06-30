import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/features/tasks/controller/tasks_controller.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/components/task_list_widget.dart';

class HighPriorityScreen extends StatelessWidget {
  const HighPriorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "High Priority Tasks",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: controller.isLoading
            ? Center(child: CircularProgressIndicator())
            : Consumer<TasksController>(
          builder: (BuildContext context, value, Widget? child) {
            return TaskListWidget(
              tasks: value.HighPriorityTasks,
              onTap: (value, index) async {
                controller.doneHighPriorityTasks(value, index);

              },
              emptyMessage: 'NO Taskes Found',
              onDelete: (int? id) {
                controller.deleteTask(id);

              }, onEdit: (){
              controller.init();
            },
            );
          },

        ),
      ),
    );
  }
}
