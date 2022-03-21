import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/models/enums/category.dart';
import 'package:todo_list/models/enums/status.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/screens/Task/AddTaskScreen.dart';
import 'package:todo_list/services/Services.dart';
import 'package:todo_list/services/TaskService.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/widgets/CategoryBox.dart';
import 'package:todo_list/widgets/CategoryIcon.dart';
import 'package:todo_list/widgets/ListTasks.dart';
import 'package:transition/transition.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<Task> lastThree = [];
  Map<Status, int> mapTask = {
    Status.OPEN: 0,
    Status.IN_PROGRESS: 0,
    Status.COMPLETED: 0,
  };
  int total = 0;

  void getLastThree(BuildContext context) {
    Services.of(context)!.taskService.getLastTasks().then((value) {
      setState(() {
        lastThree = value;
      });
    });
  }

  void getMapOfCounts(BuildContext context) {
    Services.of(context)!.taskService.getTasks().then((value) {
      setState(() {
        total = value.length;
        mapTask = {
          Status.OPEN: 0,
          Status.IN_PROGRESS: 0,
          Status.COMPLETED: 0,
        };
        for (var task in value) {
          mapTask.update(task.status, (value) => value + 1);
        }
      });
    });
  }

  void updateTask(BuildContext context, Task task, {direct : false}) async {
    if(direct) {
      Services.of(context)!.taskService.updateTask(task).then((value) {
        getLastThree(context);
        getMapOfCounts(context);
      });
    } else {
      var updatedTask =
          await Navigator.pushNamed(context, AddTaskScreen.routeName, arguments: task);
      if (updatedTask != null) {
        var uTask = updatedTask as Task;
        int index =
            this.lastThree.indexWhere((element) => element.id == uTask.id);
        setState(() {
          this.lastThree[index] = uTask;
        });
      }
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getLastThree(context);
      getMapOfCounts(context);
    });
  }

  List<Widget> getCategoryBoxes() {
    List<Widget> ans = [];
    for (var category in Category.values) {
      ans.add(CategoryBox(
          name: enumToString(category).toLowerCase(),
          type: category,
          total: category == Category.ALL
              ? total
              : mapTask[Status.values[category.index]]!,
          icon: CategoryIcon(
              color: categoriesColors[category]!,
              icon: categoriesIcons[category]!)));
    }
    return ans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.grey),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getLastThree(context);
          getMapOfCounts(context);
        },
        child: ListView(children: [
        Container(
            height: 200,
            child: GridView.count(
                padding: const EdgeInsets.all(8),
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.3,
                crossAxisCount: 2,
                children: getCategoryBoxes())),
        Expanded(
            child: ListTasks(
                tasks: this.lastThree,
                refresh: getLastThree,
                updateTask: updateTask))
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context, Transition(transitionEffect: TransitionEffect.SCALE,child: AddTaskScreen()));
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
