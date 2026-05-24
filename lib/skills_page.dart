import 'package:flutter/material.dart';
import 'skills_start_conversations.dart';
import 'skill_public_speaking.dart';
import 'skill_active_listening.dart';
import 'skill_body_language.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> skills = [
      {
        "title": "Start Conversations",
        "level": "Level 2",
        "xp": "320 / 300",
        "progress": 1.0,
        "icon": Icons.chat_bubble,
        "color": Colors.blueAccent,
        "isLocked": false,
      },
      {
        "title": "Public Speaking",
        "level": "Level 1",
        "xp": "80 / 200",
        "progress": 0.4,
        "icon": Icons.mic,
        "color": Colors.orangeAccent,
        "isLocked": false,
      },
      {
        "title": "Active Listening",
        "level": "Level 1",
        "xp": "60 / 200",
        "progress": 0.3,
        "icon": Icons.hearing,
        "color": Colors.purpleAccent,
        "isLocked": false,
      },
      {
        "title": "Body Language",
        "level": "Level 1",
        "xp": "40 / 200",
        "progress": 0.2,
        "icon": Icons.person,
        "color": Colors.tealAccent,
        "isLocked": false,
      },
      {
        "title": "Persuasion",
        "level": "Locked",
        "xp": "0 / 500",
        "progress": 0.0,
        "icon": Icons.bolt,
        "color": Colors.grey,
        "isLocked": true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Practice",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ),
      body: Column(
        children: [
          // The active "Task to Practice" section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.teal, Color(0xFF004D40)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.psychology,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Today's Practice Task",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "15 Min",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Mirroring Body Language",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Try to subtly mirror the posture and hand gestures of the person you are talking to today. This builds subconscious rapport.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Practice session started!"),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Start Exercise",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ALL SKILLS",
                style: theme.textTheme.titleSmall?.copyWith(letterSpacing: 1.2),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                return _buildVerticalSkillCard(context, skills[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalSkillCard(
    BuildContext context,
    Map<String, dynamic> skill,
  ) {
    bool isLocked = skill['isLocked'];
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          if (isLocked) {
            _showLockedMessage(context, skill['title']);
          } else {
            if (skill['title'] == "Start Conversations") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StartConversationsDetailPage(),
                ),
              );
            } else if (skill['title'] == "Public Speaking") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PublicSpeakingDetailPage(),
                ),
              );
            } else if (skill['title'] == "Active Listening") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ActiveListeningDetailPage(),
                ),
              );
            } else if (skill['title'] == "Body Language") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BodyLanguageDetailPage(),
                ),
              );
            } else {
              _showSkillDetail(context, skill['title']);
            }
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isLocked
                  ? theme.textTheme.titleSmall!.color!.withAlpha(30)
                  : theme.primaryColor.withAlpha(20),
            ),
          ),
          child: Opacity(
            opacity: isLocked ? 0.5 : 1.0,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (skill['color'] as Color).withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isLocked ? Icons.lock : skill['icon'],
                        color: skill['color'],
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            skill['title'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            skill['level'],
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: theme.textTheme.titleSmall?.color,
                      size: 14,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${skill['xp']} XP",
                      style: theme.textTheme.titleSmall?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: skill['progress'],
                    backgroundColor: theme.scaffoldBackgroundColor,
                    color: skill['color'],
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSkillDetail(BuildContext context, String title) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("The cinematic $title screen is coming soon!"),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLockedMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Reach Level 5 to unlock $title!"),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
