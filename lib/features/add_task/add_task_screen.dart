import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/core/widgets/custtom_text_form_field.dart';
import 'package:tasky/features/add_task/add_task_controller.dart';
import 'package:tasky/model/task_model.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({super.key});

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddTaskController>(
      create: (_) => AddTaskController(),
      child: Builder(
        builder: (BuildContext context) {
         final controller= context.read<AddTaskController>();
          return Scaffold(
            appBar: AppBar(title: Text("New Task")),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF282828),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      CusttomTextFormField(
                        controller: controller.taskNameController,
                        hintText: 'Finish UI design for login screen',
                        title: 'Task Name',
                        validator: (Value) {
                          if (Value == null || Value.trim().isEmpty) {
                            return "Please Enter Task name";
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      CusttomTextFormField(
                        controller:controller. taskDescriptionController,
                        maxLines: 5,
                        hintText:
                            'Finish onboarding UI and hand off to devs by Thursday',
                        title: "Task Description",
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF282828),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "High Priority",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Consumer<AddTaskController>(
                            builder: (BuildContext context, value, Widget? child) {
                              return Switch(
                                value: value.isHighPriority,
                                onChanged: (bool value) {
                                  controller.toggle(value);

                                },
                              );
                            },
                          ),
                        ],
                      ),
                      Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(450, 40),
                        ),
                        onPressed: () async {
                          context.read<AddTaskController>().addTask(context);
                        },
                        label: Text(
                          " Add Task",
                          style: TextStyle(fontSize: 14),
                        ),
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
