import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/widgets/custtom_check_box.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/widgets/task_item_widget.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.emptyMessage,
    required this.onDelete,
    required this.onEdit,
  });

  final List<TaskModel> tasks;
  final Function( int?) onDelete;
  final Function onEdit;
  final Function(bool?, int?) onTap;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              emptyMessage??"NO DATA",
              style:Theme.of(context).textTheme.labelLarge,

            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            padding: EdgeInsets.only(bottom: 60),
            itemBuilder: (BuildContext context, int index) {
              return  TaskItemWidget(
                model: tasks[index],
                onChanged:(bool? value){
                  onTap(value, index);
                }, onDelete: (int? id) {
                 onDelete(id);
              }, onEdit: (){
                onEdit();
              },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 8);
            },
          );
  }
}
