import 'package:app/cubit/cubit.dart';
import 'package:conditional_builder/conditional_builder.dart';
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

Widget buildTaskIcon(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              child: Text("${model['time']}"),
              radius: 40,
              backgroundColor: Color.fromARGB(255, 167, 47, 236),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,

                  mainAxisSize: MainAxisSize.min,

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "${model['title']}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("${model['date']}"),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 50,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: "done", id: model['id']);
                },
                icon: Icon(Icons.check_box),
                color: Colors.green),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: "archive", id: model['id']);
              },
              icon: Icon(Icons.archive_rounded),
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
      background: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Icon(
              Icons.delete,
              size: 25,
              color: Colors.white,
            ),
            color: Colors.red,
            width: 410,
            height: 500,
          ),
        ],
      ),
    );

Widget conditinalBuilder({@required List<Map> tasks}) => Center(
      child: ConditionalBuilder(
        condition: tasks.length > 0,
        builder: (context) {
          return ListView.separated(
              itemBuilder: (context, index) =>
                  buildTaskIcon(AppCubit.get(context).newtasks[index], context),
              separatorBuilder: ((context, index) => Container(
                    height: 1.0,
                    width: double.infinity,
                    color: Colors.grey[300],
                  )),
              itemCount: AppCubit.get(context).newtasks.length);
        },
        fallback: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image(
                  image: AssetImage("assets/img/add.png"),

                  // fit: BoxFit.cover,

                  height: 400,
                ),
              ),
              Text(
                "There is No Task Yet , Press The Icon and Add Some ..",
                style: TextStyle(fontSize: 17),
              )
            ],
          );
        },
      ),
    );

Widget conditinalBuilderdone({@required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) {
        return ListView.separated(
            itemBuilder: (context, index) =>
                buildTaskIcon(AppCubit.get(context).donetasks[index], context),
            separatorBuilder: ((context, index) => Container(
                  height: 1.0,
                  width: double.infinity,
                  color: Colors.grey[300],
                )),
            itemCount: AppCubit.get(context).donetasks.length);
      },
      fallback: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: AssetImage("assets/img/add.png"),
                // fit: BoxFit.cover,
                height: 400,
              ),
            ),
            Text(
              "There is No Task Yet ",
              style: TextStyle(fontSize: 17),
            )
          ],
        );
      },
    );

Widget conditinalBuilderarch({@required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) {
        return ListView.separated(
            itemBuilder: (context, index) => buildTaskIcon(
                AppCubit.get(context).archivetasks[index], context),
            separatorBuilder: ((context, index) => Container(
                  height: 1.0,
                  width: double.infinity,
                  color: Colors.grey[300],
                )),
            itemCount: AppCubit.get(context).archivetasks.length);
      },
      fallback: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: AssetImage("assets/img/add.png"),
                // fit: BoxFit.cover,
                height: 400,
              ),
            ),
            Text(
              "There is No Task Yet ",
              style: TextStyle(fontSize: 17),
            )
          ],
        );
      },
    );
