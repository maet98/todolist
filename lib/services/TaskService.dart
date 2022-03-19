import 'dart:convert';

import 'package:todo_list/models/task.dart';
import 'package:http/http.dart' as http;

abstract class TaskService {
  Future<List<Task>> getTasks();
  Future<Task> getTaskById(int id);
  Future<Task> createTask(Task task);
  Future updateTask(int id, Task task);
  Future deleteTask();
}

class HttpTaskService implements TaskService {
  String _baseUrl = "http://10.0.0.6:3000/task";

  @override
  Future<Task> createTask(Task task) async {
    var url = Uri.parse(_baseUrl);
    var response = await http.post(url, body: task.toJson());
    print(response.body);
    var savedTask = Task.fromJson(jsonDecode(response.body));
    return savedTask;
  }
  
  @override
  Future deleteTask() {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }
  
  @override
  Future<Task> getTaskById(int id) async {
    var url = Uri.parse('$_baseUrl/$id');
    var response = await http.get(url);
    var task = Task.fromJson(jsonDecode(response.body));
    return task;
  }

  @override
  Future<List<Task>> getTasks() async {
    var url = Uri.parse(_baseUrl);
    var response = await http.get(url);
    Iterable taskList = json.decode(response.body);
    List<Task> tasks = List<Task>.from(taskList.map((model) => Task.fromJson(model)));
    return tasks;
  }

  @override
  Future updateTask(int id, Task task) async {
    var url = Uri.parse('$_baseUrl/$id');
    var response = await http.post(url, body: task.toJson());
    print(response.body);
    var savedTask = Task.fromJson(jsonDecode(response.body));

  }

}