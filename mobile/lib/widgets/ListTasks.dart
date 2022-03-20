import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/pages/Task/addTask.dart';
import 'package:todo_list/services/Services.dart';

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
      return "${DateFormat.MMMMEEEEd().format(date)} ${DateFormat.Hm().format(date)}";
    }
  }

  bool isLate(DateTime date) {
    return DateTime.now().compareTo(date) > 0;
  }

  List<Widget> getTasks() {
    List<Widget> ans = [];
    if (widget.tasks.length == 0) {
      ans.add(Container(
          child: Text("There aren't any task yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey))));
    } else {
      for (var task in widget.tasks) {
        ans.add(InkWell(
          onTap: () async {
            widget.updateTask(context, task);
          },
          child: ListTile(
            leading: Icon(Icons.offline_bolt),
            title: Text(task.title),
            subtitle: Text(
              getDateFormat(task.due),
              style:
                  TextStyle(color: isLate(task.due) ? Colors.red : Colors.grey),
            ),
          ),
        ));
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
