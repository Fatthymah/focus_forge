import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId:0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  int energyLevel;   // 0 = low, 1 = medium , 2 = high

  @HiveField(3)
  int userKey;

  @HiveField(4)
  String date; // yyyy-mm-dd

  TaskModel({
    required this.title,
    this.isDone = false,
    this.energyLevel = 0,
    this.userKey = -1,
    required this.date,
});
}