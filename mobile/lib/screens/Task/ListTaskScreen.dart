import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/models/enums/category.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/screens/Task/AddTaskScreen.dart';
import 'package:todo_list/services/Services.dart';
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/widgets/ListTasks.dart';

// ignore: must_be_immutable
class ListTaskScreen extends StatefulWidget {
  static const String routeName = '/tasks';
  Category category;

  ListTaskScreen({Key? key, this.category : Category.ALL}) : super(key: key);

  @override
  _ListTaskScreen createState() => _ListTaskScreen();
}

class _ListTaskScreen extends State<ListTaskScreen> {
  List<Task> _tasks = [];
  Category _category = Category.ALL;
  int _sortByDue = 0;
  int _sortByCategory = 0;
  String _search = "";

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

  Widget getSortIcon(int value) {
    switch(value) {
      case 0:
        return Icon(Icons.minimize);
      case 1:
        return Icon(Icons.arrow_upward);
      default:
        return Icon(Icons.arrow_downward);
    }
  }

  Future<void> _sortByMenu(BuildContext context) async {
    await showDialog(context: context, builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SimpleDialog(
            title: Text("Sort By"), 
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text("Due: "),
                IconButton(icon: getSortIcon(_sortByDue), onPressed: () {
                  setState(() {
                    _sortByDue++;
                    if(_sortByDue == 3) {
                      _sortByDue = 0;
                    }
                  });
                })
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("Status: "),
                IconButton(icon: getSortIcon(_sortByCategory), onPressed: () {
                  setState(() {
                    _sortByCategory++;
                    if(_sortByCategory == 3) {
                      _sortByCategory = 0;
                    }
                  });
                })
              ])
            ],
          );
        });
    });
  }

  List<Task> getFilteredTask() {
    var ans = _tasks.where((element) => 
      element.title.contains(_search)
    ).toList();
    ans.sort((task1, task2) {
      if(_sortByDue == 1) {
        return task1.due.compareTo(task2.due);
      } else if(_sortByDue == 2) {
        return task1.due.compareTo(task2.due);
      }
      return 0;
    });
    ans.sort((task1, task2) {
      if(_sortByCategory == 1) {
        return task1.status.index.compareTo(task2.status.index);
      } else if(_sortByCategory == 2) {
        return task2.status.index.compareTo(task1.status.index);
      }
      return 0;
    });
    return ans;
  }

  void updateTask(BuildContext context, Task task, {direct: false}) async {
    if(direct) {
      Services.of(context)!.taskService.updateTask(task).then((value) {
        getTasks();
      });
    } else {
      var updatedTask =
          await Navigator.pushNamed(context, AddTaskScreen.routeName, arguments: task);
      if (updatedTask != null) {
        var uTask = updatedTask as Task;
        int index = this._tasks.indexWhere((element) => element.id == uTask.id);
        setState(() {
          this._tasks[index] = uTask;
        });
      }

    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        _category = widget.category;
      });
      getTasks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode _node = FocusScope.of(context);
    Size size = MediaQuery.of(context).size;
    return Listener(
      onPointerDown: (_) => !_node.hasPrimaryFocus ? _node.unfocus() : null,
      child: Scaffold(
        backgroundColor: categoriesColors[_category],
        appBar: AppBar(
          backgroundColor: categoriesColors[_category],
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                _sortByMenu(context);
              }
            )
          ],
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
                            fontSize: 24)),
                    TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white60),
                            onChanged: (value) =>
                                setState(() => this._search = value),
                            validator: (value) {
                              if (value != null && value.length == 0) {
                                return "Must have a title!!";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                labelStyle: TextStyle(
                                  color: Colors.grey
                                ),
                                contentPadding: EdgeInsets.zero,
                                labelText: "Search"),
                          ),
                  ],
                ),
              ),
              Expanded(
                  child: ListTasks(
                tasks: getFilteredTask(),
                refresh: getTasks,
                updateTask: updateTask,
              ))
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var newTask = await Navigator.pushNamed(context, AddTaskScreen.routeName);
            if (newTask != null) {
              setState(() {
                _tasks.add(newTask as Task);
              });
            }
          },
          tooltip: 'Add Task',
          child: Icon(Icons.add),
        ),
      )
    );
  }
}
