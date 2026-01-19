import 'package:flutter/material.dart';
import 'package:focus_forge/onboarding.dart';
import 'package:focus_forge/screens/login.dart';
import 'package:focus_forge/widgets/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkUserFlow();
  }

  void _checkUserFlow() async {
      final prefs = await SharedPreferences.getInstance();
      final loggedIn = prefs.getBool("isLoggedIn") ?? false;
      final seenOnboarding = prefs.getBool("seenOnboarding") ?? false;

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // if user has not seen onboarding = go to seenOnboarding
      if(!seenOnboarding) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
      // if user is logged in = go to home
      else if(loggedIn) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BottomNav()),
        );
      }
      // otherwise = go to login
      else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:const Color(0xff312c51),
      body:Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon
            Container(
              height: 100,
              width:100,
              decoration: BoxDecoration(
                color:const Color(0xfff0c38e),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.timer,
                size:50,
                color:Color(0xff312c51),
              ),
            ),

            const SizedBox(height: 24),

            // App Name
            const Text(
              "Focus Forge",
              style:TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color:Color(0xfffff5e0),
              ),
            ),
            const SizedBox(height:8),
            // Tagline
            const Text(
              "Work with your energy",
              style:TextStyle(
                fontSize: 20,
                color:Color(0xfff0c38e),
              ),
            ),
          ],
        ),
      ),
    );
  }
}