import 'dart:convert';

import 'package:mobile/models/task.dart';
import 'package:http/http.dart' as http;

abstract class TaskService {
  Future<List<Task>> getTasks();
  Future<Task> getTaskById(int id);
  Future<Task> createTask(Task task);
  Future updateTask();
  Future deleteTask();
}

class HttpTaskService implements TaskService {
  String _baseUrl = "http://localhost:3000/task";

  @override
  Future<Task> createTask(Task task) async {
    var url = Uri.parse(_baseUrl);
    var response = await http.post(url, body: task.toJson());
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
    // TODO: implement getTasks
    throw UnimplementedError();
  }

  @override
  Future updateTask() {
    // TODO: implement updateTask
    throw UnimplementedError();
  }

}