import 'package:flutter/material.dart';

class ActiveListeningDetailPage extends StatelessWidget {
  const ActiveListeningDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color gojoPurple = Color(0xFFBB86FC);
    const Color gojoCyan = Color(0xFF03DAC6);
    const Color darkBackground = Color(0xFF060914);

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
          // Infinite Void Atmosphere
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  gojoPurple.withAlpha(26),
                  darkBackground,
                  gojoCyan.withAlpha(13),
                ],
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
                  "ACTIVE LISTENING",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
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
                    "\"Listen first, and speak after. Only I can decide if I'm strong or weak.\"",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gojoPurple,
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Text(
                  "- Gojo Satoru",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 40),

                // chats  GRID
                Row(
                  children: [
                    _buildGojoStat(
                      "Understanding",
                      "88%",
                      Icons.psychology,
                      gojoPurple,
                    ),
                    const SizedBox(width: 15),
                    _buildGojoStat(
                      "Focus Time",
                      "2h 30m",
                      Icons.visibility,
                      gojoCyan,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // EFFICIENCY GRAPH (Visual Placeholder)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11162D),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: gojoPurple.withAlpha(51)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Listening Efficiency",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // A series of bars to simulate a graph
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                          7,
                          (index) => Container(
                            width: 15,
                            height: (index + 1) * 15.0,
                            decoration: BoxDecoration(
                              color: gojoPurple.withAlpha(153),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGojoStat(
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
          border: Border.all(color: color.withAlpha(26)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
