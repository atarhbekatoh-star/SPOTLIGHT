import 'package:flutter/material.dart';

class MBTIQuizPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onQuizCompleted;

  const MBTIQuizPage({
    super.key,
    required this.onQuizCompleted,
  });

  @override
  State<MBTIQuizPage> createState() => _MBTIQuizPageState();
}

class _MBTIQuizPageState extends State<MBTIQuizPage> {
  int currentQuestion = 0;

  int eScore = 0;
  int iScore = 0;

  int sScore = 0;
  int nScore = 0;

  int tScore = 0;
  int fScore = 0;

  int jScore = 0;
  int pScore = 0;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "After a long week, what recharges you more?",
      "a": "Going out with friends",
      "b": "Being alone quietly",
      "dimension": "EI"
    },
    {
      "question": "When learning something new...",
      "a": "I focus on practical details",
      "b": "I focus on ideas and possibilities",
      "dimension": "SN"
    },
    {
      "question": "When making decisions...",
      "a": "Logic matters most",
      "b": "People and emotions matter most",
      "dimension": "TF"
    },
    {
      "question": "Your ideal day usually is...",
      "a": "Planned and organized",
      "b": "Flexible and spontaneous",
      "dimension": "JP"
    },
    {
      "question": "In conversations you usually...",
      "a": "Speak first, think later",
      "b": "Think first, then speak",
      "dimension": "EI"
    },
    {
      "question": "You trust more in...",
      "a": "Experience and facts",
      "b": "Instincts and patterns",
      "dimension": "SN"
    },
    {
      "question": "People describe you as...",
      "a": "Objective",
      "b": "Empathetic",
      "dimension": "TF"
    },
    {
      "question": "Deadlines feel...",
      "a": "Motivating",
      "b": "Restricting",
      "dimension": "JP"
    },
    {
      "question": "You enjoy...",
      "a": "Social energy",
      "b": "Deep alone time",
      "dimension": "EI"
    },
    {
      "question": "You prefer life to feel...",
      "a": "Structured",
      "b": "Open-ended",
      "dimension": "JP"
    },
  ];

  void answerQuestion(bool choseA) {
    String dimension = questions[currentQuestion]["dimension"];

    switch (dimension) {
      case "EI":
        choseA ? eScore++ : iScore++;
        break;

      case "SN":
        choseA ? sScore++ : nScore++;
        break;

      case "TF":
        choseA ? tScore++ : fScore++;
        break;

      case "JP":
        choseA ? jScore++ : pScore++;
        break;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      finishQuiz();
    }
  }

  void finishQuiz() {
    String mbti =
        "${eScore >= iScore ? "E" : "I"}"
        "${sScore >= nScore ? "S" : "N"}"
        "${tScore >= fScore ? "T" : "F"}"
        "${jScore >= pScore ? "J" : "P"}";

    Map<String, dynamic> result = {
      "type": mbti,
      "strengths": getStrengths(mbti),
      "weaknesses": getWeaknesses(mbti),
      "insight": getInsight(mbti),
    };

    widget.onQuizCompleted(result);

    Navigator.pop(context);
  }

  List<String> getStrengths(String type) {
    if (type.contains("N")) {
      return [
        "Creative thinking",
        "Big imagination",
        "Visionary mindset",
      ];
    }

    return [
      "Practical thinking",
      "Reliable habits",
      "Attention to detail",
    ];
  }

  List<String> getWeaknesses(String type) {
    if (type.contains("P")) {
      return [
        "Can procrastinate",
        "Gets distracted easily",
        "Avoids structure",
      ];
    }

    return [
      "Can overwork",
      "Too perfectionistic",
      "Rigid sometimes",
    ];
  }

  String getInsight(String type) {
    if (type.startsWith("EN")) {
      return "You naturally inspire people and bring strong energy into social environments.";
    }

    if (type.startsWith("IN")) {
      return "You are reflective, imaginative, and emotionally deep.";
    }

    return "You balance logic, growth, and self-awareness in unique ways.";
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Scaffold(
      backgroundColor: const Color(0xFF100E1E),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Personality Quiz"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            LinearProgressIndicator(
              value: (currentQuestion + 1) / questions.length,
              backgroundColor: Colors.white12,
              color: const Color(0xFF7B61FF),
              minHeight: 8,
            ),

            const SizedBox(height: 40),

            Text(
              "Question ${currentQuestion + 1}",
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              question["question"],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            _answerButton(
              question["a"],
              () => answerQuestion(true),
            ),

            const SizedBox(height: 20),

            _answerButton(
              question["b"],
              () => answerQuestion(false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _answerButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: const Color(0xFF1B1830),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF7B61FF).withOpacity(0.3),
          ),
        ),

        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}