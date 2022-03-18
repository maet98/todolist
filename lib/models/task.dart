import 'package:json_annotation/json_annotation.dart';

enum Status {
  open,
  in_progress,
  completed
}

@JsonSerializable()
class Task {
  String title;
  DateTime due;
  Status status;


  Task(this.title, this.due, {this.status : Status.open});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}