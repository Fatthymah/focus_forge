import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  final String date;
  final int energy;
  final int total;
  final int completed;

  const OverviewScreen({
    super.key,
    required this.date,
    required this.energy,
    required this.total,
    required this.completed,
});

  int get pending => total - completed;
  double get percent => total == 0? 0 : completed/total;

  String progressMessage(double Percent) {
    if(percent == 0) return "Let's start small🪄";
    if(percent < 1) return "You're halfway there!🎊";
    return "Amazing! You did it🎉";
  }


  Color energyColor() {
    if (energy == 0) return const Color(0xfff4c6c6);
    if (energy == 1) return const Color(0xfff3e3b5);
    return const Color(0xffcde8d5);
  }


  @override
  Widget build(BuildContext context) {
    final message = progressMessage(percent);

    return Scaffold(
      backgroundColor: const Color(0xfffff5e0),
      appBar:AppBar(
        title:const Text("Today's Overview"),
        backgroundColor: const Color(0xff312c51),
        foregroundColor: Colors.white,
      ),
      body:Padding(
        padding:const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(date,style:const TextStyle(fontSize: 18)),

            const SizedBox(height:16),

            Container(
              height: 100,
              decoration: BoxDecoration(
                color:energyColor(),
                borderRadius:BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text("Energy of the Day",
                    style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _card("Total",total),
                _card("Done",completed),
                _card("Pending",pending),
              ],
            ),

            const SizedBox(height:20),

            LinearProgressIndicator(value:percent,color:const Color(0xff312c51),backgroundColor: Colors.grey[300],minHeight: 8,),

            const SizedBox(height: 12),

        Text(
          message,
          style:const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, int value) {
    return Container(
      width: 90,
      padding:const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text("$value",
            style: const TextStyle(fontSize: 20,fontWeight:FontWeight.bold),
          ),
          Text(title),
        ],
      ),
    );
  }
}