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
  List<Map> newTasks = [];

  List<Map> doneTasks = [];

  List<Map> archTasks = [];

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
      getDataFromDB(db);
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
        getDataFromDB(db);
      }).catchError((error) {
        print(error.toString());
      });
    });
  }

  void getDataFromDB(Database db) async {
    newTasks = [];
    doneTasks = [];
    archTasks = [];

    await db.rawQuery("SELECT * FROM tasks").then((value)
    {
      tasksList = value;
      value.forEach((element) {
        if(element['status'] == "new") {
          newTasks.add(element);
        } else if (element['status'] == "done") {
          doneTasks.add(element);
        } else {
          archTasks.add(element);
        }

      });
      emit(GetDB());

    });
  }

  void updateDB({required String status, required int id}) async{
    await db.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
    [status, id]).then((value)
    {
      emit(UpdateDB());
      getDataFromDB(db);
    }
    );
  }

  void deleteDB({required int id}) async{
    await db.rawUpdate('DELETE tasks WHERE id = ?',
        [id]).then((value)
    {
      emit(DeleteDB());
      getDataFromDB(db);
    }
    );
  }
  void changeBottomSheetState({required bool isShow, required Icon icon}) {
    isBottomSheet = isShow;
    fabIcon = icon;

    emit(BottomSheetStates());
  }
}
