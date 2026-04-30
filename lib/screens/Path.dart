import 'package:flutter/material.dart';

class PathPage extends StatefulWidget {
  @override
  _PathPageState createState() => _PathPageState();
}

class _PathPageState extends State<PathPage> {
  // Personalized nodes for the "Spotlight" confidence journey
  final List<Map<String, dynamic>> nodes = [
    {
      "icon": Icons.mic_external_on,
      "color": Color(0xFFBB86FC), // Electric Purple
      "hasTooltip": true,
      "title": "First Words",
      "offset": 0.0,
    },
    {
      "icon": Icons.accessibility_new,
      "color": Color(0xFF23363d),
      "title": "Body Language",
      "offset": 50.0,
    },
    {
      "icon": Icons.groups,
      "color": Color(0xFF23363d),
      "title": "Small Crowds",
      "offset": 80.0,
    },
    {
      "icon": Icons.record_voice_over,
      "color": Color(0xFF23363d),
      "title": "Vocal Mastery",
      "offset": 40.0,
    },
    {
      "icon": Icons.campaign,
      "color": Color(0xFF23363d),
      "title": "The Spotlight",
      "offset": 0.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21), // Deep Midnight Blue
      body: SafeArea(
        child: Column(
          children: [
            _buildSpotlightHeader(),
            _buildInstructionLabel(),
            Expanded(
              child: Stack(
                children: [
                  _buildMascot(),
                  _buildPathList(),
                  _buildBottomRightAction(),
                ],
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6200EE), Color(0xFFBB86FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6200EE).withOpacity(0.4),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "STAGE 1, MODULE 3",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Breaking the Ice: Vocal Warmups",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.white24,
            margin: EdgeInsets.symmetric(horizontal: 12),
          ),
          Icon(Icons.auto_awesome, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildInstructionLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: Colors.white10, indent: 30, endIndent: 10),
          ),
          Text(
            "CHALLENGE: SPEAK FOR 30 SECONDS",
            style: TextStyle(
              color: Color(0xFF03DAC6), // Cyan accent
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
          Expanded(
            child: Divider(color: Colors.white10, indent: 10, endIndent: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildMascot() {
    return Positioned(
      left: 30,
      bottom: 150,
      child: Opacity(
        opacity: 0.6,
        child: Column(
          children: [
            Icon(Icons.psychology, size: 90, color: Color(0xFFBB86FC)),
            Text(
              "Focus",
              style: TextStyle(color: Colors.white30, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 60, bottom: 40),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        final node = nodes[index];
        return Center(
          child: Transform.translate(
            offset: Offset(node['offset'] ?? 0.0, 0),
            child: Column(
              children: [
                if (node['hasTooltip'] == true) _buildJumpTooltip(),
                _buildNodeCircle(node),
                SizedBox(height: 35),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildJumpTooltip() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFBB86FC).withOpacity(0.5)),
          ),
          child: Text(
            "START HERE",
            style: TextStyle(
              color: Color(0xFF03DAC6),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        Icon(Icons.arrow_drop_down, color: Color(0xFFBB86FC), size: 25),
      ],
    );
  }

  Widget _buildNodeCircle(Map<String, dynamic> node) {
    return Column(
      children: [
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: node['color'],
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 5),
                blurRadius: 2,
              ),
            ],
          ),
          child: Icon(node['icon'], color: Colors.white, size: 32),
        ),
        SizedBox(height: 5),
        Text(
          node['title'],
          style: TextStyle(
            color: Colors.white24,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRightAction() {
    return Positioned(
      bottom: 25,
      right: 25,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E2E),
          shape: BoxShape.circle,
          border: Border.all(color: Color(0xFF03DAC6), width: 2),
        ),
        child: Icon(Icons.insights, color: Color(0xFF03DAC6)),
      ),
    );
  }
}
