import 'package:flutter/material.dart';
import 'main.dart';


// --- PAGE 2: LOGIN PAGE ---
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Text('Login to your account', style: TextStyle(color: Colors.white, fontSize: 22)),
            const SizedBox(height: 30),
            TextField(
              controller: usernameController,              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Username', 
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true, 
                fillColor: const Color(0xFF151329),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Password', 
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true, 
                fillColor: const Color(0xFF151329),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Logic: Check if fields are not empty first
              if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(currentThemeMode: ThemeMode.dark, onThemeChanged: (mode) {})),
                );
              }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}