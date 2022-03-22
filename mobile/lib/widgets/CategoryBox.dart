import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/models/enums/category.dart';
import 'package:todo_list/screens/Task/ListTaskScreen.dart';
import 'package:todo_list/widgets/CategoryIcon.dart';
import 'package:transition/transition.dart';

class CategoryBox extends StatelessWidget {
  const CategoryBox(
      {required this.name,
      required this.icon,
      required this.type,
      required this.total});

  final String name;
  final Category type;
  final CategoryIcon icon;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: InkWell(
        onTap: () async {
          Navigator.push(
              context,
              Transition(
                  transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
                  child: ListTaskScreen(category: type)));
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: ListTile(
                  leading: icon,
                  title: Text(total.toString()),
                  subtitle: Text(name, maxLines: 2)),
            )),
      ),
    );
  }
}
