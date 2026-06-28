import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/core/widgets/custtom_text_form_field.dart';
import 'package:tasky/model/task_model.dart';

class AddTask extends StatefulWidget {
  AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  bool isHighPriority = true;
  bool id = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Task")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  controller: taskNameController,
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
                  controller: taskDescriptionController,
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
                      style:Theme.of(context).textTheme.titleMedium,

                    ),
                    Switch(
                      value: isHighPriority,
                      onChanged: (bool value) {
                        setState(() {
                          isHighPriority = value;
                        });
                      },
                    ),
                  ],
                ),
                Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(fixedSize: Size(450, 40)),
                  onPressed: () async {
                    if (_key.currentState?.validate() ?? false) {
                      final taskJson = await PreferencesMangar().getString(
                        StorageKay.tasks,
                      );

                      List<dynamic> listTasks = [];
                      if (taskJson != null) {
                        listTasks = jsonDecode(taskJson);
                      }
                      TaskModel model = TaskModel(
                        taskName: taskNameController.text,
                        taskDescription: taskDescriptionController.text,
                        isHighPriority: isHighPriority,
                        id:id ,
                      );

                      listTasks.add(model.toJson());
                      final taskEncode = jsonEncode(listTasks);
                      await PreferencesMangar().setString(StorageKay.tasks, taskEncode);

                      Navigator.of(context).pop(true);
                    }
                  },
                  label: Text(" Add Task",
                  style:TextStyle(
                   fontSize: 14,
                  ) ,
                  ),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
