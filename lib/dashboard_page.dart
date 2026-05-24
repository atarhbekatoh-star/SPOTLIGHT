import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'practice_page.dart';
import 'chat_page.dart';
import 'profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      const HomeContent(),
      const PracticePage(),
      const ChatPage(),

      // REMOVE const if ProfilePage has parameters
      ProfilePage(
        currentThemeMode: ThemeMode.dark,
        onThemeChanged: (ThemeMode mode) {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF100E1E),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: Text(
          "SPOTLIGHT",
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        backgroundColor: const Color(0xFF151325),

        selectedItemColor: const Color(0xFF7B61FF),
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: "Practice",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chat",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              "Welcome Back 👋",
              style: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Keep growing. You're doing amazing today.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

            _buildXPCard(),

            const SizedBox(height: 20),

            _buildSectionTitle("Quick Actions"),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _quickCard(
                    "Practice",
                    Icons.mic,
                    const Color(0xFF7B61FF),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _quickCard(
                    "AI Chat",
                    Icons.chat,
                    Colors.blueAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSectionTitle("Continue Learning"),

            const SizedBox(height: 14),

            _buildContinueCard(),

            const SizedBox(height: 24),

            _buildSectionTitle("Daily Goal"),

            const SizedBox(height: 14),

            _buildDailyGoalCard(),

            const SizedBox(height: 24),

            _buildMotivationCard(),
          ],
        ),
      ),
    );
  }

  static Widget _buildXPCard() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF1B1830),
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Today's Progress",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: const LinearProgressIndicator(
              value: 0.7,
              minHeight: 10,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation(
                Color(0xFF7B61FF),
              ),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "70 XP Earned",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _quickCard(
    String title,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: color.withAlpha(100),
        ),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildContinueCard() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF1B1830),
        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.deepPurple.withAlpha(40),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.play_arrow,
              color: Colors.deepPurpleAccent,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Conversation Practice",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "Continue where you left off",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDailyGoalCard() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF1B1830),
        borderRadius: BorderRadius.circular(22),
      ),

      child: const Row(
        children: [
          Icon(
            Icons.local_fire_department,
            color: Colors.orange,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              "Complete 3 practice sessions today",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildMotivationCard() {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7B61FF),
            Color(0xFF5B42D6),
          ],
        ),

        borderRadius: BorderRadius.circular(22),
      ),

      child: const Row(
        children: [
          Icon(
            Icons.auto_awesome,
            color: Colors.white,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              "Small progress every day leads to big results 🚀",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}