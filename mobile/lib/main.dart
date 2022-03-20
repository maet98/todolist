import 'package:flutter/material.dart';
import 'package:todo_list/pages/HomeScreen.dart';
import 'package:todo_list/pages/Task/ListTaskScreen.dart';
import 'package:todo_list/pages/Task/addTask.dart';
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
        AddTask.routeName: (_) => AddTask(),
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
