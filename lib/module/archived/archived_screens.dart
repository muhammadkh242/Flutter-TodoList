import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class ArchivedScreen extends StatelessWidget {
  const ArchivedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (BuildContext context, state){
          var tasksList = AppCubit.get(context).archTasks;
          print("length ${tasksList.length}");
          return ConditionalBuilder(
            condition: tasksList.isNotEmpty,
            builder: (context) => ListView.separated(
                itemBuilder: (context, index) {
                  return buildTaskItem(tasksList[index], context);
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: double.infinity,
                      height: 2.0,
                      color: Colors.grey[300],
                    ),
                  );
                },
                itemCount: tasksList.length),
            fallback: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty_outlined,
                    size: 50.0,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "No Tasks",
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (BuildContext context, state){}
    );
  }
}
