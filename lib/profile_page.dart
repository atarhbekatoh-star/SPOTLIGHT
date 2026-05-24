
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeChanged;

  const ProfilePage({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // -----------------------------
  // MOCK BACKEND DATA
  // Later you can replace this
  // with Firebase/API/database data
  // -----------------------------

  final String userName = "Sam";
  final String currentRank = "✨ Main Character";
  final int xp = 250;
  final int maxXp = 500;
  final int streakDays = 7;
  final int badges = 3;
  final int weeklyProgress = 68;

  final String personalityType = "ENFP - The Campaigner";
  final String learningStyle = "Visual & Interactive Learner";

  final List<String> strengths = [
    "Creative Thinking",
    "Fast Learner",
    "Strong Communication",
    "High Motivation",
  ];

  final List<String> goals = [
    "Complete 3 practice sessions",
    "Maintain 7-day streak",
    "Unlock next badge",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDarkMode =
        widget.currentThemeMode == ThemeMode.dark ||
        (widget.currentThemeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const SizedBox(height: 10),

          // PROFILE HEADER
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6200EA),
                            Color(0xFF1A237E),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withAlpha(80),
                            blurRadius: 20,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 55,
                        color: Colors.white,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  currentRank,
                  style: const TextStyle(
                    color: Color(0xFFBB86FC),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // XP CARD
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6A5AE0),
                  Color(0xFF4B3AC7),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "LEVEL PROGRESS",
                  style: TextStyle(
                    color: Colors.white70,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "$xp / $maxXp XP",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: xp / maxXp,
                    minHeight: 10,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // STATS ROW
          Row(
            children: [
              Expanded(
                child: _buildMiniStatCard(
                  icon: Icons.local_fire_department,
                  title: "$streakDays Day Streak",
                  color: Colors.orange,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: _buildMiniStatCard(
                  icon: Icons.workspace_premium,
                  title: "$badges Badges",
                  color: Colors.amber,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // PERSONALITY CARD
          _buildSectionCard(
            title: "Personality Profile",
            icon: Icons.psychology,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  personalityType,
                  style: const TextStyle(
                    color: Color(0xFFBB86FC),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  learningStyle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // STRENGTHS CARD
          _buildSectionCard(
            title: "Your Strengths",
            icon: Icons.auto_awesome,
            child: Column(
              children: strengths
                  .map(
                    (strength) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.greenAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              strength,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 20),

          // WEEKLY PROGRESS
          _buildSectionCard(
            title: "Weekly Progress",
            icon: Icons.bar_chart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$weeklyProgress% Complete",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 15),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: weeklyProgress / 100,
                    minHeight: 10,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFBB86FC),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // GOALS SECTION
          _buildSectionCard(
            title: "Current Goals",
            icon: Icons.flag,
            child: Column(
              children: goals
                  .map(
                    (goal) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.radio_button_checked,
                            color: Color(0xFFBB86FC),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              goal,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 20),

          // AI INSIGHT CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withAlpha(40),
                  Colors.blue.withAlpha(30),
                ],
              ),
              border: Border.all(
                color: Colors.purple.withAlpha(80),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFFBB86FC),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    "Your consistency is improving rapidly. Keep practicing daily to unlock your next achievement and level up faster.",
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // THEME SETTINGS
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SwitchListTile(
              title: const Text("Dark Theme"),
              secondary: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              value: isDarkMode,
              activeTrackColor: Colors.purpleAccent.withAlpha(100),
              onChanged: (bool value) {
                widget.onThemeChanged(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          // SETTINGS TILE
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Settings coming soon!"),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // -----------------------------
  // REUSABLE MINI STAT CARD
  // -----------------------------

  Widget _buildMiniStatCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B2F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // REUSABLE SECTION CARD
  // -----------------------------

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B2F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFBB86FC)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }
}
