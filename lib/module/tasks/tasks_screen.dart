import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (BuildContext context, state){
          var tasksList = AppCubit.get(context).newTasks;
          print("length ${tasksList.length}");
          return ListView.separated(
              itemBuilder: (context, index){ return buildTaskItem(tasksList[index], context); },
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
        },
        listener: (BuildContext context, state){}
    );
  }
}
