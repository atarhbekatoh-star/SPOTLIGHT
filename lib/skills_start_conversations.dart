import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StartConversationsDetailPage extends StatelessWidget {
  const StartConversationsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors matching the cinematic blue/BTS theme
    const Color themeBlue = Color(0xFF1976D2);
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
          // 1. CINEMATIC BACKGROUND IMAGE
          Opacity(
            opacity: 0.25,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                // This is a placeholder; eventually use your BTS silhouette image file
                imageUrl: "https://i.ibb.co/Xz95m6X/BTS-SILHOUETTE-DEMO.png",
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    Container(color: darkBackground),
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 120,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "START CONVERSATIONS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                const Text(
                  "(Level 2)",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 30),

                // 3. THE BTS QUOTE WIDGET
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      const Text(
                        "\"They said we're not allowed to do it. But we did it. Our only rival is ourselves.\"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "- BTS",
                        style: TextStyle(
                          color: Colors.white.withAlpha(128),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // 4. PROGRESS BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "320 / 300 XP",
                      style: TextStyle(
                        color: themeBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
                          value: 1.0,
                          backgroundColor: Colors.white10,
                          color: themeBlue,
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // 5. STATISTICS GRID (2x2)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.7,
                  children: [
                    _buildStatCard(
                      themeBlue,
                      cardBackground,
                      "Active Missions",
                      "3",
                      Icons.adjust,
                    ),
                    _buildStatCard(
                      themeBlue,
                      cardBackground,
                      "Completed",
                      "2",
                      Icons.check_circle_outline,
                    ),
                    _buildStatCard(
                      themeBlue,
                      cardBackground,
                      "People Met",
                      "27",
                      Icons.person_add_alt_1,
                    ),
                    _buildStatCard(
                      themeBlue,
                      cardBackground,
                      "Total Rewards",
                      "150XP",
                      Icons.workspace_premium,
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 6. MILESTONE CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withAlpha(13)),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Next Milestone",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          Text(
                            "150 XP",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.8,
                          backgroundColor: Colors.white10,
                          color: themeBlue.withAlpha(153),
                          minHeight: 6,
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

  // Stat Card Helper
  Widget _buildStatCard(
    Color themeBlue,
    Color cardBackground,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withAlpha(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: themeBlue, size: 22),
          const SizedBox(height: 8),
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
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
