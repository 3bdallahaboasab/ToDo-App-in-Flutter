import 'package:app/cubit/cubit.dart';
import 'package:app/cubit/states.dart';
import 'package:app/modules/archived_task/archived_task.dart';
import 'package:app/modules/done_task/done_task.dart';
import 'package:app/modules/new_task/new_task.dart';
import 'package:app/shared/components/components.dart';
import 'package:app/shared/components/constents.dart';
import 'package:conditional_builder/conditional_builder.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class HomeLayout extends StatelessWidget {
  var titleControler = TextEditingController();
  var dateControler = TextEditingController();
  var timeControler = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  // AppCubit cubit = AppCubit.get(context);

  @override
  // void initState() {
  //   super.initState();
  //   creatDatabase();
  // }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..creatDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) => {
          if (state is insertDataBaseState) {Navigator.pop(context)}
        },
        builder: (BuildContext context, AppStates state) => Scaffold(
          key: scaffoldKey,
          body: ConditionalBuilder(
            condition: true,
            builder: ((context) => AppCubit.get(context)
                .screens[AppCubit.get(context).currentIndex]),
            fallback: (((context) => Center())),
          ),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 167, 47, 236),
            title: Text(AppCubit.get(context)
                .titels[AppCubit.get(context).currentIndex]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedIconTheme: IconThemeData(color: Colors.black),
            selectedItemColor: Color.fromARGB(255, 0, 0, 0),
            landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                  color: Color.fromARGB(255, 167, 47, 236),
                ),
                label: "New Task ",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.done,
                  color: Color.fromARGB(255, 167, 47, 236),
                ),
                label: "Done Task ",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive,
                  color: Color.fromARGB(255, 167, 47, 236),
                ),
                label: "Archived Task ",
              ),
            ],
            currentIndex: AppCubit.get(context).currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              AppCubit.get(context).ChangeButton(index);
              // ChangeButton();
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 167, 47, 236),
            onPressed: () {
              if (AppCubit.get(context).isBouttomsheetOpen) {
                if (formKey.currentState.validate()) {
                  AppCubit.get(context).insertToDatabase(
                      title: titleControler.text,
                      time: timeControler.text,
                      date: dateControler.text);
                  // return titleControler.text;
                  // insertToDatabase(
                  //   date: dateControler.text,
                  //   title: titleControler.text,
                  //   time: timeControler.text,
                  // ).then((value) {
                  //   Navigator.pop(context);

                  // isBouttomsheetOpen = false;
                  // setState(() {
                  //   icon = Icons.edit;
                  // });

                }
              } else {
                // AppCubit.get(context).icon = Icons.add;

                scaffoldKey.currentState
                    .showBottomSheet(
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
                                            builder: (context, child) {
                                              return Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    colorScheme:
                                                        ColorScheme.light(
                                                      primary: Color.fromARGB(
                                                          255,
                                                          167,
                                                          47,
                                                          236), // header background color
                                                      onPrimary: Colors
                                                          .black, // header text color
                                                      onSurface: Color.fromARGB(
                                                          255,
                                                          167,
                                                          47,
                                                          236), // body text color
                                                    ),
                                                    textButtonTheme:
                                                        TextButtonThemeData(
                                                      style:
                                                          TextButton.styleFrom(
                                                        primary: Color.fromARGB(
                                                            255,
                                                            167,
                                                            47,
                                                            236), // button text color
                                                      ),
                                                    ),
                                                  ),
                                                  child: child);
                                            },
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
                                      builder: (context, child) {
                                        return Theme(
                                            data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                                primary: Color.fromARGB(
                                                    255,
                                                    167,
                                                    47,
                                                    236), // header background color
                                                onPrimary: Colors
                                                    .white, // header text color
                                                onSurface: Color.fromARGB(
                                                    255,
                                                    167,
                                                    47,
                                                    236), // body text color
                                              ),
                                              textButtonTheme:
                                                  TextButtonThemeData(
                                                style: TextButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255,
                                                      167,
                                                      47,
                                                      236), // button text color
                                                ),
                                              ),
                                            ),
                                            child: child);
                                      },
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2022),
                                      lastDate: DateTime(2030),
                                    ).then((value) {
                                      dateControler.text = DateFormat.yMMMd()
                                          .format(value)
                                          .toString();
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
                    )
                    .closed
                    .then((value) {
                  AppCubit.get(context)
                      .changeBottomSheet(isShow: false, icon: Icons.edit);
                });
                AppCubit.get(context)
                    .changeBottomSheet(isShow: true, icon: Icons.add);
                AppCubit.get(context).isBouttomsheetOpen = true;

                dateControler.clear();
                timeControler.clear();
                titleControler.clear();
              }
            },
            child: Icon(AppCubit.get(context).fabIcon),
          ),
        ),
      ),
    );
  }
}
