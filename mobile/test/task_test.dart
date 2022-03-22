import 'package:test/test.dart';
import 'package:todo_list/models/task.dart';

void main() {
  test("Should return a Task", () {
    var json = {
      "id": 1,
      "title": "test",
      "status": "DONE",
      "due": "2020-06-13T22:30:00.000Z"
    };
    var resultTask = Task.fromJson(json);
    expect(resultTask.runtimeType, Task);
    expect(resultTask.id, json["id"]);
    expect(resultTask.title, json["title"]);
  });

  test("Shouldn't return a Task because doesn't have due date", () {
    var json = {"id": 1, "title": "test", "status": "DON"};
    try {
      Task.fromJson(json);
    } catch (e) {
      expect(e.toString(), "type 'Null' is not a subtype of type 'String'");
    }
  });
}
