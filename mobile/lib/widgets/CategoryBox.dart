import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/models/enums/category.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/pages/Task/ListTaskScreen.dart';
import 'package:todo_list/widgets/CategoryIcon.dart';

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
          Navigator.pushNamed(context, ListTaskScreen.routeName,
              arguments: type);
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
