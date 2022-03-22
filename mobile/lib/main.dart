import 'package:flutter/material.dart';
import 'package:todo_list/screens/HomeScreen.dart';
import 'package:todo_list/screens/Task/ListTaskScreen.dart';
import 'package:todo_list/screens/Task/AddTaskScreen.dart';
import 'package:todo_list/services/Services.dart';
import 'package:todo_list/services/TaskService.dart';

void main() {
  runApp(Services(taskService: HttpTaskService(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomeScreen.routeName,
      routes: {
        AddTaskScreen.routeName: (_) => AddTaskScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        ListTaskScreen.routeName: (_) => ListTaskScreen(),
      },
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
