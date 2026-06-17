import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AchievedTasksWidget extends StatelessWidget {
  const AchievedTasksWidget({
    super.key,
    required this.totaldoneTasks,
    required this.totalTask,
    required this.percent,
  });

  final int totaldoneTasks;
  final int totalTask;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,

        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(16),
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
              SizedBox(height: 4),
              Text(
                "${totaldoneTasks} Out of ${totalTask}",
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
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    value: percent,
                    backgroundColor: Color(0xFF6D6D6D),
                    valueColor: AlwaysStoppedAnimation(Color(0XFF15B86C)),
                    strokeWidth: 4,
                  ),
                ),
              ),
              Text(
                "${((percent * 100).toInt())}%",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
