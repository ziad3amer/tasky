import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/widgets/custtom_check_box.dart';
import 'package:tasky/features/home/home_controller.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/components/task_item_widget.dart';

class SliverTaskListWidget extends StatelessWidget {
  const SliverTaskListWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context,HomeController controller , Widget? child) {
        final tasksList= controller.tasks;
        return tasksList.isEmpty
            ? SliverToBoxAdapter(
          child: Center(
            child: Text(
              "No Data       ",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
        )
            : SliverPadding(
          padding: EdgeInsets.only(bottom: 80),
          sliver: SliverList.separated(
            itemCount: tasksList.length,
            itemBuilder: (BuildContext context, int index) {
              return TaskItemWidget(
                model: tasksList[index],
                onChanged:(bool? value){
                  controller.doneTask(value, index);
                }, onDelete: (int? id) {

                controller.deleteTask(id);
              }, onEdit: (){
                controller.loudTask();

              },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 8);
            },
          ),
        );
      },
    );
  }
}
