import 'package:hive/hive.dart';

part 'daily_model.g.dart';

@HiveType(typeId:3)
class DailyModel extends HiveObject {
  @HiveField(0)
  String date;  // yyyy-mm-dd

  @HiveField(1)
  int energyLevel;  // 0,1,2

  @HiveField(2)
  int userKey;

  @HiveField(3)
  int completedTasks;

  @HiveField(4)
  int totalTasks;

  DailyModel({
    required this.date,
    required this.energyLevel,
    required this.userKey,
    required this.completedTasks,
    required this.totalTasks,
});
}