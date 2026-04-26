import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The "Spotlight" Icon
            const Icon(Icons.lightbulb, size: 100, color: Colors.amber),
            const SizedBox(height: 40),
            
            // Main Heading
             Text(
              'Own Every Room',
              textAlign: TextAlign.center,
             style: GoogleFonts.playfairDisplay(
               color: Colors.white,
               fontSize: 38, // Made it bigger like the photo
               fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            
            // Sub-text
            const Text(
              'Your journey to fearless public speaking starts here. Build the confidence to share your voice with the world.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 60),

            // CREATE ACCOUNT BUTTON
SizedBox(
  width: double.infinity,
  height: 60,
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white, 
      foregroundColor: Colors.black,
      shape: StadiumBorder(), // This makes it a perfect "Pill" shape
    ),
    child: const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  ),
),
const SizedBox(height: 25),

// LOGIN LINK
TextButton(
  onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
  },
  child: const Text(
    'Login',
    style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline),
  ),
),
          ],
        ),
      ),
    );
  }
}