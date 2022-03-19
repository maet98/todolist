import 'package:flutter/widgets.dart';
import 'package:todo_list/services/TaskService.dart';

class Services extends InheritedWidget {
  final TaskService taskService;

  const Services({
    Key? key, 
    required this.taskService,
    required Widget child
  }) : super(key: key, child: child);

  static Services? of(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<Services>();

  @override
  bool updateShouldNotify(_) {
    return false;
  }
}