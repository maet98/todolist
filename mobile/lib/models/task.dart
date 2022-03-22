import 'dart:convert';

import 'package:todo_list/models/enums/status.dart';
import 'package:todo_list/utils/utils.dart';

class Task {
  int id;
  String title;
  DateTime due;
  Status status;

  Task(
      {required this.title,
      required this.due,
      this.status: Status.OPEN,
      this.id: -1});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'] as String,
        due: stringToDateTime(json['due']),
        status: getStatus(json['status']),
        id: json['id'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id.toString(),
        'title': this.title,
        'due': this.due.toIso8601String(),
        'status': statusToString(this.status)
      };

  String toString() {
    return json.encode(this.toJson());
  }
}
