import 'package:flutter/material.dart';
import 'package:todo_list/models/enums/category.dart';

String enumToString(value) =>
    value.toString().split(".")[1].replaceAll("_", " ");

String statusToString(value) => value.toString().split(".")[1];

stringToDateTime(value) =>
    (value == null) ? DateTime.now() : DateTime.parse(value as String);

Map<Category, IconData> categoriesIcons = {
  Category.ALL: Icons.assignment_sharp,
  Category.OPEN: Icons.assignment_turned_in_outlined,
  Category.IN_PROGRESS: Icons.flag,
  Category.COMPLETED: Icons.check,
};

Map<Category, Color> categoriesColors = {
  Category.ALL: Color.fromRGBO(88, 134, 254, 1),
  Category.OPEN: Colors.indigo,
  Category.IN_PROGRESS: Colors.orange,
  Category.COMPLETED: Colors.green
};
