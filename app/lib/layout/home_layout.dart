import 'package:app/modules/archived_task/archived_task.dart';
import 'package:app/modules/done_task/done_task.dart';
import 'package:app/modules/new_task/new_task.dart';
import 'package:app/shared/components/components.dart';
import 'package:app/shared/components/constents.dart';
import 'package:conditional_builder/conditional_builder.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var titleControler = TextEditingController();
  var dateControler = TextEditingController();
  var timeControler = TextEditingController();
  int currentIndex = 0;
  bool isBouttomsheetOpen = false;
  IconData icon = Icons.edit;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  List<Widget> screens = [
    NewTask(),
    DoneTask(),
    ArchivedTask(),
  ];

  List<String> titels = [
    "New Task ",
    "Done Task",
    "Archived Task",
  ];

  Database database;

  @override
  void initState() {
    super.initState();
    creatDatabase();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: ConditionalBuilder(
        condition: tasks.length > 0,
        builder: ((context) => screens[currentIndex]),
        fallback: (((context) => Center())),
      ),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(titels[currentIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "New Task ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: "Done Task ",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive), label: "Archived Task "),
        ],
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(
            () {
              currentIndex = index;
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          if (isBouttomsheetOpen) {
            if (formKey.currentState.validate()) {
              // return titleControler.text;
              insertToDatabase(
                date: dateControler.text,
                title: titleControler.text,
                time: timeControler.text,
              ).then((value) {
                Navigator.pop(context);
                isBouttomsheetOpen = false;
                setState(() {
                  icon = Icons.edit;
                });
              });
            }
          } else {
            setState(() {
              icon = Icons.add;
            });
            scaffoldKey.currentState.showBottomSheet(
              (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      defultFormField(
                          onTap: () {},
                          onSubmit: () {},
                          controller: titleControler,
                          text: "Task Title",
                          prefix: Icons.title,
                          valedate: (String val) {
                            if (val.isEmpty) {
                              return "The Title Must Not Be Empty";
                            }
                          },
                          passwordFun: () {}),
                      SizedBox(
                        height: 10,
                      ),
                      defultFormField(
                          onTap: () {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              timeControler.text =
                                  value.format(context).toString();
                            });
                          },
                          onSubmit: () {},
                          controller: timeControler,
                          text: "Task Time",
                          prefix: Icons.watch_later_rounded,
                          valedate: (String val) {
                            if (val.isEmpty) {
                              return "The Time Must Not Be Empty";
                            }
                          },
                          passwordFun: () {}),
                      SizedBox(
                        height: 10,
                      ),
                      defultFormField(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2030),
                            ).then((value) {
                              dateControler.text =
                                  DateFormat.yMMMd().format(value).toString();
                              // print();
                            });
                          },
                          onSubmit: () {},
                          controller: dateControler,
                          text: "Task Date",
                          prefix: Icons.title,
                          valedate: (String val) {
                            if (val.isEmpty) {
                              return "The Date Must Not Be Empty";
                            }
                          },
                          passwordFun: () {}),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
            isBouttomsheetOpen = true;
          }
        },
        child: Icon(icon),
      ),
    );
  }

  void creatDatabase() async {
    database = await openDatabase(
      'todo.db',
      onCreate: (database, version) {
        print("database Created");
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT, time TEXT , status TEXT)')
            .then((value) {
          print("table created");
        }).catchError((errors) {
          print("Error is ${errors}");
        });
      },
      onOpen: (database) {
        print("Database Opened");
        getDataFromDatabase(database).then((value) {
          tasks = value;
          print(tasks[0]);
        });
      },
      version: 1,
    ).catchError((onError) {
      print("error is ${onError}");
    });
  }

  Future insertToDatabase(
      {@required String title,
      @required String time,
      @required String date}) async {
    await database.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO tasks ( title ,date, time, status) VALUES ("$title","$date","$time","New")');
      return null;
    }).then((value) {
      print(" $value Insert Sucssesfully");
    }).catchError((onError) {
      print("error ${onError} ");
    });
    return null;
  }

  Future<List<Map>> getDataFromDatabase(database) async {
    return await database.rawQuery("SELECT * FROM tasks ");
  }

  void deleteFromDatabase() {}
}
