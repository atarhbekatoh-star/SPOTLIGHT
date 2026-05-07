import 'package:flutter/material.dart';
import '../logic.dart'; // Ensure your logic.dart is in the lib folder

class PathPage extends StatefulWidget {
  const PathPage({super.key});

  @override
  _PathPageState createState() => _PathPageState();
}

class _PathPageState extends State<PathPage> {
  late List<Mission> allMissions;
  late int userStreak;

  @override
  void initState() {
    super.initState();

    // 1. Calculate Streak using OOP Manager
    final streakManager = StreakManager();
    userStreak = streakManager.updateStreak(
      lastLogin: DateTime.now().subtract(const Duration(hours: 26)),
      currentStreak: 3,
    );

    // 2. Generate 50 missions using OOP Classes
    allMissions = _generateMissions(50);
  }

  List<Mission> _generateMissions(int count) {
    return List.generate(count, (index) {
      int id = index + 1;
      // Alternate between Observational, Interaction, and Public based on level
      if (index % 3 == 0) {
        return ObservationalMission(
          id: id,
          title: "Step $id: Watch Body Language",
        );
      } else if (index % 3 == 1) {
        return InteractionMission(id: id, title: "Step $id: Say Hello");
      } else {
        return PublicMission(id: id, title: "Step $id: Public Boldness");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: Column(
          children: [
            _buildSpotlightHeader(),
            _buildInstructionLabel(),
            Expanded(child: _buildPathList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotlightHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6200EE), Color(0xFFBB86FC)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "CONFIDENCE RADAR",
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
                const Text(
                  "Road to Mastery",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // DISPLAY THE CALCULATED STREAK HERE
          Row(
            children: [
              const Icon(Icons.local_fire_department, color: Colors.orange),
              Text(
                " $userStreak",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionLabel() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "SOCIAL CHALLENGE: COMPLETE YOUR DAILY MISSION",
        style: TextStyle(
          color: Color(0xFF03DAC6),
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildPathList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 40),
      itemCount: allMissions.length,
      itemBuilder: (context, index) {
        final mission = allMissions[index];

        // ZIG-ZAG LOGIC
        double offset;
        int pos = index % 4;
        if (pos == 0)
          offset = -50.0;
        else if (pos == 1 || pos == 3)
          offset = 0.0;
        else
          offset = 50.0;

        return Transform.translate(
          offset: Offset(offset, 0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => print("Started: ${mission.title}"),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: mission.color,
                  child: Icon(mission.icon, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mission.title,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              const SizedBox(height: 40), // Space between nodes
            ],
          ),
        );
      },
    );
  }
}
