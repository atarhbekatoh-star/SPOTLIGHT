import 'package:flutter/material.dart';

class PathPage extends StatefulWidget {
  @override
  _PathPageState createState() => _PathPageState();
}

class _PathPageState extends State<PathPage> {
  int xp = 30;
  int currentLevelIndex = 0;

  final List<Map<String, dynamic>> levels = [
    {"title": "Extra", "icon": "👤", "color": Colors.grey},
    {"title": "Supporting Role", "icon": "🎭", "color": Colors.blueAccent},
    {"title": "Main Character", "icon": "✨", "color": Colors.purpleAccent},
    {"title": "Leading Role", "icon": "👑", "color": Colors.amber},
  ];

  void _gainXP() {
    setState(() {
      xp += 25; // Bigger jump for better feel
      if (xp >= 100) {
        if (currentLevelIndex < levels.length - 1) {
          xp = 0;
          currentLevelIndex++;
          _showLevelUpDialog();
        } else {
          xp = 100; // Maxed out
        }
      }
    });
  }

  void _showLevelUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("LEVEL UP! 🎉", style: TextStyle(color: Colors.white)),
        content: Text(
          "You are now a ${levels[currentLevelIndex]['title']}!",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("LFG!"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0F1A), // Sleek dark background
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 40),
                children: [
                  _buildPathNode(3, true),
                  _buildConnector(),
                  _buildPathNode(2, false),
                  _buildConnector(),
                  _buildPathNode(1, false),
                  _buildConnector(),
                  _buildPathNode(0, false),
                ],
              ),
            ),
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E2E),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "🔥 5 Day Streak",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.settings, color: Colors.white54),
            ],
          ),
          SizedBox(height: 20),
          Text(
            levels[currentLevelIndex]['title'].toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: xp / 100,
              minHeight: 12,
              backgroundColor: Colors.white10,
              color: levels[currentLevelIndex]['color'],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "$xp / 100 XP to next rank",
            style: TextStyle(color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildPathNode(int index, bool isLocked) {
    bool isCurrent = index == currentLevelIndex;
    bool isPassed = index < currentLevelIndex;

    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPassed || isCurrent
                ? levels[index]['color']
                : Colors.white10,
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: levels[index]['color'].withOpacity(0.5),
                      blurRadius: 20,
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(levels[index]['icon'], style: TextStyle(fontSize: 40)),
          ),
        ),
        SizedBox(height: 8),
        Text(
          levels[index]['title'],
          style: TextStyle(
            color: isPassed || isCurrent ? Colors.white : Colors.white24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildConnector() {
    return Container(
      height: 40,
      width: 4,
      color: Colors.white10,
      margin: EdgeInsets.symmetric(vertical: 8),
    );
  }

  Widget _buildBottomAction() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purpleAccent,
          minimumSize: Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: _gainXP,
        child: Text(
          "COMPLETE DAILY MISSION",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
