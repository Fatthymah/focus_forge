import 'dart:async';
import 'package:flutter/material.dart';
import 'package:focus_forge/models/focus_model.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  Timer? timer;
  int seconds = 0;
  bool isRunning = false;
  int userKey = -1;
  late Box<FocusModel> focusBox;

  @override
  void initState() {
    super.initState();
    focusBox = Hive.box<FocusModel>('focusBox');
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    userKey = prefs.getInt("currentUserKey") ?? -1;
    setState(() {});
  }

  void startTimer() {
    if (isRunning) return;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        seconds++;
      });
    });
    setState(() => isRunning = true);
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void endTimer() {
    timer?.cancel();
    saveFocus();
    setState(() {
      seconds = 0;
      isRunning = false;
    });
  }

  void saveFocus() {
    if (userKey == -1 || seconds == 0) return;
    final today = DateTime.now().toIso8601String().split('T')[0];

    final existing = focusBox.values.where(
          (f) => f.date == today && f.userKey == userKey,
    );

    if (existing.isNotEmpty) {
      final model = existing.first;
      model.seconds += seconds;
      model.save();
    } else {
      focusBox.add(
        FocusModel(date: today, seconds: seconds, userKey: userKey),
      );
    }
  }

  String formatTime(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff5e0),
      appBar: AppBar(
        title: const Text(
            "Focus Timer",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,),
        ),
        backgroundColor: const Color(0xff312c51),
        foregroundColor: const Color(0xfffff5e0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatTime(seconds),
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Color(0xff312c51),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: startTimer,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent),
                  child: const Text("Start"),
                ),
                ElevatedButton(
                  onPressed: pauseTimer,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent),
                  child: const Text("Pause"),
                ),
                ElevatedButton(
                  onPressed: endTimer,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  child: const Text("End"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

