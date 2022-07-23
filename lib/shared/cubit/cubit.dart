import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
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
  bool isLow = false;
  late Database db;
  List<Map> tasksList = [];
  bool isBottomSheet = false;
  Icon fabIcon = const Icon(Icons.add);

  void changeBottomNavIndex(int index) {
    currentIndex = index;
    emit(BottomNavStates());
  }

  void changePriorityToLow(bool isSelected) {
    isLow = isSelected;
    emit(LowPriorityState());
  }

  // ___________________________LOCAL DB_____________________
  void createDB() {
    openDatabase('tasks.db', version: 1, onCreate: (db, version) {
      print("db created");
      db
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, priority TEXT, status TEXT)')
          .then((value) {
        print("created table");
      }).catchError((error) {
        print(error.toString());
      });
    }, onOpen: (db) {
      print("opened db");
      getDataFromDB(db).then((value) {
        print("my data $value");
        tasksList = value;
        emit(GetDB());
      });
    }).then((value) {
      db = value;
      emit(CreateDB());
    });
  }

  void insertIntoDB(
      {required String title,
      required String date,
      required String time,
      required String priority}) async {
    await db.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks (title, date, time, priority, status) VALUES ("$title", "$date", "$time", "$priority", "new")')
          .then((value)
      {
        print("$value inserted");
        emit(InsertDB());
        getDataFromDB(db).then((value)
        {
          tasksList = value;
          emit(GetDB());

        });
      }).catchError((error) {
        print(error.toString());
      });
    });
  }

  Future<List<Map>> getDataFromDB(Database db) async {
    return await db.rawQuery("SELECT * FROM tasks");
  }

  void changeBottomSheetState({required bool isShow, required Icon icon}) {
    isBottomSheet = isShow;
    fabIcon = icon;

    emit(BottomSheetStates());
  }
}
