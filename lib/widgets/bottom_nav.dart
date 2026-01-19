import 'package:flutter/material.dart';
import 'package:focus_forge/screens/home.dart';
import 'package:focus_forge/screens/progress_screen.dart';
import 'package:focus_forge/widgets/focustimer.dart';
import '../screens/profile/profile.dart';


class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    ProgressScreen(),
    FocusScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        backgroundColor: const Color(0xfffff5e0),
        selectedItemColor: const Color(0xff272340),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
         BottomNavigationBarItem(icon: Icon(Icons.calendar_month),
           label:"Progress",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.timer),
            label:"Focus",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded),
            label:"Profile",
          ),
        ],
      ),
    );
  }
}