import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/models/enums/category.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/pages/Task/addTask.dart';
import 'package:todo_list/services/Services.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/widgets/ListTasks.dart';

// ignore: must_be_immutable
class ListTaskScreen extends StatefulWidget {
  static const String routeName = '/tasks';

  const ListTaskScreen({Key? key}) : super(key: key);

  @override
  _ListTaskScreen createState() => _ListTaskScreen();
}

class _ListTaskScreen extends State<ListTaskScreen> {
  List<Task> _tasks = [];
  Category _category = Category.ALL;

  void getTasks() {
    if (_category == Category.ALL) {
      Services.of(context)!.taskService.getTasks().then((value) {
        print(value);
        setState(() {
          _tasks = value;
        });
      });
    } else {
      Services.of(context)!
          .taskService
          .getTasksByStatus(_category)
          .then((value) {
        print(value);
        setState(() {
          _tasks = value;
        });
      });
    }
  }

  void updateTask(BuildContext context, Task task) async {
    var updatedTask =
        await Navigator.pushNamed(context, AddTask.routeName, arguments: task);
    if (updatedTask != null) {
      var uTask = updatedTask as Task;
      int index = this._tasks.indexWhere((element) => element.id == uTask.id);
      setState(() {
        this._tasks[index] = uTask;
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        var category = ModalRoute.of(context)!.settings.arguments as Category;
        setState(() {
          _category = category;
        });
        getTasks();
      }
    });
    super.initState();
  }

  String getDateFormat(DateTime date) {
    var today = DateTime.now();
    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return DateFormat.Hm().format(date);
    } else {
      return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
    }
  }

  bool isLate(DateTime date) {
    return DateTime.now().compareTo(date) > 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: categoriesColors[_category],
      appBar: AppBar(
        backgroundColor: categoriesColors[_category],
        elevation: 0,
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            getTasks();
          },
          child: ListView(children: [
            Container(
              height: 220,
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white),
                    child: Icon(categoriesIcons[_category],
                        color: categoriesColors[_category]),
                  ),
                  Text(enumToString(_category),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 36)),
                  Text("${this._tasks.length} Tasks",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 24))
                ],
              ),
            ),
            Expanded(
                child: ListTasks(
              tasks: this._tasks,
              refresh: getTasks,
              updateTask: updateTask,
            ))
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var newTask = await Navigator.pushNamed(context, AddTask.routeName);
          if (newTask != null) {
            setState(() {
              _tasks.add(newTask as Task);
            });
          }
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
