import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/models/enums/status.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/services/Services.dart';

class AddTaskScreen extends StatefulWidget {
  static const String routeName = '/addTask';
  const AddTaskScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AddTaskScreen createState() => _AddTaskScreen();
}

class _AddTaskScreen extends State<AddTaskScreen> {
  Task _task = new Task(title: '', due: DateTime.now());
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        var args = ModalRoute.of(context)!.settings.arguments as Task;
        print(args);
        setState(() {
          _task = args;
        });
        _titleController.text = _task.title;
      }
    });
    super.initState();
  }

  Future<void> _callDatePicker() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: _task.due,
      firstDate: DateTime.now(),
      lastDate: DateTime(2400),
    );
    var time = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(this._task.due));
    if (date != null && time != null) {
      setState(() {
        this._task.due = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  String getDateFormat(DateTime date) {
    var today = DateTime.now();
    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return DateFormat.Hm().format(date);
    } else {
      return "${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    }
  }

  bool isLate(DateTime date) {
    return DateTime.now().compareTo(date) > 0;
  }

  @override
  Widget build(BuildContext context) {
    final FocusScopeNode _node = FocusScope.of(context);
    Size size = MediaQuery.of(context).size;
    return Listener(
        onPointerDown: (_) => !_node.hasPrimaryFocus ? _node.unfocus() : null,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                  (this._task.id > 0)
                      ? "Update Task ${this._task.id}"
                      : "New task",
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
            body: Container(
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(4.0),
                        width: size.width,
                        height: 120,
                        child: TextFormField(
                          controller: _titleController,
                          autofocus: true,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                          onChanged: (value) =>
                              setState(() => this._task.title = value),
                          validator: (value) {
                            if (value != null && value.length == 0) {
                              return "Must have a title!!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              labelText: "What are you planning?"),
                        ),
                      ),
                      TextButton.icon(
                          onPressed: _callDatePicker,
                          icon: Icon(Icons.alarm),
                          label: Text(
                            getDateFormat(this._task.due),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          )),
                      (this._task.id > 0)
                          ? InputDecorator(
                              decoration: InputDecoration(labelText: "Status:"),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<Status>(
                                value: this._task.status,
                                isExpanded: false,
                                isDense: true,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (Status? newValue) {
                                  setState(() {
                                    this._task.status = newValue!;
                                  });
                                },
                                items: Status.values
                                    .map<DropdownMenuItem<Status>>(
                                        (Status value) {
                                  var text = value
                                      .toString()
                                      .split(".")[1]
                                      .toLowerCase()
                                      .replaceAll("_", " ");
                                  return DropdownMenuItem<Status>(
                                    value: value,
                                    child: Text(text),
                                  );
                                }).toList(),
                              )))
                          : Container()
                    ],
                  ),
                )),
            bottomNavigationBar: Container(
              width: size.width,
              color: Colors.lightBlue,
              child: TextButton(
                  onPressed: () {
                    if (this._task.id > 0) {
                      Services.of(context)!
                          .taskService
                          .updateTask(this._task)
                          .then((value) {
                        Navigator.pop(context, this._task);
                      });
                    } else {
                      Services.of(context)!
                          .taskService
                          .createTask(this._task)
                          .then((value) {
                        print(value);
                        Navigator.pop(context, value);
                      });
                    }
                  },
                  child: Text(
                    (this._task.id == -1) ? "Create task" : "Update Task",
                    style: TextStyle(color: Colors.white),
                  )),
            )));
  }
}
