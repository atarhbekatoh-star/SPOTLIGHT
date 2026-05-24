import 'package:flutter/material.dart';

class PublicSpeakingDetailPage extends StatelessWidget {
  const PublicSpeakingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color themeGold = Color(0xFFFFB74D); // Jack Sparrow Gold/Orange
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
          // THEME BACKGROUND (Pirate Ship/Compass feel)
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.5),
                radius: 1.0,
                colors: [themeGold.withAlpha(38), darkBackground],
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
                  "PUBLIC SPEAKING",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "(Level 1)",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 25),

                // THE QUOTE
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "\"The problem is not the problem. The problem is your attitude about the problem.\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeGold,
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Text(
                  "- Jack Sparrow",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),

                const SizedBox(height: 30),

                // PROGRESS BAR
                Row(
                  children: [
                    const Text(
                      "80 / 200 XP",
                      style: TextStyle(
                        color: themeGold,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          value: 0.4,
                          backgroundColor: Colors.white10,
                          color: themeGold,
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // THE GRAPH CARD (Peak Confidence)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: themeGold.withAlpha(51)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Peak Confidence",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Icon(
                          Icons.show_chart,
                          color: themeGold,
                          size: 100,
                        ), // This represents the graph
                      ),
                      const Center(
                        child: Text(
                          "75%",
                          style: TextStyle(
                            color: themeGold,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // SMALL STATS ROW
                Row(
                  children: [
                    _buildMiniStat(
                      "Time on Stage",
                      "1h 45m",
                      Icons.timer,
                      themeGold,
                    ),
                    const SizedBox(width: 15),
                    _buildMiniStat("Audience", "35", Icons.people, themeGold),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF11162D),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
