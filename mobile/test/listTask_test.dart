import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/models/enums/status.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/widgets/ListTasks.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    var tasks = [
      Task(title: "test 1", due: DateTime.now()),
      Task(title: "test 2", due: DateTime(DateTime.now().year + 3)),
      Task(title: "test 3", due: DateTime(DateTime.now().year + 2)),
      Task(title: "test 4", due: DateTime(DateTime.now().year + 4)),
    ];
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ListTasks(
      tasks: tasks,
      refresh: () => "hola",
      updateTask: () => "hola",
    ))));

    var tasksWidget = find.byType(ListTile);
    // Verify that all tasks widget where created
    expect(tasksWidget, findsWidgets);
    var i = 0;
    tasksWidget.allCandidates.forEach((element) {
      if (element.widget.runtimeType == ListTile) {
        ListTile widget = element.widget as ListTile;
        expect(widget.title.runtimeType, InkWell);
        var title = ((widget.title as InkWell).child as Text).data;
        expect(title, tasks[i].title);
        var subtitle = (widget.subtitle as Text).data;
        // expect(subtitle, tasks[i].due);
        var leading = widget.leading;
        if (tasks[i].status == Status.DONE) {
          expect(leading.runtimeType, Icon);
        } else {
          expect(leading.runtimeType, Checkbox);
        }
        i++;
      }
    });
  });
}
