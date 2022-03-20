import 'package:todo_list/utils/utils.dart';

enum Status { OPEN, IN_PROGRESS, COMPLETED }

getStatus(String status) {
  Status ans = Status.values.firstWhere(
    (e) => statusToString(e) == status,
    orElse: () => Status.OPEN,
  );
  return ans;
}
