import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/utils/utils.dart';

void main() {
  test("Should return just the hour and minutes", () {
    String formattedDate = getDateFormat(DateTime.now());
    var today = DateTime.now();
    expect(formattedDate, DateFormat.Hm().format(today));
  });

  test("Shouldn't return just the hours and minuts", () {
    var date = DateTime.parse("2020-06-13T22:30:00.000Z");
    String formattedDate = getDateFormat(date);
    String year = (DateTime.now().year != date.year) ? ", ${date.year}" : "";
    expect(formattedDate,
        "${DateFormat.MMMMEEEEd().format(date)}$year ${DateFormat.Hm().format(date)}");
  });
}
