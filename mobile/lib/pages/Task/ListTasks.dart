import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/services/TaskService.dart';

class ListTasks extends StatefulWidget {
  const ListTasks({
    Key? key,
  }) : super(key: key);

  @override
  _ListTasks createState() => _ListTasks();
}

class _ListTasks extends State<ListTasks> {
  List<Task> _tasks = [];

  @override
  void initState() {
    TaskService taskService = new HttpTaskService();
    taskService.getTasks().then((value) => {
      setState((){
        this._tasks = value;
      })
    });
    super.initState();
  }

  String getDateFormat(DateTime date) {
    var today = DateTime.now();
    if(date.day == today.day && date.month == today.month && date.year == today.year) {
      return DateFormat.Hm().format(date);
    } else {
      return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
    }
  }

  bool isLate(DateTime date) {
    return DateTime.now().compareTo(date) > 0;
  }

  List<Widget> getTasks() {
    List<Widget>ans = [];
    if(_tasks.length == 0) {
      ans.add(Container(
        child: Text("There aren't any task yet.")
      ));
    } else {
      for(var task in _tasks) {
        ans.add(
          Card(
            child: ListTile(
            leading: Icon(Icons.offline_bolt),  
            title: Text(task.title),
            subtitle: Text(getDateFormat(task.due),
             style: TextStyle(color: isLate(task.due) ?  Colors.red : Colors.grey),),
            ),
            elevation: 0,
          )
          
        );
      }
    }

    return ans;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
      return Scaffold(
        backgroundColor: Color.fromRGBO(88,134,254,1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(88,134,254,1),
          elevation: 0,
        ),
        body: Column(
          children: [
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
                    color: Colors.white
                    ),
                  child: Icon(Icons.toc_outlined, color: Color.fromRGBO(88,134,254,1)),
                ),
                Text("All",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 36)
                ),
                Text("${this._tasks.length} Tasks",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 24)
                )
              ],),
            ),
            Expanded(
              child: Container(
                width: size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 25.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                  color: Colors.white,
                ),
                child:  ListView(children: getTasks()),
              )
            )
          ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
          tooltip: 'Add Task',
          child: Icon(Icons.add),
        ), 
      );
  }
}