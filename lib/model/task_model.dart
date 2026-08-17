import 'dart:convert';
import 'dart:ffi';

import 'package:hive_ce_flutter/adapters.dart';

part 'task_model.g.dart';
@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  final String taskName;
  @HiveField(1)
  final String taskDescription;
  @HiveField(2)
  final bool isHighPriority;
  @HiveField(3)
  final bool id;
  @HiveField(4)
  bool isDone;

  TaskModel({
    required this.taskName,
    required this.taskDescription,
    required this.isHighPriority,
    required this.id,
    this.isDone = false,
  });

  factory TaskModel.fromjson(Map<String, dynamic> json) {
    return TaskModel(
      taskName: json["taskName"],
      taskDescription: json["taskDescription"],
      isHighPriority: json["isHighPriority"],
      id: json["id"],
      isDone: json["isDone"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "taskName": taskName,
      "taskDescription": taskDescription,
      "isHighPriority": isHighPriority,
      "id": id,
      "isDone": isDone,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "taskName": taskName,
      "taskDescription": taskDescription,
      "isHighPriority": isHighPriority,
      "id": id,
      "isDone": isDone,
    };
  }
}
