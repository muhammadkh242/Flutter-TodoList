import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/module/archived/archived_screens.dart';
import 'package:todo/module/done/done_screen.dart';
import 'package:todo/module/tasks/tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {

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

  late Database db;
  var scaffoldKey  = GlobalKey<ScaffoldState>();
  bool isBottomSheet = false;

  @override
  void initState() {
    super.initState();
    createDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scaffoldKey.currentState?.showBottomSheet((context){

            return Container(
              height: 100.0,
              color: Colors.red,
            );

          });
        },
        child: isBottomSheet? const Icon(Icons.check) : const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items:
        const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Tasks"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_sharp),
            label: "Done"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: "Archived"
          ),
        ],
        onTap: (index){
          setState((){
            currentIndex = index;
          });
        },
      ),
      body: pages[currentIndex],
    );
  }

  void createDB() async{
    db = await openDatabase(
      'tasks.db',
      version: 1,

      onCreate: (db, version){
        print("db created");
        db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value){
          print("created table");
        }).catchError((error){
          print(error.toString());
        });
      },

      onOpen: (db){
        print("opened db");
      }
    );

  }

  void insertIntoDB(){
    db.transaction((txn){
      txn.rawInsert('INSERT INTO tasks (title, date, time, status) VALUES ("FIRST", "TIME ONE", "DATE ONE", "STATUS ONE")')
      .then((value){
        print("$value inserted") ;
      })
      .catchError((error){
        print(error.toString());
      });
      return Future(() => null);
    });
  }
}
