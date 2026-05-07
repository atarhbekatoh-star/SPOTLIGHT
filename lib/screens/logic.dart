import 'package:flutter/material.dart';

// --- STREAK LOGIC ---
class StreakManager {
  int updateStreak({required DateTime lastLogin, required int currentStreak}) {
    final now = DateTime.now();
    final int hoursPassed = now.difference(lastLogin).inHours;

    if (hoursPassed > 48) return 1; // Reset if > 2 days
    if (hoursPassed >= 24) return currentStreak + 1; // Increment if 1-2 days
    return currentStreak; // Maintain if < 24h
  }
}

// --- MISSION OOP MODELS ---
abstract class Mission {
  final int id;
  final String title;
  final IconData icon;
  final Color color;

  Mission({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class ObservationalMission extends Mission {
  ObservationalMission({required int id, required String title})
    : super(
        id: id,
        title: title,
        icon: Icons.visibility,
        color: Colors.blueAccent,
      );
}

class InteractionMission extends Mission {
  InteractionMission({required int id, required String title})
    : super(id: id, title: title, icon: Icons.forum, color: Colors.greenAccent);
}

class PublicMission extends Mission {
  PublicMission({required int id, required String title})
    : super(
        id: id,
        title: title,
        icon: Icons.campaign,
        color: Colors.orangeAccent,
      );
}
