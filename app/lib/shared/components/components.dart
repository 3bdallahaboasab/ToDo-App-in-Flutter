import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defultFormField({
  @required Function onTap,
  @required Function onSubmit,
  @required TextEditingController controller,
  // required TextInputType type,
  @required String text,
  @required IconData prefix,
  IconData suffix,
  Function valedate,
  bool isPassword = false,
  @required Function passwordFun,
}) =>
    TextFormField(
      obscureText: isPassword,
      controller: controller,
      onTap: onTap,
      onFieldSubmitted: (s) {},
      validator: valedate,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(),
          labelText: text,
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: () {
                    passwordFun();
                  },
                  icon: Icon(Icons.remove_red_eye))
              : null),
    );

Widget defultbutton({
  Color color = Colors.blue,
  double width = double.infinity,
  // required Function function,
  @required String text,
  @required Function onPressed,
}) =>
    Container(
      color: color,
      width: width,
      child: MaterialButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );

Widget buildTaskIcon(Map model) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            child: Text("${model['time']}"),
            radius: 40,
            backgroundColor: Colors.pink,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model['title']}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("${model['date']}"),
              ],
            ),
          ),
        ],
      ),
    );
