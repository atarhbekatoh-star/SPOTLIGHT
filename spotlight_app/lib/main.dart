import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: const Color(0xFF0A0A14), // Deep black
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B3FF2), // Vibrant purple
          surface: const Color(0xFF1a1a2e), // Dark purple-black
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1a1a2e),
          foregroundColor: Color(0xFF7B3FF2),
        ),
      ),
      // This tells Flutter to start on the Practice Page for testing!
      home: const PracticePage(),
    );
  }
}

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Practice Page',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}