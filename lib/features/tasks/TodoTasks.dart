import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/components/task_list_widget.dart';

import 'tasks_controller.dart';

class TodoTasks extends StatelessWidget {
   TodoTasks({super.key});




  // void _loudTask() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   final finalTask = PreferencesMangar().getString(StorageKay.tasks);
  //
  //   if (finalTask != null) {
  //     final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
  //
  //     setState(() {
  //       todoTasks = taskAfterDecode
  //           .map((element) => TaskModel.fromjson(element))
  //           .toList();
  //       todoTasks = todoTasks.where((element) => !element.isDone).toList();
  //     });
  //   }
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  // }


  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  // appBar: AppBar(title: Text("To Do Tasks")),
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TasksController>(
      create: (_) =>TasksController()..init(),
      child: Builder(
        builder: (BuildContext context) {
          final controller = context.read<TasksController>();
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
                  child: controller.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Consumer<TasksController>(
                        builder: (BuildContext context, value, Widget? child) {
                          return TaskListWidget(
                            tasks: value.todoTasks,
                            onTap: (value, index) async {
                              controller.doneTask(value , index);

                            },
                            emptyMessage: 'NO Taskes Found',
                            onDelete: (int? id) {
                              //_deleteTask(id);
                              controller.deleteTask(id);
                            }, onEdit: (){
                              controller.init();
                            //_loudTask();
                          },
                          );
                        },
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
