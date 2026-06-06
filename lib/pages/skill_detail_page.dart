import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/skill_models.dart';
import '../providers/app_provider.dart';

class SkillDetailPage extends StatelessWidget {
  final SkillCategory category;
  final int categoryIndex;

  const SkillDetailPage({super.key, required this.category, required this.categoryIndex});

  void _showMissionDetail(BuildContext context, Mission mission) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _MissionDetailSheet(mission: mission, categoryColor: category.color, categoryIndex: categoryIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          category.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Complete daily missions to break through social anxiety and build new habits.",
              style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: category.missions.length,
              itemBuilder: (context, index) {
                final mission = category.missions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () => _showMissionDetail(context, mission),
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16161A),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: mission.isCompleted
                              ? category.color.withAlpha(100)
                              : Colors.white.withAlpha(20),
                        ),
                        boxShadow: mission.isCompleted
                            ? [
                                BoxShadow(
                                  color: category.color.withAlpha(20),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: mission.isCompleted
                                  ? category.color.withAlpha(30)
                                  : const Color(0xFF0D0D0F),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: mission.isCompleted
                                    ? category.color
                                    : Colors.white.withAlpha(30),
                              ),
                            ),
                            child: Center(
                              child: mission.isCompleted
                                  ? Icon(Icons.check, color: category.color, size: 20)
                                  : Text(
                                      "${mission.day}",
                                      style: TextStyle(
                                        color: Colors.white.withAlpha(150),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mission.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Day ${mission.day} • ${mission.xpReward} XP",
                                  style: TextStyle(
                                    color: category.color.withAlpha(200),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white.withAlpha(50),
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionDetailSheet extends StatefulWidget {
  final Mission mission;
  final Color categoryColor;
  final int categoryIndex;

  const _MissionDetailSheet({
    required this.mission,
    required this.categoryColor,
    required this.categoryIndex,
  });

  @override
  State<_MissionDetailSheet> createState() => _MissionDetailSheetState();
}

class _MissionDetailSheetState extends State<_MissionDetailSheet> {
  void _completeMission() {
    if (!widget.mission.isCompleted) {
      setState(() {
        widget.mission.isCompleted = true;
      });
      Provider.of<AppProvider>(context, listen: false)
          .completePracticeTask(widget.categoryIndex, widget.mission.xpReward, widget.mission.creditReward);
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mission Complete! +${widget.mission.xpReward} XP"),
          backgroundColor: widget.categoryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color(0xFF16161A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Day ${widget.mission.day}",
                  style: TextStyle(
                    color: widget.categoryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: widget.categoryColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "+${widget.mission.xpReward} XP",
                    style: TextStyle(
                      color: widget.categoryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.mission.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Mission",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.mission.description,
              style: TextStyle(
                color: Colors.white.withAlpha(200),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0D0F),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: widget.categoryColor.withAlpha(50)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.psychology, color: widget.categoryColor, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        "The Psychology",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.mission.psychology,
                    style: TextStyle(
                      color: Colors.white.withAlpha(180),
                      fontSize: 13,
                      height: 1.4,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.mission.isCompleted ? null : _completeMission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.categoryColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  disabledBackgroundColor: widget.categoryColor.withAlpha(50),
                ),
                child: Text(
                  widget.mission.isCompleted ? "Completed" : "Complete Mission",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
