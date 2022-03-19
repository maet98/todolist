import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/services/TaskService.dart';

class AddTask extends StatefulWidget {
  const AddTask({
    Key? key,
  }) : super(key: key);

  @override
  _AddTask createState() => _AddTask();
}

class _AddTask extends State<AddTask> {
  Task _task = new Task('', DateTime.now());
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _callDatePicker() async {
    DateTime? date = await showDatePicker(
     context: context,
     initialDate: _task.due,
     firstDate: DateTime.now(),
     lastDate: DateTime(2400),
    );
    if(date != null) {
      setState(() {
        this._task.due = date;
      });
    }
  }

  String getDateFormat(DateTime date) {
    var today = DateTime.now();
    if(date.day == today.day && date.month == today.month && date.year == today.year) {
      return DateFormat.Hm().format(date);
    } else {
      return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
    }
  }

  bool isLate(DateTime date) {
    return DateTime.now().compareTo(date) > 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("New task", 
          style: TextStyle(color: Colors.black)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 4),
        child: Form(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(4.0),
                width: size.width,
                child: TextFormField(
                  controller: _titleController,
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),
                  onChanged: (value) => setState(() => this._task.title = value),
                  validator: (value) {
                    if(value != null && value.length == 0) {
                      return "Must have a title!!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: "What are you planning?"
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _callDatePicker,
                icon: Icon(Icons.alarm),
                label: Text(getDateFormat(this._task.due),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                )
              )
            ],
          ),
        )
      )
    );
  }
}