import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:json_annotation/json_annotation.dart';
part 'task.g.dart';

enum Status {
  OPEN,
  IN_PROGRESS,
  COMPLETED
}

@JsonSerializable()
class Task {
  int id;
  String title;
  DateTime due;
  Status status;


  Task(this.title, this.due, {this.status : Status.OPEN, this.id : -1});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  String toString() {
    return json.encode(this.toJson());
  }
}