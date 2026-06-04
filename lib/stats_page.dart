import 'package:flutter/material.dart';
import 'package:multi_charts/multi_charts.dart';

class chatPage extends StatefulWidget {
  const chatPage({super.key});

  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  bool _quizCompleted = false;
  int _currentIndex = 0;

  // Initializing scores for the 5 attributes
  final Map<String, double> _scores = {
    "Charisma": 0.1,
    "Empathy": 0.1,
    "Presence": 0.1,
    "Vitality": 0.1,
    "Intellect": 0.1,
  };

  // The 10 Mystical Questions
  final List<Map<String, dynamic>> _quizData = [
    {
      "q": "When you look at a stranger, do you see...",
      "options": [
        {"text": "A mystery to be solved", "attr": "Charisma", "val": 0.15},
        {"text": "A reflection of yourself", "attr": "Empathy", "val": 0.15},
      ],
    },
    {
      "q": "In a room full of shouting voices, are you...",
      "options": [
        {"text": "The lightning that strikes", "attr": "Presence", "val": 0.15},
        {"text": "The ground that absorbs", "attr": "Intellect", "val": 0.15},
      ],
    },
    {
      "q": "If your life was a sound in a canyon, it would be...",
      "options": [
        {"text": "A roar that lingers", "attr": "Charisma", "val": 0.15},
        {"text": "A whisper that fades", "attr": "Presence", "val": 0.15},
      ],
    },
    {
      "q": "Do you build your happiness on...",
      "options": [
        {"text": "The praise of the crowd", "attr": "Charisma", "val": 0.15},
        {"text": "Secret, unseen victories", "attr": "Intellect", "val": 0.15},
      ],
    },
    {
      "q": "If you had 24 hours left to speak, would you...",
      "options": [
        {
          "text": "Explain your story to the world",
          "attr": "Vitality",
          "val": 0.15,
        },
        {
          "text": "Listen to the stories of others",
          "attr": "Empathy",
          "val": 0.15,
        },
      ],
    },
    {
      "q": "When failure strikes your path, is it...",
      "options": [
        {"text": "A curse from the stars", "attr": "Vitality", "val": 0.1},
        {"text": "A price paid for a lesson", "attr": "Intellect", "val": 0.15},
      ],
    },
    {
      "q": "Is the 'you' the world sees...",
      "options": [
        {
          "text": "A carefully crafted character",
          "attr": "Presence",
          "val": 0.15,
        },
        {"text": "The raw, unpolished truth", "attr": "Empathy", "val": 0.1},
      ],
    },
    {
      "q": "Does another's success make your flame...",
      "options": [
        {
          "text": "Burn brighter with inspiration",
          "attr": "Charisma",
          "val": 0.15,
        },
        {"text": "Flicker with quiet doubt", "attr": "Intellect", "val": 0.1},
      ],
    },
    {
      "q": "When the river of life turns violent, do you...",
      "options": [
        {
          "text": "Fight the current until exhausted",
          "attr": "Presence",
          "val": 0.1,
        },
        {
          "text": "Learn to swim with the flow",
          "attr": "Vitality",
          "val": 0.15,
        },
      ],
    },
    {
      "q": "Faced with an unknown door, do you...",
      "options": [
        {"text": "Check the map and prepare", "attr": "Intellect", "val": 0.15},
        {"text": "Open it and walk through", "attr": "Charisma", "val": 0.15},
      ],
    },
  ];

  void _answerQuestion(String attr, double val) {
    setState(() {
      _scores[attr] = (_scores[attr]! + val).clamp(0.0, 1.0);
      if (_currentIndex < _quizData.length - 1) {
        _currentIndex++;
      } else {
        _quizCompleted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060914),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "ASCENSION QUIZ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _quizCompleted ? _buildRadarView() : _buildQuizView(),
    );
  }

  Widget _buildQuizView() {
    var currentQ = _quizData[_currentIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "STEP ${_currentIndex + 1} OF 10",
            style: TextStyle(
              color: Colors.purpleAccent.withAlpha(128),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            currentQ['q'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 50),
          ...currentQ['options'].map<Widget>((opt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: InkWell(
                onTap: () => _answerQuestion(opt['attr'], opt['val']),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 25,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11162D),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    opt['text'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRadarView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CHARACTER AWAKENED",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "SAM'S LIFE RADAR",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 350,
              width: 350,
              child: RadarChart(
                values: _scores.values.toList(),
                labels: _scores.keys.toList(),
                maxValue: 1.0,
                fillColor: Colors.purpleAccent.withAlpha(77),
                strokeColor: Colors.purpleAccent,
                labelColor: Colors.grey,
                chartRadiusFactor: 0.7,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF11162D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Complete missions and reflect in your journal to expand your attributes.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
