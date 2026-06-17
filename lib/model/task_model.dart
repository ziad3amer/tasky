import 'dart:convert';
import 'dart:ffi';

class TaskModel {
  final String taskName;
  final String taskDescription;
  final bool isHighPriority;
  final bool id;
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
