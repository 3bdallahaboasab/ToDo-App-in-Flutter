import 'package:app/cubit/states.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../modules/archived_task/archived_task.dart';
import '../modules/done_task/done_task.dart';
import '../modules/new_task/new_task.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(inatitalState());

  static AppCubit get(context) => BlocProvider.of(context);

  Database database;
  int currentIndex = 0;
  List<Map> donetasks = [];
  List<Map> archivetasks = [];
  List<Map> newtasks = [];

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

  void ChangeButton(int index) {
    currentIndex = index;
    emit(ButtonChangeState());
  }

  void creatDatabase() {
    openDatabase(
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
        getDataFromDatabase(database);
      },
      version: 1,
    ).catchError((onError) {
      print("error is ${onError}");
    }).then((value) {
      database = value;
      emit(CreateDataBaseState());
    });
    ;
  }

  insertToDatabase(
      {@required String title,
      @required String time,
      @required String date}) async {
    await database.transaction((txn) {
      txn.rawInsert(
          'INSERT INTO tasks ( title ,date, time, status) VALUES ("$title","$date","$time","new")');
      return null;
    }).then((value) {
      print(" $value Insert Sucssesfully");
      emit(insertDataBaseState());
      getDataFromDatabase(database);
    }).catchError((onError) {
      print("error ${onError} ");
    });
    return null;
  }

  void getDataFromDatabase(database) {
    newtasks = [];
    donetasks = [];
    archivetasks = [];
    database.rawQuery("SELECT * FROM tasks ").then((value) {
      value.forEach((element) {
        if (element['status'] == "new")
          newtasks.add(element);
        else if (element['status'] == "done")
          donetasks.add(element);
        else
          archivetasks.add(element);

        print(element['status']);
      });

      emit(getDataBaseState());
    });
  }

  void deleteFromDatabase() {}

  bool isBouttomsheetOpen = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheet({@required bool isShow, @required IconData icon}) {
    fabIcon = icon;
    isBouttomsheetOpen = isShow;
    emit(changeIconState());
  }

  void updateData({@required String status, @required int id}) {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);

      emit(updateDataState());
    });
  }

  void deleteData({@required int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);

      emit(deleteDataState());
    });
  }
}
