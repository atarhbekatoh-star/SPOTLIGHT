import 'package:flutter/material.dart';
import 'main.dart';

final TextEditingController fullNameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();


// --- PAGE 3: REGISTER PAGE ---
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Create Account', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView( // This allows scrolling if the keyboard covers the fields
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Text('Join Spotlight', style: TextStyle(color: Colors.white, fontSize: 22)),
              const SizedBox(height: 30),
              _buildTextField('Full Name', fullNameController),
              const SizedBox(height: 15),
              _buildTextField('Email Address', emailController),
              const SizedBox(height: 15),
              _buildTextField('Username', usernameController),
              const SizedBox(height: 15),
              _buildTextField('Password', passwordController, isPassword: true),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
  // 1. First, check if the fields are actually filled
  if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
    
    // 2. This is where the "Check" happens
    // For now, we use a 'mock' check. Later this will be a database query.
    bool userAlreadyExists = false; 

    // ignore: dead_code
    if (userAlreadyExists) {
      // 3. Show the pop-up (SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This account already exists. Please login instead.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      // 4. If everything is fine, go to the Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(currentThemeMode: ThemeMode.dark, onThemeChanged: (mode) {})),
      );
    }
  }
},
              
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
     }

  // A small helper function to keep the code clean
  Widget _buildTextField(String hint, TextEditingController controller, {bool isPassword = false}) {
  return TextField(
    controller: controller, // This is the magic link!
    obscureText: isPassword,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF151325),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
 }
    
  }
