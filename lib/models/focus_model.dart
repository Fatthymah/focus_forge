import 'package:hive/hive.dart';

part 'focus_model.g.dart';

@HiveType(typeId:4)
class FocusModel extends HiveObject {
  @HiveField(0)
  String date; // yyyy - mm - dd

  @HiveField(1)
  int seconds;  // total focus seconds

   @HiveField(2)
  int userKey;

   FocusModel({
     required this.date,
     required this.seconds,
     required this.userKey,
});
}