import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky/core/constances/storage_kay.dart';
import 'package:tasky/core/enums/task_item_actions_enum.dart';
import 'package:tasky/core/services/preferences_mangar.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/core/widgets/custtom_text_form_field.dart';
import 'package:tasky/model/task_model.dart';

import '../core/widgets/custtom_check_box.dart';

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  });

  final TaskModel model;
  final Function(bool?) onChanged;
  final Function(int?) onDelete;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeController.isDark()
              ? Colors.transparent
              : Color(0xFFD1DAD6),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 8),
          CusttomCheckBox(
            value: model.isDone,
            onChanged: (bool? value) => onChanged(value),
          ),
          SizedBox(width: 16),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.taskName,
                  style: model.isDone
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.titleMedium,

                  maxLines: 1,
                ),
                if (model.taskDescription.isNotEmpty)
                  Text(
                    model.taskDescription,
                    style: TextStyle(
                      color: Color(0xFFC6C6C6),
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          PopupMenuButton<TaskItemActionsEnum>(
            icon: Icon(
              Icons.more_vert,
              color: ThemeController.isDark()
                  ? (model.isDone ? Color(0xFFA0A0A0) : Color(0xFFC6C6C6))
                  : (model.isDone ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
            ),
            onSelected: (value) async {
              switch (value) {
                case TaskItemActionsEnum.markAsDone:
                  onChanged(!model.isDone);
                case TaskItemActionsEnum.delete:
                  await _showAlertDialog(context);

                  onDelete(model.id as int?);
                case TaskItemActionsEnum.edit:
                  final result = _showButtonSheet(context, model);
                  if (result == true) {
                    onEdit();
                  }
              }
            },

            itemBuilder: (context) => TaskItemActionsEnum.values.map((e) {
              return PopupMenuItem<TaskItemActionsEnum>(
                value: e,
                child: Text(e.name),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  _showAlertDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("A7AA no Delete "),
          content: Text("Are you sure Delete Task"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onDelete(model.id as int?);
                Navigator.pop(context);
              },
              child: Text("Delete"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showButtonSheet(BuildContext context, TaskModel model) {
    TextEditingController taskNameController = TextEditingController(
      text: model.taskName,
    );
    TextEditingController taskDescriptionController = TextEditingController(
      text: model.taskDescription,
    );
    GlobalKey<FormState> _kay = GlobalKey<FormState>();
    bool isHighPriority = model.isHighPriority;
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: _kay,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
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
                        if (_kay.currentState?.validate() ?? false) {
                          final taskJson = await PreferencesMangar().getString(
                            StorageKay.tasks,
                          );

                          List<dynamic> listTasks = [];
                          if (taskJson != null) {
                            listTasks = jsonDecode(taskJson);
                          }
                          TaskModel newModel = TaskModel(
                            id: model.id,
                            taskName: taskNameController.text,
                            taskDescription: taskDescriptionController.text,
                            isHighPriority: isHighPriority,
                            isDone: model.isDone);

                          final item = listTasks.firstWhere(
                            (e) => e['id'] == model.id,
                          );
                          final int index = listTasks.indexOf(item);
                          listTasks[index] = newModel;

                          final taskEncode = jsonEncode(listTasks);
                          await PreferencesMangar().setString(
                            StorageKay.tasks,
                            taskEncode,
                          );

                          Navigator.of(context).pop(true);
                        }
                      },
                      label: Text(" Edit Task", style: TextStyle(fontSize: 14)),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
