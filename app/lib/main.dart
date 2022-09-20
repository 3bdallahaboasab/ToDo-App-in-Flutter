import 'dart:developer';

import 'package:app/shared/Bloc_observer.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'layout/home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Tourism ',
      theme: ThemeData(
        fontFamily: 'ElMessiri',
        primarySwatch: Colors.blue,
      ),
      home: HomeLayout(),
    );
  }
}
