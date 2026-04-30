import 'package:flutter/material.dart';

class PathPage extends StatefulWidget {
  @override
  _PathPageState createState() => _PathPageState();
}

class _PathPageState extends State<PathPage> {
  // recurring themes for the 50-level journey
  final List<Map<String, dynamic>> themeTemplates = [
    {"icon": Icons.mic_external_on, "title": "Vocal Basics"},
    {"icon": Icons.accessibility_new, "title": "Body Language"},
    {"icon": Icons.groups, "title": "Small Groups"},
    {"icon": Icons.record_voice_over, "title": "Tone Mastery"},
    {"icon": Icons.campaign, "title": "Stage Presence"},
  ];

  late List<Map<String, dynamic>> allMissions;

  @override
  void initState() {
    super.initState();
    allMissions = _generateMissions(50);
  }

  // Generates 50 nodes with snaking offsets
  List<Map<String, dynamic>> _generateMissions(int count) {
    return List.generate(count, (index) {
      final template = themeTemplates[index % themeTemplates.length];

      double offset;
      int pos = index % 4;
      if (pos == 0)
        offset = -40.0; // Left-ish
      else if (pos == 1)
        offset = 0.0; // Center
      else if (pos == 2)
        offset = 40.0; // Right-ish
      else
        offset = 0.0; // Center

      return {
        "icon": template['icon'],
        "title": "Step ${index + 1}: ${template['title']}",
        "color": index == 0 ? Color(0xFFBB86FC) : Color(0xFF23363d),
        "hasTooltip": index == 0,
        "offset": offset,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21), // Midnight Stage Background
      body: SafeArea(
        child: Column(
          children: [
            _buildSpotlightHeader(),
            _buildInstructionLabel(),
            Expanded(
              child: Stack(
                children: [_buildPathList(), _buildBottomRightAction()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotlightHeader() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6200EE), Color(0xFFBB86FC)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CONFIDENCE RADAR",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
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
          Icon(Icons.auto_awesome, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildInstructionLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "CHALLENGE: SPEAK FOR 30 SECONDS",
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
      padding: EdgeInsets.symmetric(vertical: 40),
      itemCount: allMissions.length,
      itemBuilder: (context, index) {
        final node = allMissions[index];

        // Logic to show mascots on alternating sides
        bool showLeftMascot = index % 8 == 2;
        bool showRightMascot = index % 8 == 6;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Left Side Mascot
            if (showLeftMascot)
              Positioned(
                left: 20,
                child: _buildMascotUnit("Focus", Icons.psychology),
              ),

            // Right Side Mascot
            if (showRightMascot)
              Positioned(
                right: 20,
                child: _buildMascotUnit("Energy", Icons.bolt),
              ),

            // The Path Node
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Transform.translate(
                offset: Offset(node['offset'], 0),
                child: Column(
                  children: [
                    if (node['hasTooltip']) _buildJumpTooltip(),
                    _buildNodeCircle(node),
                    SizedBox(height: 8),
                    Text(
                      node['title'],
                      style: TextStyle(color: Colors.white24, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMascotUnit(String label, IconData icon) {
    return Opacity(
      opacity: 0.3,
      child: Column(
        children: [
          Icon(icon, size: 70, color: Color(0xFFBB86FC)),
          Text(label, style: TextStyle(color: Colors.white30, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildJumpTooltip() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFFBB86FC)),
          ),
          child: Text(
            "START HERE",
            style: TextStyle(
              color: Color(0xFF03DAC6),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(Icons.arrow_drop_down, color: Color(0xFFBB86FC)),
      ],
    );
  }

  Widget _buildNodeCircle(Map<String, dynamic> node) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: node['color'],
        boxShadow: [
          BoxShadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 2),
        ],
      ),
      child: Icon(node['icon'], color: Colors.white, size: 32),
    );
  }

  Widget _buildBottomRightAction() {
    return Positioned(
      bottom: 25,
      right: 25,
      child: FloatingActionButton(
        backgroundColor: Color(0xFF1E1E2E),
        onPressed: () {},
        shape: CircleBorder(
          side: BorderSide(color: Color(0xFF03DAC6), width: 2),
        ),
        child: Icon(Icons.insights, color: Color(0xFF03DAC6)),
      ),
    );
  }
}
