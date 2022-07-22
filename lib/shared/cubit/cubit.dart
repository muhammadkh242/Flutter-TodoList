import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cubit/states.dart';

import '../../module/archived/archived_screens.dart';
import '../../module/done/done_screen.dart';
import '../../module/tasks/tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> pages = [
    const TasksScreen(),
    const DoneScreen(),
    const ArchivedScreen()
  ];

  List<String> titles = [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];

  void changeBottomNavIndex(int index){
    currentIndex = index;
    emit(BottomNavStates());
  }


}