import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 1)
class ProfileModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String bio;

  @HiveField(3)
  String? imagePath;


  ProfileModel({
    required this.name,
    required this.email,
    required this.bio,
    this.imagePath,
});

}