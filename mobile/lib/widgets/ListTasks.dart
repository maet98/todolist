import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/models/enums/status.dart';
import 'package:todo_list/models/task.dart';

// ignore: must_be_immutable
class ListTasks extends StatefulWidget {
  static const String routeName = '/tasks';
  List<Task> tasks;
  Function refresh;
  Function updateTask;

  ListTasks(
      {Key? key,
      required this.tasks,
      required this.refresh,
      required this.updateTask})
      : super(key: key);

  @override
  _ListTasks createState() => _ListTasks();
}

class _ListTasks extends State<ListTasks> {
  String getDateFormat(DateTime date) {
    var today = DateTime.now();
    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return DateFormat.Hm().format(date);
    } else {
      String year = (today.year != date.year) ? ", ${date.year}" : "";
      return "${DateFormat.MMMMEEEEd().format(date)}$year ${DateFormat.Hm().format(date)}";
    }
  }

  bool isLate(DateTime date) {
    return DateTime.now().compareTo(date) > 0;
  }

  List<Widget> getTasks() {
    List<Widget> ans = [];
    if (widget.tasks.length == 0) {
      ans.add(Container(
          child: Text("No tasks found",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey))));
    } else {
      for (var task in widget.tasks) {
        if(task.status == Status.COMPLETED) {
          TextStyle subtitleStyle = TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
            fontSize: 14,
          );
          TextStyle titleStyle = TextStyle(
            color: Colors.grey ,
            decoration: TextDecoration.lineThrough,
            fontSize: 20,
            fontWeight: FontWeight.w600
          );
          ans.add(ListTile(
              leading: Icon(Icons.check, color: Colors.grey),
              title: InkWell(
                onTap: () {
                  widget.updateTask(task);
                },
                child: Text(task.title, style: titleStyle)),
              subtitle: InkWell(
                onTap: () {
                  widget.updateTask(task);
                },
                child:  Text(
                  getDateFormat(task.due),
                  
                  style: subtitleStyle,
              ),
            ),
          ));
        } else {
         TextStyle titleStyle = TextStyle(
            color: Colors.black ,
            fontSize: 20,
            fontWeight: FontWeight.w600
          );
          ans.add(ListTile(
              leading: Checkbox(
                value: (task.status == Status.COMPLETED),
                onChanged: (bool? value) {
                  task.status = Status.COMPLETED;
                  widget.updateTask(context, task, direct: true);
                },
              ),
              title: InkWell(
                onTap: () {
                  widget.updateTask(task);
                },
                child: Text(task.title, style: titleStyle)),
              subtitle: InkWell(
                onTap: () {
                  widget.updateTask(task);
                },
                child:  Text(
                  getDateFormat(task.due),
                  style:
                    TextStyle(color: isLate(task.due) ? Colors.red : Colors.grey),
              ),
            ),
          ));

        }
      }
    }

    return ans;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: Colors.white,
        ),
        child: Column(children: getTasks()));
  }
}
