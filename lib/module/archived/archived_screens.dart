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
