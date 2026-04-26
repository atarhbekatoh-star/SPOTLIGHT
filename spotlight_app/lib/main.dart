import 'package:flutter/material.dart';

import 'welcome_page.dart';
import 'login_page.dart';
import 'register_page.dart';

void main() {
  runApp(const SpotlightApp());
}

class SpotlightApp extends StatelessWidget {
  const SpotlightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotlight App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF100E1E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF423682),
          surface: const Color(0xFF151329),
        ),
        useMaterial3: true,
      ),
      // This tells Flutter to start on the Welcome Page!
      home: const WelcomePage(), 
    );
  }
}



        