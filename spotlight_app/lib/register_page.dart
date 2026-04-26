import 'package:flutter/material.dart';


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
              _buildTextField('Full Name'),
              const SizedBox(height: 15),
              _buildTextField('Email Address'),
              const SizedBox(height: 15),
              _buildTextField('Username'),
              const SizedBox(height: 15),
              _buildTextField('Password', isPassword: true),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // This is where you'd save the data to the database!
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
  Widget _buildTextField(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint, 
        filled: true, 
        fillColor: const Color(0xFF151329),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}