import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/enums/category.dart';

String enumToString(value) =>
    value.toString().split(".")[1].replaceAll("_", " ");

String statusToString(value) => value.toString().split(".")[1];

DateTime stringToDateTime(String value) {
  return DateTime.parse(value);
}

Map<Category, IconData> categoriesIcons = {
  Category.ALL: Icons.assignment_sharp,
  Category.OPEN: Icons.assignment_turned_in_outlined,
  Category.IN_PROGRESS: Icons.flag,
  Category.DONE: Icons.check,
};

Map<Category, Color> categoriesColors = {
  Category.ALL: Color.fromRGBO(88, 134, 254, 1),
  Category.OPEN: Colors.indigo,
  Category.IN_PROGRESS: Colors.orange,
  Category.DONE: Colors.green
};

String getDateFormat(DateTime date) {
  var today = DateTime.now();
  if (date.day == today.day &&
      date.month == today.month &&
      date.year == today.year) {
    return DateFormat.Hm().format(date);
  } else {
    String year = (today.year != date.year) ? ", ${date.year}" : "";
    return "${DateFormat.MMMMEEEEd().format(date)}$year ${DateFormat.Hm().format(date)}";
  }
}

bool isLate(DateTime date) {
  return DateTime.now().compareTo(date) > 0;
}
