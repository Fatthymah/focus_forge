import 'package:flutter/material.dart';
import 'package:focus_forge/models/daily_model.dart';
import 'package:focus_forge/screens/task_screen.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedEnergy = -1; // 0 = low, 1 = medium ,2 = high
  void selectEnergy(int level) {
    setState(() {
      selectedEnergy = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff5e0),
      body:SafeArea(
        child: Padding(
          padding:const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              const Text(
                "How is your energy today?",
                style:TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color:Color(0xff2c235c),
                ),
              ),

              const SizedBox(height:35),

              _energyCard(
                index:0,
                title:"Low Energy",
                subtitle:"Feeling tired or slow",
                color:const Color(0xfff4c6c6),
              ),
              const SizedBox(height: 20),

              _energyCard(
                index:1,
                title:"Medium Energy",
                subtitle:"Balanced and steady",
                color:const Color(0xfff3e3b5),
              ),
              const SizedBox(height: 20),

              _energyCard(
                index:2,
                title:"High Energy",
                subtitle:"Focused and motivated",
                color:const Color(0xffcde8d5),
              ),
              const Spacer(),

              SizedBox(
                width:double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff272340),
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  onPressed:() async{
                    if (selectedEnergy == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select an energy level")),
                      );
                      return;
                    }

                    final prefs = await SharedPreferences.getInstance();
                    final userKey = prefs.getInt("currentUserKey") ?? -1;
                    if(userKey == -1) return;

                    final dailyBox = Hive.box<DailyModel>('dailyBox');
                    final today = DateTime.now().toIso8601String().split("T")[0];

                    final index = dailyBox.values.toList().indexWhere (
                        (d) => d.date == today && d.userKey == userKey,
                    );

                    if(index == -1) {
                      dailyBox.add(
                        DailyModel(
                          date:today,
                          energyLevel: selectedEnergy,
                          userKey: userKey,
                          totalTasks: 0,
                          completedTasks: 0,
                        ),
                      );
                    }else {
                      final old = dailyBox.getAt(index)!;
                      old.energyLevel = selectedEnergy;
                      old.save();
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskScreen(
                          energyLevel: selectedEnergy,
                        ),
                      ),
                    );
                  },


                  child: const Text(
                    "Start Day",
                    style:TextStyle(
                      color:Color(0xffdcbc85),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _energyCard({
    required int index,
    required String title,
    required String subtitle,
    required Color color,
}) {
    final bool isSelected = selectedEnergy == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEnergy = index;
        });
      },
      child: Container(
        padding:const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color:const Color(0xff1e193a),width:2) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:Color(0xff312c51),
                    ),
                  ),

                  const SizedBox(height:6),
                  Text(
                    subtitle,
                    style:const TextStyle(
                      fontSize: 14,
                      color:Color(0xff48426d),
                    ),
                  ),
                ],
              ),
            ),
            if(isSelected)
              const Icon(
                Icons.check_circle,
                color:Color(0xff312c51),
              ),
          ],
        ),
      ),
    );
  }
}