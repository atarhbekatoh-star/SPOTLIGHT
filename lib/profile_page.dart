import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'mbti_quiz_page.dart';
import 'pages/chat/qr_page.dart';
import 'welcome_page.dart';

class ProfilePage extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeChanged;
  final String userName;
  final String fullName;

  const ProfilePage({
    super.key,
    required this.currentThemeMode,
    required this.onThemeChanged,
    required this.userName,
    required this.fullName,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // -----------------------------
  // USER DATA
  // -----------------------------

  final String bio = "Flutter enthusiast. Lifelong learner. Coffee lover. Always striving to level up my skills and connect with amazing people in the tech community.";

  final int streakDays = 7;
  final int badges = 3;
  final int weeklyProgress = 68;

  final int mutualFriends = 12;
  final int mutualGroups = 3;

  bool isFollowing = false;

  File? _selectedImage;

  // -----------------------------
  // MBTI DATA (UPDATABLE)
  // -----------------------------

  String personalityType = "Take the MBTI Quiz";
  String learningStyle = "Your learning style will appear here.";

  List<String> strengths = [
    "Complete the personality test",
  ];

  String aiInsight =
      "Your personality insights will appear after taking the test.";

  // -----------------------------
  // GOALS
  // -----------------------------

  final List<String> goals = [
    "Complete 3 practice sessions",
    "Maintain 7-day streak",
    "Unlock next badge",
  ];

  void updatePersonalityData(Map<String, dynamic> result) {
    setState(() {
      personalityType = result["type"];

      learningStyle =
          result["type"].contains("N")
              ? "Creative & Intuitive Learner"
              : "Structured & Practical Learner";

      strengths = List<String>.from(result["strengths"]);

      aiInsight = result["insight"];
    });
  }
Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      print("User picked image: ${image.path}");
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appProvider = context.watch<AppProvider>();
    final int xp = appProvider.xp;
    final int level = appProvider.level;
    final int nextLevelXp = appProvider.nextLevelXp;
    final double progressToNextLevel = appProvider.progressToNextLevel;
    final String currentRank = "✨ ${appProvider.currentRank}";

    final isDarkMode =
        appProvider.themeMode == ThemeMode.dark ||
        (appProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness ==
                Brightness.dark);

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
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Color(0xFFBB86FC)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QRPage()),
              );
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),

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
                      child: _selectedImage == null
                          ? const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.person, size: 55, color: Colors.white),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(_selectedImage!),
                            ),
                    ),

                    GestureDetector(
                      onTap: () {
                        print("Plus sign tapped!");
                        // Logic to change profile picture
                        _pickImage();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                      
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  widget.fullName,

                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '@${widget.userName}',

                  style: TextStyle(
                    color: Colors.white.withAlpha(180),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  currentRank,

                  style: const TextStyle(
                    color: Color(0xFFBB86FC),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                // FOLLOW / MESSAGE BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isFollowing = !isFollowing;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFollowing ? Colors.transparent : const Color(0xFFBB86FC),
                        foregroundColor: isFollowing ? const Color(0xFFBB86FC) : Colors.white,
                        side: const BorderSide(color: Color(0xFFBB86FC), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(isFollowing ? "Following" : "Follow"),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () {
                        // Message logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16161A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text("Message"),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // MUTUALS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$mutualFriends Mutual Friends", style: const TextStyle(color: Colors.white54, fontSize: 13)),
                    const SizedBox(width: 15),
                    const Text("•", style: TextStyle(color: Colors.white54)),
                    const SizedBox(width: 15),
                    Text("$mutualGroups Mutual Groups", style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  ],
                ),

                const SizedBox(height: 20),

                // MBTI QUIZ BUTTON

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MBTIQuizPage(
                            onQuizCompleted:
                                updatePersonalityData,
                          ),
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF7B61FF),

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 16,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                    ),

                    child: const Text(
                      "Take Personality Test",

                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  "LEVEL $level",

                  style: const TextStyle(
                    color: Colors.white70,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "$xp / $nextLevelXp XP",

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20),

                  child: LinearProgressIndicator(
                    value: progressToNextLevel,
                    minHeight: 10,
                    backgroundColor: Colors.white24,

                    valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // MINI STATS

          Row(
            children: [
              Expanded(
                child: _buildMiniStatCard(
                  icon:
                      Icons.local_fire_department,
                  title:
                      "$streakDays Day Streak",
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

          // PERSONALITY PROFILE

          _buildSectionCard(
            title: "Personality Profile",
            icon: Icons.psychology,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

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

          // STRENGTHS

          _buildSectionCard(
            title: "Your Strengths",
            icon: Icons.auto_awesome,

            child: Column(
              children:
                  strengths
                      .map(
                        (strength) => Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 12,
                          ),

                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color:
                                    Colors.greenAccent,
                                size: 18,
                              ),

                              const SizedBox(
                                  width: 10),

                              Expanded(
                                child: Text(
                                  strength,

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white70,
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,

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
                  borderRadius:
                      BorderRadius.circular(20),

                  child: LinearProgressIndicator(
                    value: weeklyProgress / 100,
                    minHeight: 10,
                    backgroundColor:
                        Colors.white10,

                    valueColor:
                        const AlwaysStoppedAnimation<
                            Color>(
                      Color(0xFFBB86FC),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // GOALS

          _buildSectionCard(
            title: "Current Goals",
            icon: Icons.flag,

            child: Column(
              children:
                  goals
                      .map(
                        (goal) => Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 12,
                          ),

                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .radio_button_checked,
                                color:
                                    Color(0xFFBB86FC),
                                size: 18,
                              ),

                              const SizedBox(
                                  width: 10),

                              Expanded(
                                child: Text(
                                  goal,

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white70,
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

          // AI INSIGHT

          Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(20),

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
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFFBB86FC),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    aiInsight,

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

          // DARK MODE

          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: SwitchListTile(
              title: const Text("Dark Theme"),

              secondary: Icon(
                isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),

              value: isDarkMode,

              activeTrackColor:
                  Colors.purpleAccent.withAlpha(
                100,
              ),

              onChanged: (bool value) {
                appProvider.setThemeMode(
                  value
                      ? ThemeMode.dark
                      : ThemeMode.light,
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          // SETTINGS

          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: ListTile(
              leading: const Icon(Icons.settings),

              title: const Text("Settings"),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // MINI STAT CARD

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

  // SECTION CARD

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
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFFBB86FC),
              ),

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

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingsTile(
            context,
            icon: Icons.person,
            title: "Account Settings",
            onTap: () {},
          ),
          _buildSettingsTile(
            context,
            icon: Icons.lock,
            title: "Privacy",
            onTap: () {},
          ),
          _buildSettingsTile(
            context,
            icon: Icons.notifications,
            title: "Notifications",
            onTap: () {},
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const WelcomePage()),
                (Route<dynamic> route) => false,
              );
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            tileColor: theme.cardColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFBB86FC)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        tileColor: Theme.of(context).cardColor,
        onTap: onTap,
      ),
    );
  }
}