import 'package:app/cubit/cubit.dart';
import 'package:app/cubit/states.dart';
import 'package:app/shared/components/components.dart';
import 'package:app/shared/components/constents.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoneTask extends StatelessWidget {
  // const NewTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tasks = AppCubit.get(context).donetasks;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return conditinalBuilderdone(tasks: AppCubit.get(context).donetasks);
      },
    );
  }
}
