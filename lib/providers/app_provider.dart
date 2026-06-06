import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  int xp = 0;
  int credits = 0;
  List<String> unlockedItems = [];

  AppProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    xp = prefs.getInt('xp') ?? 0;
    credits = prefs.getInt('credits') ?? 0;
    unlockedItems = prefs.getStringList('unlockedItems') ?? [];
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', xp);
    await prefs.setInt('credits', credits);
    await prefs.setStringList('unlockedItems', unlockedItems);
  }

  void completeMission(int xpToAdd, int creditsToAdd) {
    xp += xpToAdd;
    credits += creditsToAdd;
    _saveData();
    notifyListeners();
  }

  bool purchaseItem(String itemId, int cost) {
    if (credits >= cost && !unlockedItems.contains(itemId)) {
      credits -= cost;
      unlockedItems.add(itemId);
      _saveData();
      notifyListeners();
      return true;
    }
    return false;
  }

  int get level => (xp / 100).floor() + 1;
  int get nextLevelXp => level * 100;
  double get progressToNextLevel => (xp % 100) / 100;

  String get currentRank {
    switch (level) {
      case 1:
        return 'The Observer';
      case 2:
        return 'Wallflower';
      case 3:
        return 'Conversationalist';
      case 4:
        return 'Social Butterfly';
      case 5:
        return 'Charismatic Leader';
      default:
        return 'Main Character';
    }
  }

  Future<bool> claimDailyReward() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastClaimDate = prefs.getString('last_claim_date');

    if (lastClaimDate != today) {
      credits += 25;
      await prefs.setString('last_claim_date', today);
      _saveData();
      notifyListeners();
      return true;
    }
    return false;
  }
}
