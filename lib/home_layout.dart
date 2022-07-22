import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/module/archived/archived_screens.dart';
import 'package:todo/module/done/done_screen.dart';
import 'package:todo/module/tasks/tasks_screen.dart';
import 'package:todo/shared/constants.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  late Database db;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheet = false;
  Icon fabIcon = const Icon(Icons.add);
  var formKey = GlobalKey<FormState>();

  HomeLayout({Key? key}) : super(key: key);

  bool isLow = false;
  bool isMedium = false;
  bool isHigh = false;
  String _priority= "";
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state){},
        builder: (BuildContext context, state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.grey[200],
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (isBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    insertIntoDB(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text,
                        priority: _priority!)
                        .then((value) {
                      getDataFromDB(db).then((value) {
                        Navigator.pop(context);
                        isBottomSheet = false;
/*                  setState(() {
                    fabIcon = const Icon(Icons.add);
                  });*/
                      });
                    });
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Form(key: formKey, child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
                      padding: const EdgeInsets.all(15.0),
                      height: 380.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: const InputDecoration(
                                label: Text("Title"),
                                prefixIcon: Icon(Icons.title),
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Title must not be Empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: timeController,
                            keyboardType: TextInputType.datetime,
                            onTap: () {
                              showTimePicker(context: context, initialTime: TimeOfDay.now())
                                  .then((value) {
                                print(value);
                                timeController.text = value!.format(context).toString();
                              });
                            },
                            decoration: const InputDecoration(
                                label: Text("Time"),
                                prefixIcon: Icon(Icons.watch_later_outlined),
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Time must not be Empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: dateController,
                            keyboardType: TextInputType.datetime,
                            onTap: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 30)))
                                  .then((value) {
                                print(value);
                                dateController.text = DateFormat.yMMMEd().format(value!);
                              });
                            },
                            decoration: const InputDecoration(
                                label: Text("Date"),
                                prefixIcon: Icon(Icons.date_range_outlined),
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Date must not be Empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            "Priority",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChoiceChip(
                                padding: const EdgeInsets.all(10.0),
                                label: const Text(
                                  "Low",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                                ),
                                selected: isLow,
                                onSelected: (isSelected) {
/*                                setState(() {
                                  isLow = isSelected;
                                  isMedium = false;
                                  isHigh = false;
                                  _priority = "Low";
                                });*/
                                },
                                selectedColor: Colors.blue,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              ChoiceChip(
                                padding: const EdgeInsets.all(10.0),
                                label: const Text(
                                  "Medium",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                                ),
                                selected: isMedium,
                                onSelected: (isSelected) {
/*                                setState(() {
                                  print(isSelected);
                                  isMedium = isSelected;
                                  isLow = false;
                                  isHigh = false;
                                  _priority = "Medium";
                                });*/
                                },
                                selectedColor: Colors.blue,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              ChoiceChip(
                                padding: const EdgeInsets.all(10.0),
                                label: const Text(
                                  "High",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                                ),
                                selected: isHigh,
                                onSelected: (isSelected) {
/*                                setState(() {
                                  print(isSelected);
                                  isHigh = isSelected;
                                  isMedium = false;
                                  isLow = false;
                                  _priority = "High";
                                });*/
                                },
                                selectedColor: Colors.blue,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30.0),
                        )),
                    elevation: 180.0,
                  )
                      .closed
                      .then((value) {
                    isBottomSheet = false;
/*              setState(() {
                fabIcon = const Icon(Icons.add);
              });*/
                  });
                  isBottomSheet = true;
/*            setState(() {
              fabIcon = const Icon(Icons.check);
            });*/
                }
              },
              child: fabIcon,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_sharp), label: "Done"),
                BottomNavigationBarItem(icon: Icon(Icons.archive), label: "Archived"),
              ],
              onTap: (index) {
                cubit.changeBottomNavIndex(index);
              },
            ),
            body: cubit.pages[cubit.currentIndex],
          );
        },
      ),
    );
  }

  // ___________________________LOCAL DB_____________________
  void createDB() async {
    db = await openDatabase('tasks.db', version: 1, onCreate: (db, version) {
      print("db created");
      db
          .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print("created table");
      }).catchError((error) {
        print(error.toString());
      });
    }, onOpen: (db) {
      print("opened db");
      getDataFromDB(db).then((value) {
        print("my data $value");
/*        setState(() {
          tasksList = value;
        });*/
      });
    });
  }

  Future insertIntoDB(
      {required String title,
        required String date,
        required String time,
        required String priority}) async {
    return await db.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO tasks (title, date, time, priority, status) VALUES ("$title", "$date", "$time", "$priority", "new")')
          .then((value) {
        print("$value inserted");
      }).catchError((error) {
        print(error.toString());
      });
      return Future(() => null);
    });
  }

  Future<List<Map>> getDataFromDB(Database db) async {
    return await db.rawQuery("SELECT * FROM tasks");
  }
}
