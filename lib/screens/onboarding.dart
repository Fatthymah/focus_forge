import 'package:flutter/material.dart';
import 'package:focus_forge/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E0),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: const [
                OnboardPage(
                  imagePath: "assets/images/Working-pana.png",
                  title: "Understand Your Energy",
                  description:
                  "Not every day feels the same.\nWork according to how you feel.",
                ),
                OnboardPage(
                  imagePath: "assets/images/Focus-amico.png",
                  title: "Choose the Right Tasks",
                  description:
                  "Low energy or high energy.\nPick tasks that suit your mind.",
                ),
                OnboardPage(
                  imagePath: "assets/images/Critical thinking-amico.png",
                  title: "Focus Without Pressure",
                  description:
                  "Small focus sessions.\nNo guilt. No burnout.",
                ),
              ],
            ),
          ),

          // Slider dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
                  (index) => buildDot(index),
            ),
          ),

          const SizedBox(height: 30),

          // Get Started button only on last page
          if (currentIndex == 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async{
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool("seenOnboarding", true);

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen(),
                    ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF312C51),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFFF5E0),
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Dot widget
  Widget buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: currentIndex == index ? 20 : 8,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? const Color(0xFF312C51)
            : const Color(0xFF48426D).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class OnboardPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),

        // Top Image
        Image.asset(
          imagePath,
          height: 350,
          fit: BoxFit.contain,
        ),

        const Spacer(),

        // Bottom container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF312C51),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 17,
                  color: Color(0xFF48426D),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
