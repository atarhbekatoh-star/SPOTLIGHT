import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  // This list handles the "18 tasks" logic later
  final List<Widget> _pages = [
    const Center(child: Text("Home - Your Progress", style: TextStyle(color: Colors.white))),
    const Center(child: Text("Paths - Hero Path & More", style: TextStyle(color: Colors.white))),
    const Center(child: Text("Practice - Mic Access", style: TextStyle(color: Colors.white))),
    const Center(child: Text("Profile - Awards", style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF100E1E), // Your Dark Theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("SPOTLIGHT", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.white))],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF151325),
        selectedItemColor: const Color(0xFF423682), // Your Accent Color
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Paths'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Practice'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}