import 'package:app/shared/components/components.dart';
import 'package:app/shared/components/constents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewTask extends StatelessWidget {
  // const NewTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => buildTaskIcon(tasks[index]),
        separatorBuilder: ((context, index) => Container(
              height: 1.0,
              width: double.infinity,
              color: Colors.grey[300],
            )),
        itemCount: tasks.length);
  }
}
