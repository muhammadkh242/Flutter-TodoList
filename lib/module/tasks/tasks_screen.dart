import 'package:flutter/material.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/constants.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index){ return buildTaskItem(tasksList[index]); },
        separatorBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              height: 2.0,
              color: Colors.grey[300],
            ),
          );
          } ,
        itemCount: tasksList.length
    );
  }
}
