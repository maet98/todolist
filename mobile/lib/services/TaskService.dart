import 'dart:convert';

import 'package:todo_list/models/enums/category.dart';
import 'package:todo_list/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list/utils/utils.dart';
import 'package:todo_list/utils/constant.dart' as Constants;

abstract class TaskService {
  Future<List<Task>> getTasks();
  Future<List<Task>> getTasksByStatus(Category status);
  Future<List<Task>> getLastTasks();
  Future<Task> getTaskById(int id);
  Future<Task> createTask(Task task);
  Future updateTask(Task task);
  Future deleteTask();
}

class HttpTaskService implements TaskService {
  String _baseUrl = "${Constants.uriApi}/task";

  @override
  Future<Task> createTask(Task task) async {
    var url = Uri.parse(_baseUrl);
    var body = task.toJson();
    body.remove("id");
    var response = await http.post(url, body: body);
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
  Future<List<Task>> getTasksByStatus(Category category) async {
    String status = category.toString().split(".")[1].toUpperCase();
    var url = Uri.parse('$_baseUrl/status/$status');
    var response = await http.get(url);
    Iterable taskList = json.decode(response.body);
    List<Task> tasks =
        List<Task>.from(taskList.map((model) => Task.fromJson(model)));
    return tasks;
  }

  @override
  Future<Task> getTaskById(int id) async {
    var url = Uri.parse('$_baseUrl/$id');
    var response = await http.get(url);
    var task = Task.fromJson(jsonDecode(response.body));
    return task;
  }

  @override
  Future<List<Task>> getLastTasks() async {
    var url = Uri.parse(_baseUrl + "/last");
    var response = await http.get(url);
    Iterable taskList = json.decode(response.body);
    List<Task> tasks =
        List<Task>.from(taskList.map((model) => Task.fromJson(model)));
    return tasks;
  }

  @override
  Future<List<Task>> getTasks() async {
    var url = Uri.parse(_baseUrl);
    var response = await http.get(url);
    Iterable taskList = json.decode(response.body);
    List<Task> tasks =
        List<Task>.from(taskList.map((model) => Task.fromJson(model)));
    return tasks;
  }

  @override
  Future updateTask(Task task) async {
    print(task);
    var url = Uri.parse('$_baseUrl/${task.id}');
    var response = await http.put(url, body: task.toJson());
    if (response.statusCode == 200) {
      var savedTask = Task.fromJson(jsonDecode(response.body));
    } else {
      var body = json.decode(response.body);
      throw new Exception(body["message"]);
    }
  }
}
