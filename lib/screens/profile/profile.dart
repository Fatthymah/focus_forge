import 'package:flutter/material.dart';
import 'package:focus_forge/constants/app_texts.app.dart';
import 'package:focus_forge/auth/login.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/profile_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final box = Hive.box<ProfileModel>('profileBox');
  int userKey = -1;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  String? profileImagePath;


  @override
  void initState() { // Runs once when screen opens
    super.initState();
     loadProfile();
  }


  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    userKey = prefs.getInt("currentUserKey") ?? -1;

    if (userKey == -1) return;

    // 1. If profile already saved → load from profileBox
    if (box.containsKey(userKey)) {
      final profile = box.get(userKey)!;
      nameController.text = profile.name;
      emailController.text = profile.email;
      bioController.text = profile.bio;
      profileImagePath = profile.imagePath;
    }
    // 2. Else → load from signup data (userBox)
    else {
      final userBox = Hive.box<UserModel>('userBox');
      final user = userBox.get(userKey);

      if (user != null) {
        nameController.text = user.name;
        emailController.text = user.email;
        bioController.text = ""; // no bio at signup
        profileImagePath = null;
      }
    }
    setState(() {});
  }

  Future<void> pickImage() async {
    final XFile? image =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImagePath = image.path;
      });
    }
  }


  void saveProfile() {
    if(userKey == -1) return;

    final profile = ProfileModel(
      name: nameController.text,
      email: emailController.text,
      bio: bioController.text,
      imagePath: profileImagePath,
    );

    box.put(userKey, profile);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff5e0),
      appBar: AppBar(
        title: const Text(
            "My Profile",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,letterSpacing: 1),
        ),
        backgroundColor: const Color(0xff312c51),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xfff0c38e),
                    backgroundImage: profileImagePath != null
                        ? FileImage(File(profileImagePath!))
                        : null,
                    child: profileImagePath == null
                        ? const Icon(Icons.person, size: 50, color: Color(0xff312c51))
                        : null,
                  ),

                  // Camera icon
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xff312c51),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),


            const SizedBox(height: 40),

            _field("Name", nameController),
            const SizedBox(height: 20),

            _field("Email", emailController),
            const SizedBox(height: 20),

            _field("Bio", bioController, maxLines: 3),
             const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff312c51),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: saveProfile,
                child: const Text(
                  //"Save Profile",
                  AppTexts.saveProfile,
                  style: TextStyle(
                    color: Color(0xfffff5e0),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ElevatedButton(
                onPressed:() async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool("isLoggedIn", false);
                  await prefs.remove("currentUserKey");

                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                  );
                },
              child: const Text(
                  "Logout",
                style:TextStyle(
                  color:Color(0xff312c51),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ElevatedButton(
            //   onPressed: () async {
            //     final prefs = await SharedPreferences.getInstance();
            //     await prefs.remove("seenOnboarding"); // Reset onboarding
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text("Onboarding reset. Restart app to view it.")),
            //     );
            //   },
            //   child: const Text("Show Onboarding (Demo)"),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _field(
      String hint,
      TextEditingController controller, {
        int maxLines = 1,
      }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xffffdbc3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
