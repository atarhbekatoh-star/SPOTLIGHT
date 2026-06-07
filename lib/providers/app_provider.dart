import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database_helper.dart';

class AppProvider extends ChangeNotifier {
  int xp = 0;
  int credits = 0;
  List<String> unlockedItems = [];
  ThemeMode themeMode = ThemeMode.dark;

  int _practiceStep = 0;
  String? _lastPracticeDate;
  int _rewardStreak = 0;
  String? _lastClaimDate;
  bool isPersuasionUnlocked = false;

  // Social connection statuses cache: username -> status map
  final Map<String, Map<String, bool>> _connectionStatuses = {};

  AppProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    xp = prefs.getInt('xp') ?? 0;
    credits = prefs.getInt('credits') ?? 0;
    unlockedItems = prefs.getStringList('unlockedItems') ?? [];
    
    _practiceStep = prefs.getInt('practice_step') ?? 0;
    _lastPracticeDate = prefs.getString('last_practice_date');
    _rewardStreak = prefs.getInt('rewardStreak') ?? 0;
    _lastClaimDate = prefs.getString('lastClaimDate');
    isPersuasionUnlocked = prefs.getBool('persuasion_unlocked') ?? true;

    final savedTheme = prefs.getString('themeMode');
    if (savedTheme == 'light') {
      themeMode = ThemeMode.light;
    } else if (savedTheme == 'system') {
      themeMode = ThemeMode.system;
    } else {
      themeMode = ThemeMode.dark;
    }
    _checkPracticeLock();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', xp);
    await prefs.setInt('credits', credits);
    await prefs.setStringList('unlockedItems', unlockedItems);
    await prefs.setInt('practice_step', _practiceStep);
    if (_lastPracticeDate != null) {
      await prefs.setString('last_practice_date', _lastPracticeDate!);
    } else {
      await prefs.remove('last_practice_date');
    }
    await prefs.setInt('rewardStreak', _rewardStreak);
    if (_lastClaimDate != null) {
      await prefs.setString('lastClaimDate', _lastClaimDate!);
    }
    await prefs.setBool('persuasion_unlocked', isPersuasionUnlocked);
  }

  void resetData() {
    xp = 0;
    credits = 0;
    unlockedItems = [];
    _practiceStep = 0;
    _lastPracticeDate = null;
    _rewardStreak = 0;
    _lastClaimDate = null;
    isPersuasionUnlocked = false;
    _connectionStatuses.clear();
    notifyListeners();
  }

  void unlockPersuasion() {
    isPersuasionUnlocked = true;
    _saveData();
    notifyListeners();
  }

  void completeMission(int xpToAdd, int creditsToAdd) {
    xp += xpToAdd;
    credits += creditsToAdd;
    _saveData();
    notifyListeners();
  }

  void completePracticeTask(int categoryIndex, int xpToAdd, int creditsToAdd) {
    _checkPracticeLock();
    if (_practiceStep >= 4) return;
    if (categoryIndex != _practiceStep) return;

    xp += xpToAdd;
    credits += creditsToAdd;
    _practiceStep++;

    if (xp >= 30 && !isPersuasionUnlocked) {
      isPersuasionUnlocked = true;
    }

    if (_practiceStep >= 4) {
       _lastPracticeDate = DateTime.now().toIso8601String();
    }
    
    _saveData();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode == ThemeMode.light ? 'light' : (mode == ThemeMode.system ? 'system' : 'dark'));
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

  void _checkPracticeLock() {
    if (_practiceStep >= 4 && _lastPracticeDate != null) {
      final lastDate = DateTime.parse(_lastPracticeDate!);
      if (DateTime.now().difference(lastDate).inHours >= 24) {
        _practiceStep = 0;
        _lastPracticeDate = null;
        _saveData();
      }
    }
  }

  int get currentPracticeStep {
    _checkPracticeLock();
    return _practiceStep;
  }

  bool get isPracticeLocked {
    _checkPracticeLock();
    return _practiceStep >= 4;
  }

  String get practiceLockRemainingTime {
    if (_lastPracticeDate == null) return "0h 0m";
    final lastDate = DateTime.parse(_lastPracticeDate!);
    final unlockTime = lastDate.add(const Duration(hours: 24));
    final diff = unlockTime.difference(DateTime.now());
    if (diff.isNegative) return "0h 0m";
    return "${diff.inHours}h ${diff.inMinutes.remainder(60)}m";
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

  int get rewardStreak => _rewardStreak;
  String? get lastClaimDate => _lastClaimDate;

  bool get canClaimDailyReward {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return _lastClaimDate != today;
  }

  Future<bool> claimDailyReward() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (_lastClaimDate != today) {
      if (_lastClaimDate != null) {
        final last = DateTime.parse(_lastClaimDate!);
        final now = DateTime.now();
        final diff = DateTime(now.year, now.month, now.day)
            .difference(DateTime(last.year, last.month, last.day))
            .inDays;
        if (diff > 1) {
          _rewardStreak = 0;
        }
      }

      int currentDay = _rewardStreak % 7;
      int rewardCredits = (currentDay + 1) * 10;
      if (currentDay == 6) {
        rewardCredits = 100;
      }

      credits += rewardCredits;
      _rewardStreak++;
      _lastClaimDate = today;
      
      await _saveData();
      notifyListeners();
      return true;
    }
    return false;
  }

  // ========================
  // SOCIAL METHODS
  // ========================

  Map<String, bool>? getConnectionStatus(String username) {
    return _connectionStatuses[username];
  }

  Future<void> loadConnectionStatus(String me, String them) async {
    final status = await DatabaseHelper.instance.checkConnectionStatus(me, them);
    _connectionStatuses[them] = status;
    notifyListeners();
  }

  Future<void> sendFriendRequest(String me, String them) async {
    await DatabaseHelper.instance.sendFriendRequest(me, them);
    await loadConnectionStatus(me, them);
  }

  Future<void> cancelFriendRequest(String me, String them) async {
    await DatabaseHelper.instance.cancelFriendRequest(me, them);
    await loadConnectionStatus(me, them);
  }

  Future<void> acceptFriendRequest(String sender, String me) async {
    await DatabaseHelper.instance.acceptFriendRequest(sender, me);
    await loadConnectionStatus(me, sender);
  }

  Future<void> followUser(String me, String them) async {
    await DatabaseHelper.instance.followUser(me, them);
    await loadConnectionStatus(me, them);
  }

  Future<void> unfollowUser(String me, String them) async {
    await DatabaseHelper.instance.unfollowUser(me, them);
    await loadConnectionStatus(me, them);
  }
}
