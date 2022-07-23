import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  HomeLayout({Key? key}) : super(key: key);


  bool isMedium = false;
  bool isHigh = false;
  String _priority = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {

        },
        builder: (BuildContext context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.grey[200],
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDB(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text,
                        priority: "low");
                    Navigator.pop(context);

                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Form(
                            key: formKey,
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0))),
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
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        print(value);
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        label: Text("Time"),
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
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
                                              lastDate: DateTime.now().add(
                                                  const Duration(days: 30)))
                                          .then((value) {
                                        print(value);
                                        dateController.text =
                                            DateFormat.yMMMEd().format(value!);
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        label: Text("Date"),
                                        prefixIcon:
                                            Icon(Icons.date_range_outlined),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                        selected: cubit.isLow,
                                        onSelected: (isSelected) {
                                          cubit.changePriorityToLow(isSelected);
                                          print("low state ${cubit.isLow}");
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
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
                      .then((value)
                  {
                    cubit.changeBottomSheetState(isShow: false, icon: const Icon(Icons.add));

                  });
                  cubit.changeBottomSheetState(isShow: true, icon: const Icon(Icons.check));

                }
              },
              child: cubit.fabIcon,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_sharp), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: "Archived"),
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


}
