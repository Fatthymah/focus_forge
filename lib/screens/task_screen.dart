import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_model.dart';
import '../models/task_model.dart';

class TaskScreen extends StatefulWidget {
  final int energyLevel;

  const TaskScreen({super.key, required this.energyLevel});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController taskController = TextEditingController();

  int currentUserKey = -1;

  late Box<DailyModel> dailyBox;
  late Box<TaskModel> taskBox;

  @override
  void initState() {
    super.initState();
    taskBox = Hive.box<TaskModel>('taskBox');
    dailyBox = Hive.box<DailyModel>('dailyBox');

    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserKey = prefs.getInt("currentUserKey") ?? -1;
    setState(() {});
  }

  Color get bgColor {
    switch (widget.energyLevel) {
      case 0:
        return const Color(0xfff4c6c6); // low energy
      case 1:
        return const Color(0xfff3e3b5); // medium energy
      case 2:
        return const Color(0xffcde8d5); // high energy
      default:
        return const Color(0xfffff5e0);
    }
  }

  String get energyTitle {
    return ["Low Energy", "Medium Energy", "High Energy"][widget.energyLevel];
  }

  void addTask() {
    if (taskController.text.trim().isEmpty || currentUserKey == -1) return;

    final today = getTodayString();

    taskBox.add(TaskModel(
      title: taskController.text.trim(),
      energyLevel: widget.energyLevel,
      isDone: false,
      userKey: currentUserKey,
      date: today,
    ));

    updateTodaySummary();

    taskController.clear();
    setState(() {});
  }

  void toggleTask(TaskModel task) {
    task.isDone = !task.isDone;
    task.save();
    updateTodaySummary();
    setState(() {});
  }

  void updateTask(TaskModel task, String newTitle) {
    task.title = newTitle;
    task.save();
    updateTodaySummary();
    setState(() {});
  }

  void deleteTask(TaskModel task) {
    task.delete();
    updateTodaySummary();
    setState(() {});
  }

  String getTodayString() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  void updateTodaySummary() {
    final today = getTodayString();

    // get today's tasks for this user
    final tasks = taskBox.values
        .where((t) => t.userKey == currentUserKey && t.date == today)
        .toList();

    final total = tasks.length;
    final completed = tasks.where((t) => t.isDone).length;

    // find existing DailyModel or create new
    var day = dailyBox.values.firstWhere(
          (d) => d.userKey == currentUserKey && d.date == today,
      orElse: () {
        final newDay = DailyModel(
          date: today,
          energyLevel: widget.energyLevel,
          userKey: currentUserKey,
          completedTasks: 0,
          totalTasks: 0,
        );
        dailyBox.add(newDay);
        return newDay;
      },
    );

    day.totalTasks = total;
    day.completedTasks = completed;
    day.save();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserKey == -1) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xff312c51),
        title: Text(
          "$energyTitle Day",
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Energy bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                energyTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff312c51),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Task input
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                hintText: "Add a task",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: addTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff312c51),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Save Task",
                  style: TextStyle(
                      color: Colors.white, fontSize: 16, letterSpacing: 1),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Task list (reactive)
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: taskBox.listenable(),
                builder: (context, Box<TaskModel> box, _) {
                  final tasks = box.values
                      .where((task) =>
                  task.energyLevel == widget.energyLevel &&
                      task.userKey == currentUserKey)
                      .toList();

                  if (tasks.isEmpty) {
                    return const Center(child: Text("No tasks yet!"));
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                task.isDone
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color:
                                task.isDone ? Colors.green : Colors.grey,
                              ),
                              onPressed: () => toggleTask(task),
                            ),
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueGrey),
                              onPressed: () => _showEditDialog(task),
                            ),
                            IconButton(
                              icon:
                              const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteTask(task),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(TaskModel task) {
    final controller = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(
          controller: controller,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              updateTask(task, controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
