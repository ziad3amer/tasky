import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constances/app_sizes.dart';
import 'package:tasky/features/home/home_controller.dart';
import 'package:tasky/features/tasks/controller/tasks_controller.dart';

class AchievedTasksWidget extends StatelessWidget {
  const AchievedTasksWidget({
    super.key,
    // required this.totaldoneTasks,
    // required this.totalTask,
    // required this.percent,
  });

  // final int totaldoneTasks;
  // final int totalTask;
  // final double percent;

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder: (BuildContext context,TasksController controller , Widget? child) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,

            borderRadius: BorderRadius.circular(AppSizes.r20),
          ),
          padding: EdgeInsets.all(AppSizes.pw16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Achieved Tasks",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: AppSizes.ph4),
                  Text(
                    "${controller.totaldoneTasks} Out of ${controller.totalTask}",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: -pi / 2,
                    child: SizedBox(
                      width: AppSizes.w48,
                      height: AppSizes.h48,
                      child: CircularProgressIndicator(
                        value: controller.percent,
                        backgroundColor: Color(0xFF6D6D6D),
                        valueColor: AlwaysStoppedAnimation(Color(0XFF15B86C)),
                        strokeWidth: 4,
                      ),
                    ),
                  ),
                  Text(
                    "${((controller.percent * 100).toInt())}%",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        );
      },

    );
  }
}
