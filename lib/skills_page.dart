import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'models/skill_models.dart';
import 'pages/skill_detail_page.dart';
import 'pages/scenario_simulator_page.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  late List<SkillCategory> categories;

  @override
  void initState() {
    super.initState();
    categories = getSkillCategories();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final isPracticeLocked = appProvider.isPracticeLocked;
    final currentPracticeStep = appProvider.currentPracticeStep;
    final remainingTime = appProvider.practiceLockRemainingTime;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Practice",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Social Simulator Mini-Game Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScenarioSimulatorPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E1E1E), Color(0xFF2C2C2C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFBB86FC).withOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFBB86FC).withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBB86FC).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.videogame_asset, color: Color(0xFFBB86FC), size: 32),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Social Simulator",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Play the mini-game to earn XP and Credits!",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.play_arrow, color: Color(0xFFBB86FC), size: 28),
                  ],
                ),
              ),
            ),
          ),

          // The active "Task to Practice" section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFBB86FC), Color(0xFF6200EA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFBB86FC).withAlpha(50),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.psychology,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Daily Introvert Challenge",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "5 Min",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "The Easy Ask",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Ask a barista or cashier how their day is going. Low-stakes interactions build momentum without overwhelming your amygdala.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isPracticeLocked ? null : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SkillDetailPage(category: categories[0], categoryIndex: 0),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6200EA),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Start Challenge",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "SKILL CATEGORIES",
                  style: TextStyle(
                    color: Colors.white.withAlpha(150),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                if (isPracticeLocked)
                  Text(
                    "Locked - Come back in $remainingTime",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildVerticalSkillCard(context, categories[index], index, currentPracticeStep, isPracticeLocked);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalSkillCard(BuildContext context, SkillCategory category, int index, int currentStep, bool isPracticeLocked) {
    int completedCount = category.missions.where((m) => m.isCompleted).length;
    int totalCount = category.missions.length;
    double progress = totalCount > 0 ? completedCount / totalCount : 0;

    // Strict Sequence: Persuasion (index 4) isn't explicitly in the 0-3 loop, 
    // but if we are at step 4 it's locked. We just let it be locked if index != currentStep
    bool isLocked = isPracticeLocked || index != currentStep;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
        child: InkWell(
          onTap: isLocked ? () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isPracticeLocked ? "Practice is locked for 24 hours. Come back tomorrow!" : "Complete the previous category first!"),
                backgroundColor: Colors.orange,
              ),
            );
          } : () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SkillDetailPage(category: category, categoryIndex: index),
              ),
            ).then((_) {
              // Refresh to show updated progress
              setState(() {});
            });
          },
          borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: category.color.withAlpha(30),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: category.color.withAlpha(30),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category.subtitle,
                          style: TextStyle(
                            color: Colors.white.withAlpha(150),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLocked)
                    Icon(
                      Icons.lock,
                      color: Colors.white.withAlpha(100),
                      size: 16,
                    )
                  else
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withAlpha(100),
                      size: 14,
                    ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Day $completedCount of $totalCount",
                    style: TextStyle(
                      color: Colors.white.withAlpha(150),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(
                      color: category.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFF0D0D0F),
                  color: category.color,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
