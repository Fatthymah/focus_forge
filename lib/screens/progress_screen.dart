import 'package:flutter/material.dart';
import 'package:focus_forge/models/daily_model.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'overview_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int daysInMonth(DateTime date) {
    final firstDayNextMonth = DateTime(date.year, date.month + 1, 1);
    return firstDayNextMonth.subtract(const Duration(days: 1)).day;
  }

  int firstWeekdayOfMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    return firstDay.weekday; // 1 = Monday ... 7 = Sunday
  }

  int userKey = -1;
  late Box<DailyModel> dailyBox;

  @override
  void initState() {
    super.initState();
    dailyBox = Hive.box<DailyModel>('dailyBox');
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    userKey = prefs.getInt("currentUserKey") ?? -1;
    setState(() {});
  }

  List<DailyModel> get userDays =>
      dailyBox.values.where((d) => d.userKey == userKey).toList();

  Color energyColor(int e) {
    if(e == 0) return const Color(0xfff4c6c6);
    if(e == 1) return const Color(0xfff2e3b5);
    return const Color(0xffcde8d5);
  }

  String currentMonth() {
    final now = DateTime.now();
    return "${_monthName(now.month)} ${now.year}";
  }

  String _monthName(int m) {
    const months = [
      "January","February","March","April","May","June",
      "July","August","September","October","November","December",
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff5e0),
      appBar: AppBar(
        title:const Text(
            "Your Progress",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff312c51),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: userKey == -1
        ? const Center(child:CircularProgressIndicator())
        :userDays.isEmpty ? const Center(
        child:Text(
          "No Progress yet.\nStart your first day!",
          textAlign: TextAlign.center,
          style:TextStyle(
            fontSize: 18,
            color:Color(0xff312c51),
          ),
        ),
      )
          :Column(
        children: [
          const SizedBox(height:16),

          Text(
            currentMonth(),
            style:const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color:Color(0xff2c235c),
            ),
          ),

          const SizedBox(height:12),
          _legend(),
          const SizedBox(height:12),

          Expanded(
            child: GridView.builder(
              padding:const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: userDays.length,
              itemBuilder: (context, index) {
                final day = userDays[index];

                print("Date: ${day.date}, Energy: ${day.energyLevel}");

                final total = day.totalTasks ?? 0;
                final completed = day.completedTasks ?? 0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OverviewScreen(
                          date: day.date,
                          energy: day.energyLevel,
                          total: total,
                          completed: completed,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: energyColor(day.energyLevel),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        day.date.split("-")[2],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff312c51),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend() {
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const[
          _LegendItem(color:Color(0xfff4c6c6),text:"Low"),
          _LegendItem(color:Color(0xfff3e3b5),text:"Medium"),
          _LegendItem(color:Color(0xffcde8d5),text:"High"),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color,required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color:color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width:6),
        Text(
          text,style:const TextStyle(
          color:Color(0xff312c51),
          fontWeight: FontWeight.w500,
        ),
        ),
      ],
    );
  }
}
