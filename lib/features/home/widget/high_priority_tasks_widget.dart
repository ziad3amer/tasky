import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custtom_check_box.dart';
import 'package:tasky/core/widgets/custtom_svg_picture.dart';
import 'package:tasky/features/home/home_controller.dart';
import 'package:tasky/features/tasks/controller/tasks_controller.dart';
import 'package:tasky/model/task_model.dart';
import 'package:tasky/features/tasks/high_priority_screen.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder: (BuildContext context, TasksController controller, Widget? child) {
        final tasksList =controller.tasks;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        "High Priority Tasks",
                        style: TextStyle(
                          color: Color(0xFF15B86C),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    ...tasksList.where((e) => e.isHighPriority).take(4).map((element) {
                      return Row(
                        children: [
                          CusttomCheckBox(
                            value: element.isDone,
                            onChanged: (bool? value) {
                              final index = tasksList.indexWhere((e) {
                                return e.id == element.id;
                              });
                              controller.doneHighPriorityTasks(value, index);

                            },
                          ),

                          Expanded(
                            child: Text(
                              element.taskName,
                              style:
                              element.isDone?Theme.of(context).textTheme.titleLarge:
                              Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return HighPriorityScreen();
                        },
                      ),
                    );
                    controller.init();
                  },
                  child: Container(
                    height: 56,
                    width: 48,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ThemeController.isDark()?Color(0xFF6E6E6E):Color(0xFFD1DAD6),
                      ),
                    ),
                    child:CusttomSvgPicture(
                      path: "lib/assets/images/arrow-up-right.svg",
                      height: 24,
                      width: 24,
                    ),

                  ),
                ),
              ),
            ],
          ),
        );
      },

    );
  }
}
