import 'package:flutter/material.dart';
import 'package:focus_forge/models/daily_model.dart';
import 'package:focus_forge/models/focus_model.dart';
import 'package:focus_forge/models/profile_model.dart';
import 'package:focus_forge/models/task_model.dart';
import 'package:focus_forge/models/user_model.dart';
import 'package:focus_forge/screens/splash.dart';
import 'package:hive_flutter/hive_flutter.dart';

 Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('settings');// required for splash screen


  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('userBox');

  Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('taskBox');

  Hive.registerAdapter(ProfileModelAdapter());
  await Hive.openBox<ProfileModel>('profileBox');

  Hive.registerAdapter(DailyModelAdapter());
  await Hive.openBox<DailyModel>('dailyBox');

  Hive.registerAdapter(FocusModelAdapter());
  await Hive.openBox<FocusModel>('focusBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
