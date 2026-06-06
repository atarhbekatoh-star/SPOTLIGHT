import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'dart:math';

class ScenarioSimulatorPage extends StatefulWidget {
  const ScenarioSimulatorPage({super.key});

  @override
  State<ScenarioSimulatorPage> createState() => _ScenarioSimulatorPageState();
}

class _ScenarioSimulatorPageState extends State<ScenarioSimulatorPage> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _allScenarios = [
    {
      'scenario': 'You walk into a crowded party alone and don\'t know anyone.',
      'options': [
        {'text': 'Stand in the corner and scroll on your phone.', 'optimal': false},
        {'text': 'Find the host or a small group, smile, and introduce yourself.', 'optimal': true},
        {'text': 'Immediately leave and go home.', 'optimal': false},
      ],
      'explanation': 'Approaching a small group or the host shows confidence and openness, breaking the ice effectively.',
    },
    {
      'scenario': 'You forgot the name of someone you just met 5 minutes ago.',
      'options': [
        {'text': 'Avoid saying their name the entire night.', 'optimal': false},
        {'text': 'Guess their name and hope you get it right.', 'optimal': false},
        {'text': 'Admit it politely: "I am so sorry, I completely blanked on your name."', 'optimal': true},
      ],
      'explanation': 'Being honest and vulnerable is a strong social skill that builds trust.',
    },
    {
      'scenario': 'A colleague gives you constructive criticism on your project.',
      'options': [
        {'text': 'Get defensive and explain why they are wrong.', 'optimal': false},
        {'text': 'Listen actively, thank them, and ask for clarifying examples.', 'optimal': true},
        {'text': 'Agree but secretly resent them.', 'optimal': false},
      ],
      'explanation': 'Active listening and asking for examples shows maturity and a growth mindset.',
    },
    {
      'scenario': 'You are at a networking event and a conversation goes silent.',
      'options': [
        {'text': 'Ask an open-ended question about their interests or work.', 'optimal': true},
        {'text': 'Stare at them until they speak.', 'optimal': false},
        {'text': 'Excuse yourself awkwardly and walk away.', 'optimal': false},
      ],
      'explanation': 'Open-ended questions invite the other person to share and keeps the momentum going.',
    },
    {
      'scenario': 'Someone makes a joke at your expense in front of a group.',
      'options': [
        {'text': 'Insult them back aggressively.', 'optimal': false},
        {'text': 'Laugh it off or playfully agree, maintaining your composure.', 'optimal': true},
        {'text': 'Show you are visibly upset and storm off.', 'optimal': false},
      ],
      'explanation': 'Owning the joke or playfully agreeing defuses the tension and shows high social status and confidence.',
    },
  ];

  late Map<String, dynamic> _currentScenario;
  bool _answered = false;
  bool _isCorrect = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _loadRandomScenario();
  }

  void _loadRandomScenario() {
    setState(() {
      _answered = false;
      _currentScenario = _allScenarios[Random().nextInt(_allScenarios.length)];
      // Shuffle options
      (_currentScenario['options'] as List).shuffle();
    });
    _controller.forward(from: 0.0);
  }

  void _handleOptionSelected(bool isOptimal) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _isCorrect = isOptimal;
    });

    if (isOptimal) {
      context.read<AppProvider>().completeMission(10, 15);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Optimal response! +10 XP, +15 Credits 🌟'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not quite. Read the explanation to learn why!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Scenario Simulator',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFBB86FC).withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFBB86FC).withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.psychology, size: 48, color: Color(0xFFBB86FC)),
                    const SizedBox(height: 16),
                    Text(
                      _currentScenario['scenario'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ...(_currentScenario['options'] as List).map((option) {
                final bool isOptimal = option['optimal'];
                Color buttonColor = const Color(0xFF2C2C2C);
                Color borderColor = Colors.transparent;

                if (_answered) {
                  if (isOptimal) {
                    buttonColor = Colors.green.withOpacity(0.2);
                    borderColor = Colors.green;
                  } else if (!isOptimal && !_isCorrect) { // Just to highlight wrong choices slightly if we want
                    buttonColor = Colors.red.withOpacity(0.1);
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () => _handleOptionSelected(isOptimal),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Text(
                        option['text'],
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
              if (_answered) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _isCorrect ? Colors.green : Colors.redAccent),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isCorrect ? 'Awesome!' : 'Learning Opportunity',
                        style: TextStyle(
                          color: _isCorrect ? Colors.greenAccent : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentScenario['explanation'],
                        style: const TextStyle(color: Colors.white, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _loadRandomScenario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBB86FC),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Next Scenario', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
