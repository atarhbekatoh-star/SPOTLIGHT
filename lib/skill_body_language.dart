import 'package:flutter/material.dart';

class BodyLanguageDetailPage extends StatelessWidget {
  const BodyLanguageDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color shelleyTeal = Color(0xFF4DB6AC);
    const Color darkBackground = Color(0xFF060914);
    const Color cardBackground = Color(0xFF11162D);

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Skill Statistics",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Gothic Study Atmosphere
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [shelleyTeal.withAlpha(26), darkBackground],
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 120,
              bottom: 40,
            ),
            child: Column(
              children: [
                const Text(
                  "BODY LANGUAGE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const Text(
                  "(Level 1)",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 30),

                // THE QUOTE
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "\"Actions speak louder than words. Beware; for I am fearless, and therefore powerful.\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: shelleyTeal,
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Text(
                  "- Mary Shelley",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 40),

                // PROGRESS SECTION
                Row(
                  children: [
                    const Text(
                      "40 / 200 XP",
                      style: TextStyle(
                        color: shelleyTeal,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          value: 0.2,
                          backgroundColor: Colors.white10,
                          color: shelleyTeal,
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // GESTURE CONTROL PIE CHART (Placeholder)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: shelleyTeal.withAlpha(26)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Gesture Mastery",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 150,
                            child: CircularProgressIndicator(
                              value: 0.6,
                              strokeWidth: 15,
                              color: shelleyTeal,
                              backgroundColor: shelleyTeal.withAlpha(26),
                            ),
                          ),
                          const Column(
                            children: [
                              Text(
                                "Level 2",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Control",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _buildStatTile(
                  "Missions",
                  "1",
                  Icons.auto_stories,
                  shelleyTeal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF11162D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}
