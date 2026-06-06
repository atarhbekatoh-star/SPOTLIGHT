import 'package:flutter/material.dart';

import '../controllers/mission_board_controller.dart';
import '../widgets/mission_card.dart';

/// Practice Page: Magazine-style Mission Board interface.
/// Scrollable layout with purple and black theme.
class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  late MissionBoardController _controller;
  int _selectedExposureLevel = 1;
  late ScrollController _scrollController;

  // Color Theme: Purple and Black
  static const Color primaryPurple = Color(0xFF7B3FF2);
  static const Color accentPurple = Color(0xFF9D5FFF);
  static const Color darkPurpleBlack = Color(0xFF1a1a2e);
  static const Color deepBlack = Color(0xFF0A0A14);

  @override
  void initState() {
    super.initState();
    _controller = MissionBoardController(initialMaxExposureLevel: 1);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFF9D5FFF);
      case 2:
        return const Color(0xFFB080FF);
      case 3:
        return const Color(0xFFC9A0FF);
      case 4:
        return const Color(0xFFE0C3FF);
      default:
        return primaryPurple;
    }
  }

  String _getLevelName(int level) {
    switch (level) {
      case 1:
        return 'Reconnaissance';
      case 2:
        return 'Infiltration';
      case 3:
        return 'Verbal';
      case 4:
        return 'Interaction';
      default:
        return 'Unknown';
    }
  }

  void _showLevelUpModal() {
    if (_selectedExposureLevel < 4) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: darkPurpleBlack,
          title: const Text(
            'Level Up! 🎉',
            style: TextStyle(
              color: accentPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'You\'ve conquered level $_selectedExposureLevel! Ready for level ${_selectedExposureLevel + 1}?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Not Yet'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedExposureLevel++;
                  _controller.unlockExposureLevel(_selectedExposureLevel);
                  _controller.generateNewDailyBoard();
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Unlock It!'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlack,
      appBar: AppBar(
        backgroundColor: darkPurpleBlack,
        elevation: 8,
        shadowColor: primaryPurple.withValues(alpha: 0.5),
        title: const Text(
          '🎮 Mission Board',
          style: TextStyle(
            color: accentPurple,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Center(
                child: Text(
                  '⭐ ${_controller.totalXpEarned} XP',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: accentPurple,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final summary = _controller.getDaySummary();
          final missions = _controller.activeMissionBoard;
          final allProgress = _controller.allMissionProgress;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ========== MAGAZINE HEADER ==========
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryPurple, accentPurple],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: darkPurpleBlack,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📖 MISSION MAGAZINE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: accentPurple,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '📋 Today\'s Briefing',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Available: ${summary['availableCount']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Rerolls: ${summary['rerollsRemaining']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Completed: ${summary['missionsCompleted']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Attempted: ${summary['missionsAttempted']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ========== EXPOSURE LEVEL SECTION ==========
                  const Text(
                    '📊 Current Exposure Level',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: accentPurple,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getLevelColor(_controller.userCurrentMaxExposureLevel),
                          primaryPurple,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: darkPurpleBlack,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Level ${_controller.userCurrentMaxExposureLevel}: ${_getLevelName(_controller.userCurrentMaxExposureLevel)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _getLevelColor(_controller
                                      .userCurrentMaxExposureLevel),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Unlock higher levels as you progress',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                          if (_controller.userCurrentMaxExposureLevel < 4)
                            ElevatedButton(
                              onPressed: _showLevelUpModal,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text(
                                'Level Up',
                                style: TextStyle(fontSize: 12),
                              ),
                            )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: accentPurple.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '👑 Max Level',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: accentPurple,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ========== ACTIVE MISSIONS ==========
                  const Text(
                    '🎯 Active Missions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentPurple,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (missions.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: darkPurpleBlack,
                        border: Border.all(
                          color: primaryPurple,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🎉 All missions completed!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: accentPurple,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () =>
                                _controller.generateNewDailyBoard(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryPurple,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Generate New Board'),
                          ),
                        ],
                      ),
                    )
                    else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: missions.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final mission = missions[index];
                        final progress = allProgress[mission.id];

                        return MissionCard(
                          mission: mission,
                          missionProgress: progress!,
                          controller: _controller,
                          onCompleted: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '✅ Mission cleared! +${mission.successXp} XP',
                                ),
                                backgroundColor: accentPurple,
                                duration:
                                    const Duration(milliseconds: 1500),
                              ),
                            );
                          },
                          onAttempted: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '💪 Good effort! +${mission.courageXp} courage XP',
                                ),
                                backgroundColor: primaryPurple,
                                duration:
                                    const Duration(milliseconds: 1500),
                              ),
                            );
                          },
                          onReroll: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  '🔄 Mission swapped! Remember: one reroll per day.',
                                ),
                                duration: Duration(milliseconds: 1500),
                              ),
                            );
                          },
                        );
                      },
                    ),

                  const SizedBox(height: 24),

                  // ========== COMPLETED MISSIONS ==========
                  if (_controller.resolvedMissions.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '✨ Completed Today',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: accentPurple,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryPurple, accentPurple],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: darkPurpleBlack,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: _controller.resolvedMissions
                                  .map((progress) {
                                    final mission = missions.firstWhere(
                                      (m) => m.id == progress.missionId,
                                      orElse: () => missions.isNotEmpty
                                          ? missions.first
                                          : throw Exception(
                                              'Mission not found'),
                                    );
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        children: [
                                          Text(
                                            progress.state.emoji,
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              mission.title,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '+${progress.xpEarned} XP',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: accentPurple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 32),

                  // ========== MOTIVATIONAL FOOTER ==========
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryPurple.withValues(alpha: 0.5),
                          accentPurple.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: darkPurpleBlack,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '💡 Remember',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: accentPurple,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Every attempt, every small step, every moment you show up—that\'s courage. You don\'t need to be perfect. You just need to try.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white60,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
